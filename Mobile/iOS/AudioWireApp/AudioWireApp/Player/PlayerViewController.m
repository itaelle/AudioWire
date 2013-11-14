//
//  PlayerViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PlayerViewController.h"


@implementation PlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Player", @"");
        needASubPlayer = NO;
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect label = _labelTopPlaying.frame;
    label.origin.x = 0;
    label.size = [_labelTopPlaying.text sizeWithFont:FONTSIZE(17)];
    [_labelTopPlaying setFrame:label];
    [self startTimer];
    
//    isPlaying = [musicPlayer isPlaying];
    isFlipped = false;
    
    if (musicPlayer)
    {
        [self setUpPlayer];
        [musicPlayer update];

        if (!musicPlayer.playlist || [musicPlayer.playlist count] == 0)
        {
            [self.repeatButton setAlpha:0];
            [self.shuffleButton setAlpha:0];
        }
    }
    
    if (!IS_OS_7_OR_LATER)
    {
        CGRect rectTopView = self.topView.frame;
        rectTopView.origin.y -= 64;
        [self.topView setFrame:rectTopView];
        
        CGRect rectJacketView = self.jacketView.frame;
        rectJacketView.origin.y -= 64;
        rectJacketView.size.height += 64;
        [self.jacketView setFrame:rectJacketView];
        
        CGRect rectImgAlbumBg = self.im_bg_album.frame;
        rectImgAlbumBg.origin.y -= 64;
        rectImgAlbumBg.size.height += 64;
        [self.im_bg_album setFrame:rectImgAlbumBg];
    }
    
    CGRect jacketViewFrame = _jacketView.frame;
    if (jacketViewFrame.size.height < jacketViewFrame.size.width)
    {
        jacketViewFrame.size.height += 16;
        jacketViewFrame.origin.y -= 16/2;
        jacketViewFrame.size.width = jacketViewFrame.size.height;
        
    }
    jacketViewFrame.origin.x = self.view.frame.size.width/2 -jacketViewFrame.size.width/2;
    [_jacketView setFrame:jacketViewFrame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavLogo];
    [self setUpPlayer];
    [self setUpSlider];
    [self setUpViews];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTimer];
}

-(void)dealloc
{
    [self stopTimer];
}

-(void)flipJacketView
{
    [_jacketImg setAlpha:1];
    [UIView transitionWithView:_jacketImg duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
    } completion:^(BOOL finished) {
        if (finished)
        {
            [_im_bg_album setAlpha:0.15];
            [UIView transitionWithView:_im_bg_album duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                
            } completion:nil];
        }
    }];
}

-(void)setUpPlayer
{
    if (musicPlayer)
    {
        musicPlayer.delegate = nil;
        musicPlayer = nil;
    }
    
    musicPlayer = [AWMusicPlayer getInstance];
    musicPlayer.delegate = self;
}

-(void) setUpSlider
{
    _sliderVolume.popupView.hidden = true;
    _isSliderVolumeOpened = false;
    _sliderPlayingMedia.minimumValue = 0.0f;
    _sliderPlayingMedia.value = 0.0f;
    _sliderPlayingMedia.valueString = @"00:00";
    _labelMinutesPlayed.text = @"00:00";
}

