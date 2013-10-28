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
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [_jacketImg setAlpha:1];
    [UIView transitionWithView:_jacketImg duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
    } completion:^(BOOL finished) {
        if (finished)
        {
            [_im_bg_album setAlpha:0.07];
            [UIView transitionWithView:_im_bg_album duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                
            } completion:nil];
        }
    }];
}

-(void)setUpPlayer
{
    musicPlayer = [[AWMusicPlayer alloc] init];
    musicPlayer.delegate = self;
    [musicPlayer setMusicToPlay:@""];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavLogo];
    [self setUpPlayer];
    
    _sliderVolume.popupView.hidden = true;
    _isSliderVolumeOpened = false;
    isPlaying = false;
    isFlipped = false;
    
    // Test DATA
    [_labelTopPlaying setText:@"Paul Kalkbrenner - Peet [Berlin Calling]"];
    [_jacketImg setImage:[UIImage imageNamed:@"example_album_jacket.jpg"]];
    [_im_bg_album setImage:[UIImage imageNamed:@"example_album_jacket.jpg"]];

    [self setUpViews];
}

- (IBAction)clickPlayerButton:(id)sender
{
    isPlaying = !isPlaying;
    if (isPlaying == true)
    {
        // Play Music
        [musicPlayer play];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
    else
    {
        [musicPlayer pause];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)clickPreviousButton:(id)sender
{
    // Prev
}

- (IBAction)clickNextButton:(id)sender
{
    // Next
}

- (IBAction)clickRepeatButton:(id)sender
{
    // Repeat
}

- (IBAction)clickShuffleButton:(id)sender
{
    // Shuffle
}

- (IBAction)dragMusicPlayingOffset:(ANPopoverSlider *)sender
{
    if (sender && [sender isKindOfClass:[ANPopoverSlider class]])
    {
        ANPopoverSlider *temp = sender;
        NSNumber *value = [NSNumber numberWithFloat:temp.value];
        NSLog(@"Value player offset %f", [value floatValue]);
        
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
}
- (IBAction)endEditingSlider:(id)sender
{
    [musicPlayer endEditing];
}

- (IBAction)dragVolume:(id)sender
{
    if (sender && [sender isKindOfClass:[ANPopoverSlider class]])
    {
        ANPopoverSlider *temp = sender;
        float value = temp.value;
        NSLog(@"Value volume %f", value);
        
        [musicPlayer setVolume:[NSNumber numberWithFloat:(value/100)]];
    }
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
    
    // Labels set up
    CGRect label = _labelTopPlaying.frame;
    label.size = [_labelTopPlaying.text sizeWithAttributes:@{NSFontAttributeName:FONTBOLDSIZE(14)}];
    label.size.width += 10;
    [_labelTopPlaying setFrame:label];
    
    // Timer moving text
    if (!_timer)
    {
        NSDate *run = [NSDate dateWithTimeIntervalSinceNow:DELAY_BEFORE_SLIDING_TITLE];
        _timer = [[NSTimer alloc] initWithFireDate:run interval:0.05 target:self selector:@selector(timerFinish:) userInfo:nil repeats:true];
        
        NSRunLoop * theRunLoop = [NSRunLoop currentRunLoop];
        [theRunLoop addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    else
    {
        // Quand il relancé.
    }
}

- (void)timerFinish:(NSTimer*)theTimer
{
    CGRect labelTopFrame = _labelTopPlaying.frame;
    if (labelTopFrame.origin.x + labelTopFrame.size.width > 0)
        labelTopFrame.origin.x -= 2;
    else
        labelTopFrame.origin.x = _VolumeButton.frame.origin.x;
    
    [_labelTopPlaying setFrame:labelTopFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

#pragma AWMusicPlayerDelegate
-(void)initSliderValueWithMax:(NSNumber *)max_
{
    self.sliderPlayingMedia.value = 0.0f;
    self.sliderPlayingMedia.minimumValue = 0.0f;
    self.sliderPlayingMedia.maximumValue = [max_ floatValue];
    self.sliderPlayingMedia.valueString = @"OO:OO";
    self.labelMinutesPlayed.text = @"OO:OO";
}

-(void)updateSliderValue:(NSNumber *)current_
{
    if (musicPlayer.isEditingPlayingOffset == NO)
        self.sliderPlayingMedia.value = [current_ floatValue];
    
    int diff = [current_ intValue];
    int forHours = diff / 3600;
    int remainder = diff % 3600;
    int forMinutes = remainder / 60;
    int forSeconds = remainder % 60;
    
    if (forHours == 0)
    {
        if (musicPlayer.isEditingPlayingOffset == YES)
            self.sliderPlayingMedia.valueString = [NSString stringWithFormat:@"%02d:%02d", forMinutes, forSeconds];
        self.labelMinutesPlayed.text = [NSString stringWithFormat:@"%02d:%02d", forMinutes, forSeconds];
    }
    else
    {
        if (musicPlayer.isEditingPlayingOffset == YES)
            self.sliderPlayingMedia.valueString = [NSString stringWithFormat:@"%d:%02d:%02d", forHours, forMinutes, forSeconds];
        
        self.labelMinutesPlayed.text = [NSString stringWithFormat:@"%d:%02d:%02d", forHours, forMinutes, forSeconds];
    }
}

-(void) play:(id)sender
{
    
}

-(void) pause:(id)sender
{
    
}

-(void) stop:(id)sender
{
    
}

@end
