//
//  SubPlayer.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ANPopOverSlider.h"
#import "PlayerViewController.h"
#import "SubPlayer.h"

@implementation SubPlayer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(void) myInit
{
    isPlaying = false;
    isSoundOpen = false;
    
    [self setUpPlayer];
    [self setUpViews];
}

-(void)setUpPlayer
{
    musicPlayer = [AWMusicPlayer getInstance];
    musicPlayer.delegate = self;
    [musicPlayer start];
}

- (void) setUpViews
{
    // Slider Volume Placement
    _sliderVolume.popupView.hidden = true;
    CGRect sliderPos = _viewSlider.frame;
    sliderPos.origin.x = _viewSlider.frame.origin.x + _viewSlider.frame.size.width;
    [_viewSlider setFrame:sliderPos];
    _viewSlider.layer.borderWidth = 1;
    _viewSlider.layer.borderColor = [[UIColor blackColor] CGColor];
    _viewSlider.layer.cornerRadius = 10;
    [_viewSlider setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];

    if (!IS_OS_7_OR_LATER)
    {
        CGRect rectSlider = self.sliderVolume.frame;
        rectSlider.origin.y += 3;
        [self.sliderVolume setFrame:rectSlider];
    }
    
    CGRect label = _lbMusicPlaying.frame;
    label.size = [_lbMusicPlaying.text sizeWithFont:FONTBOLDSIZE(17)];
    label.size.width += 10;
    [_lbMusicPlaying setFrame:label];
    
    if (!_timer)
    {
        NSDate *run = [NSDate dateWithTimeIntervalSinceNow:DELAY_BEFORE_SLIDING_TITLE];
        
        _timer = [[NSTimer alloc] initWithFireDate:run interval:0.1 target:self selector:@selector(timerFinish:) userInfo:nil repeats:true];
        
        NSRunLoop * theRunLoop = [NSRunLoop currentRunLoop];
        [theRunLoop addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    else
    {
        // Quand il relancé.
    }
}

-(IBAction) timerFinish:(id) sender
{
    CGRect labelTopFrame = _lbMusicPlaying.frame;
    if (labelTopFrame.origin.x + labelTopFrame.size.width > 0)
        labelTopFrame.origin.x -= 4;
    else
        labelTopFrame.origin.x = _soundButton.frame.origin.x;
    
    if (labelTopFrame.origin.x == _soundButton.frame.origin.x)
        [_lbMusicPlaying setFrame:labelTopFrame];
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            [_lbMusicPlaying setFrame:labelTopFrame];
        }];
    }
}

- (IBAction)clickVolumeIcon:(id)sender
{
    if (_isSliderVolumeOpened == false)
    {
        CGRect sliderOpened = _viewSlider.frame;
        sliderOpened.origin.x = 10;
        _isSliderVolumeOpened = true;
        
        [UIView animateWithDuration:(0.1) animations:^{
                [_vw_labels setAlpha:0];
//            [_playButton setAlpha:0];
//            [_prevButton setAlpha:0];
//            [_nextButton setAlpha:0];
        } completion:^(BOOL finished)
        {
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
                    [_vw_labels setAlpha:1];
//                    [_playButton setAlpha:1];
//                    [_prevButton setAlpha:1];
//                    [_nextButton setAlpha:1];
                }];
                _isSliderVolumeOpened = false;
            }
        }];
        
    }
}

- (IBAction)clickTitleGoToPlayer:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectPlayer:)])
    {
        [_delegate performSelector:@selector(didSelectPlayer:) withObject:self];
    }
    if ([_delegate isKindOfClass:[UIViewController class]])
    {
        PlayerViewController *player = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
        [((UIViewController *)_delegate).navigationController pushViewController:player animated:true];
    }
}

- (IBAction)clickPlay:(id)sender
{
    if (isPlaying == true)
    {
        [musicPlayer pause];
//        [_playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
        if (_delegate && [_delegate respondsToSelector:@selector(play:)])
            [_delegate performSelector:@selector(play:) withObject:self];
    }
    else
    {
        [musicPlayer play];
//        [_playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        
        if (_delegate && [_delegate respondsToSelector:@selector(pause:)])
            [_delegate performSelector:@selector(pause:) withObject:self];
    }
}