- (void) setUpViews
{
    // Jacket
    [_jacketView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    _jacketView.layer.borderColor = [[UIColor blackColor] CGColor];
    _jacketView.layer.borderWidth = 1;
    [_jacketImg setAlpha:0];
    [_im_bg_album setAlpha:0];
    
    // Slider Volume Placement
    CGRect sliderPos = _viewSlider.frame;
    sliderPos.origin.x = _viewSlider.frame.origin.x + _viewSlider.frame.size.width;
    [_viewSlider setFrame:sliderPos];
    _viewSlider.layer.borderWidth = 1;
    _viewSlider.layer.borderColor = [[UIColor blackColor] CGColor];
    _viewSlider.layer.cornerRadius = 10;
    [_viewSlider setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    
    CGRect sliderFrame = _sliderVolume.frame;
    if (!IS_OS_7_OR_LATER)
    {
        sliderFrame.origin.y += 3;
        [_sliderVolume setFrame:sliderFrame];
    }
    
    // Labels set up
    CGRect label = _labelTopPlaying.frame;
    label.origin.x = 0;
    label.size = [_labelTopPlaying.text sizeWithFont:FONTSIZE(17)];
    [_labelTopPlaying setFrame:label];
}

-(void)startTimer
{
    [self stopTimer];
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:DELAY_BEFORE_SLIDING_TITLE] interval:0.1 target:self selector:@selector(timerFinish:) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

-(void)stopTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)timerFinish:(NSTimer*)theTimer
{
    CGRect labelTopFrame = _labelTopPlaying.frame;
    if (labelTopFrame.origin.x + labelTopFrame.size.width > 0)
        labelTopFrame.origin.x -= 4;
    else
        labelTopFrame.origin.x = _VolumeButton.frame.origin.x;
    
    if (labelTopFrame.origin.x == _VolumeButton.frame.origin.x)
        [_labelTopPlaying setFrame:labelTopFrame];
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            [_labelTopPlaying setFrame:labelTopFrame];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)clickPlayerButton:(id)sender
{
    NSLog(@"CLick play => %d", isPlaying);
    if (isPlaying == NO)
    {
        [musicPlayer play];
    }
    else
    {
        [musicPlayer pause];
    }
}

- (IBAction)clickPreviousButton:(id)sender
{
    [musicPlayer prev];
}

- (IBAction)clickNextButton:(id)sender
{
    [musicPlayer next];
}

- (IBAction)clickRepeatButton:(id)sender
{
    [musicPlayer repeat];
}

- (IBAction)clickShuffleButton:(id)sender
{
    [musicPlayer shuffle];
}

- (IBAction)clickSoundIcon:(id)sender
{
    if (_isSliderVolumeOpened == false)
    {
        CGRect sliderOpened = _viewSlider.frame;
        sliderOpened.origin.x = 0;
        _isSliderVolumeOpened = true;
        
        [UIView animateWithDuration:(0.1) animations:^{
            [_labelTopPlaying setAlpha:0];
        } completion:^(BOOL finished) {
            if (finished)
            {
                [UIView animateWithDuration:(0.5) animations:^{
                    [_viewSlider setFrame:sliderOpened];
                }];
            }
        }];
    }
    else
    {
        CGRect sliderPos = _viewSlider.frame;
        sliderPos.origin.x = _viewSlider.frame.origin.x + _viewSlider.frame.size.width;
        
        
        [UIView animateWithDuration:(0.5) animations:^{
            [_viewSlider setFrame:sliderPos];
        } completion:^(BOOL finished) {
            if (finished)
            {
                [UIView animateWithDuration:(0.2) animations:^{
                    [_labelTopPlaying setAlpha:1];
                }];
                _isSliderVolumeOpened = false;
            }
        }];
        
    }
}
- (IBAction)beginDragMusicPlayingOffset:(id)sender
{
    [musicPlayer startEditing];
}

- (IBAction)endDragMusicPlayingOffset:(id)sender
{
    if (sender && [sender isKindOfClass:[ANPopoverSlider class]])
    {
        ANPopoverSlider *temp = sender;
        NSNumber *value = [NSNumber numberWithFloat:temp.value];
        int diff = [value intValue];
        int forHours = diff / 3600;
        int remainder = diff % 3600;
        int forMinutes = remainder / 60;
        int forSeconds = remainder % 60;
        
        if (forHours == 0)
        {
            self.sliderPlayingMedia.valueString = [NSString stringWithFormat:@"%02d:%02d", forMinutes, forSeconds];
        }
        else
        {
            self.sliderPlayingMedia.valueString = [NSString stringWithFormat:@"%d:%02d:%02d", forHours, forMinutes, forSeconds];
        }
        [musicPlayer setNewTimeToPlay:value];
    }
    [musicPlayer endEditing];
//    [self setFlashMessage:self.sliderPlayingMedia.valueString];
}

- (IBAction)dragMusicPlayingOffset:(ANPopoverSlider *)sender
{
    if (sender && [sender isKindOfClass:[ANPopoverSlider class]])
    {
        ANPopoverSlider *temp = sender;
        NSNumber *value = [NSNumber numberWithFloat:temp.value];
        
        int diff = [value intValue];
        int forHours = diff / 3600;
        int remainder = diff % 3600;
        int forMinutes = remainder / 60;
        int forSeconds = remainder % 60;
        
        if (forHours == 0)
        {
            self.sliderPlayingMedia.valueString = [NSString stringWithFormat:@"%02d:%02d", forMinutes, forSeconds];
        }
        else
        {
            self.sliderPlayingMedia.valueString = [NSString stringWithFormat:@"%d:%02d:%02d", forHours, forMinutes, forSeconds];
        }
    }
}

- (IBAction)dragVolume:(id)sender
{
    if (sender && [sender isKindOfClass:[ANPopoverSlider class]])
    {
        ANPopoverSlider *temp = sender;
        float value = temp.value;
        [musicPlayer setVolume:[NSNumber numberWithFloat:(value/100)]];
    }
}

#pragma AWMusicPlayerDelegate
-(void)updateSliderValue:(NSNumber *)current_ forMax:(NSNumber *)max_
{
    self.sliderPlayingMedia.maximumValue = [max_ floatValue];

    if (musicPlayer.isEditingPlayingOffset == NO)
        self.sliderPlayingMedia.value = [current_ floatValue];
    
    int diff = [current_ intValue];
    int forHours = diff / 3600;
    int remainder = diff % 3600;
    int forMinutes = remainder / 60;
    int forSeconds = remainder % 60;
    
    if (forHours == 0)
    {
        if (musicPlayer.isEditingPlayingOffset == NO)
            self.sliderPlayingMedia.valueString = [NSString stringWithFormat:@"%02d:%02d", forMinutes, forSeconds];
        self.labelMinutesPlayed.text = [NSString stringWithFormat:@"%02d:%02d", forMinutes, forSeconds];
    }
    else
    {
        if (musicPlayer.isEditingPlayingOffset == NO)
            self.sliderPlayingMedia.valueString = [NSString stringWithFormat:@"%d:%02d:%02d", forHours, forMinutes, forSeconds];
        
        self.labelMinutesPlayed.text = [NSString stringWithFormat:@"%d:%02d:%02d", forHours, forMinutes, forSeconds];
    }
}

-(void)updateVolumeValue:(NSNumber *)current_
{
    [_sliderVolume setValue:([current_ floatValue]*100) animated:TRUE];
}

-(void)updateMediaInfo:(MPMediaItem *)item_
{
    NSLog(@"updateMediaInfo controller");
    NSString *artist = [item_ valueForProperty:MPMediaItemPropertyArtist];
    NSString *title = [item_ valueForProperty:MPMediaItemPropertyTitle];
    NSString *albumTitle = [item_ valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    if (artist && title && albumTitle)
        [_labelTopPlaying setText:[NSString stringWithFormat:@"%@ - %@ [%@]",
                               title, artist, albumTitle]];
    else if (artist && title)
        [_labelTopPlaying setText:[NSString stringWithFormat:@"%@ - %@",
                                   title, artist]];
    else if (title)
        [_labelTopPlaying setText:[NSString stringWithFormat:@"%@",
                                   title]];
    else
        [_labelTopPlaying setText:@""];
    
    [self stopTimer];
    CGRect label = _labelTopPlaying.frame;
    label.origin.x = 0; //_VolumeButton.frame.origin.x;
    label.size = [_labelTopPlaying.text sizeWithFont:FONTSIZE(17)];
    [_labelTopPlaying setFrame:label];
    [self startTimer];
    
    UIImage *artworkImageLarge = [UIImage imageNamed:@"noArtworkImageLarge.png"];
    UIImage *artworkImageSmall = [UIImage imageNamed:@"noArtworkImageSmall.png"];
	MPMediaItemArtwork *artwork = [item_ valueForProperty:MPMediaItemPropertyArtwork];
    
	if (artwork)
    {
		artworkImageLarge = [artwork imageWithSize: CGSizeMake (400, 400)];
        artworkImageSmall = [artwork imageWithSize: CGSizeMake (200, 200)];
    }
    [_jacketImg setImage:artworkImageSmall];
    [_im_bg_album setImage:artworkImageLarge];
    
    
    [self flipJacketView];
}

-(void) play:(id)sender
{
    NSLog(@"Play delegate controller");
    isPlaying = YES;
    [_playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
}

-(void) pause:(id)sender
{
    NSLog(@"Pause delegate controller");
    isPlaying = NO;
    [_playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
}

-(void) stop:(id)sender
{
    NSLog(@"Stop delegate controller");
    isPlaying = NO;
}

@end
