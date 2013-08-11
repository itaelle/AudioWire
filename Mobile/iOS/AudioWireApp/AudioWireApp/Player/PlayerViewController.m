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
        
    } completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super setUpNavLogo];
    _sliderVolume.popupView.hidden = true;
    _isSliderVolumeOpened = false;
    isPlaying = false;
    isFlipped = false;
    
    // Test
    [_labelTopPlaying setText:@"Paul Kalkbrenner - Peet [Berlin Calling] Et ca c'est du blabla pour voir si ca passe ou ca casse !!!"];
    [_labelMinutesPlayed setText:@"6:24"];
    [_jacketImg setImage:[UIImage imageNamed:@"example_album_jacket.jpg"]];
    [self setUpViews];
}

- (void) setUpViews
{
    // Jacket
    [_jacketView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    _jacketView.layer.borderColor = [[UIColor blackColor] CGColor];
    _jacketView.layer.borderWidth = 1;
    [_jacketImg setAlpha:0];
    
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
    label.size = [_labelTopPlaying.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17]];
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

- (IBAction)clickPlayerButton:(id)sender
{
    isPlaying = !isPlaying;
    if (isPlaying == true)
    {
        // Play Music
        [_playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
    else
    {
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

- (IBAction)dragMusicPlayingOffset:(id)sender
{
    if (sender && [sender isKindOfClass:[ANPopoverSlider class]])
    {
        ANPopoverSlider *temp = sender;
        float value = temp.value;
        NSLog(@"Value player offset %f", value);
    }
}

- (IBAction)dragVolume:(id)sender
{
    if (sender && [sender isKindOfClass:[ANPopoverSlider class]])
    {
        ANPopoverSlider *temp = sender;
        float value = temp.value;
        NSLog(@"Value volume %f", value);
    }
}

@end