- (IBAction)clicKNext:(id)sender
{
    [musicPlayer next];
    if (_delegate && [_delegate respondsToSelector:@selector(next:)])
        [_delegate performSelector:@selector(next:) withObject:self];
}

- (IBAction)clickPrev:(id)sender
{
    [musicPlayer prev];
    if (_delegate && [_delegate respondsToSelector:@selector(prev:)])
        [_delegate performSelector:@selector(prev:) withObject:self];
}

- (IBAction)editSliderVolume:(id)sender
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
//    self.sliderPlayingMedia.maximumValue = [max_ floatValue];
//    
//    if (musicPlayer.isEditingPlayingOffset == NO)
//        self.sliderPlayingMedia.value = [current_ floatValue];
    
    int diff = [current_ intValue];
    int forHours = diff / 3600;
    int remainder = diff % 3600;
    int forMinutes = remainder / 60;
    int forSeconds = remainder % 60;
    
    if (forHours == 0)
    {
//        if (musicPlayer.isEditingPlayingOffset == NO)
//            self.sliderPlayingMedia.valueString = [NSString stringWithFormat:@"%02d:%02d", forMinutes, forSeconds];
        self.lbMusicTime.text = [NSString stringWithFormat:@"%02d:%02d", forMinutes, forSeconds];
    }
    else
    {
//        if (musicPlayer.isEditingPlayingOffset == NO)
//            self.sliderPlayingMedia.valueString = [NSString stringWithFormat:@"%d:%02d:%02d", forHours, forMinutes, forSeconds];
        
        self.lbMusicTime.text = [NSString stringWithFormat:@"%d:%02d:%02d", forHours, forMinutes, forSeconds];
    }
}

-(void)updateVolumeValue:(NSNumber *)current_
{
    [_sliderVolume setValue:([current_ floatValue]*100) animated:TRUE];
}

-(void)updateMediaInfo:(MPMediaItem *)item_
{
    NSString *artist = [item_ valueForProperty:MPMediaItemPropertyArtist];
    NSString *title = [item_ valueForProperty:MPMediaItemPropertyTitle];
    NSString *albumTitle = [item_ valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    if (artist && title && albumTitle)
        [_lbMusicPlaying setText:[NSString stringWithFormat:@"%@ - %@ [%@]",
                                   title, artist, albumTitle]];
    else if (artist && title)
        [_lbMusicPlaying setText:[NSString stringWithFormat:@"%@ - %@",
                                   title, artist]];
    else if (title)
        [_lbMusicPlaying setText:[NSString stringWithFormat:@"%@",
                                   title]];
    else
        [_lbMusicPlaying setText:@""];
    
    CGRect label = _lbMusicPlaying.frame;
    label.origin.x = _soundButton.frame.origin.x;
    label.size = [_lbMusicPlaying.text sizeWithFont:FONTBOLDSIZE(17)];
    [_lbMusicPlaying setFrame:label];
    
//    UIImage *artworkImageLarge = [UIImage imageNamed:@"noArtworkImageLarge.png"];
//    UIImage *artworkImageSmall = [UIImage imageNamed:@"noArtworkImageSmall.png"];
//	MPMediaItemArtwork *artwork = [item_ valueForProperty:MPMediaItemPropertyArtwork];
//    
//	if (artwork)
//    {
//		artworkImageLarge = [artwork imageWithSize: CGSizeMake (400, 400)];
//        artworkImageSmall = [artwork imageWithSize: CGSizeMake (200, 200)];
//    }
//    [_jacketImg setImage:artworkImageSmall];
//    [_im_bg_album setImage:artworkImageLarge];
//    [self flipJacketView];
}

-(void) play:(id)sender
{
    NSLog(@"Play delegate");
    isPlaying = YES;
    [_playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
}

-(void) pause:(id)sender
{
    NSLog(@"Pause delegate");
    isPlaying = NO;
    [_playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
}

-(void) stop:(id)sender
{
    NSLog(@"Stop delegate");
    isPlaying = NO;
}

@end
