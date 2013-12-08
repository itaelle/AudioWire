//
//  AWRemoteViewController.m
//  AudioWireApp
//
//  Created by Guilaume Derivery on 08/12/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWRemoteViewController.h"

@interface AWRemoteViewController ()

@end

@implementation AWRemoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Remote", @"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareNavBarForClose];
    [self setUpNavLogo];

    self.isSliderVolumeOpened = false;
    self.skipAuth = YES;
    isPlaying = NO;
    
    
    CGRect label = self.lb_titleMusic.frame;
    label.origin.x = 0;
    label.size = [self.lb_titleMusic.text sizeWithFont:FONTSIZE(17)];
    [self.lb_titleMusic setFrame:label];

    
    [self.bt_playPause setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [self.bt_playPause setBackgroundImage:[UIImage imageNamed:@"pause_pressed.png"] forState:UIControlStateSelected];
    
    [self.bt_next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [self.bt_next setBackgroundImage:[UIImage imageNamed:@"next_pressed.png"] forState:UIControlStateHighlighted];
    
    [self.bt_prev setBackgroundImage:[UIImage imageNamed:@"prev.png"] forState:UIControlStateNormal];
    [self.bt_prev setBackgroundImage:[UIImage imageNamed:@"prev_pressed.png"] forState:UIControlStateHighlighted];
    
    [self.bt_shuffle setBackgroundImage:[UIImage imageNamed:@"shuffle.png"] forState:UIControlStateNormal];
    [self.bt_shuffle setBackgroundImage:[UIImage imageNamed:@"shuffle_pressed.png"] forState:UIControlStateHighlighted];
    
    [self.bt_repeat setBackgroundImage:[UIImage imageNamed:@"repeat.png"] forState:UIControlStateNormal];
    [self.bt_repeat setBackgroundImage:[UIImage imageNamed:@"repeat_pressed.png"] forState:UIControlStateHighlighted];
    
    // Slider Volume Placement
    CGRect sliderPos = _viewSlider.frame;
    sliderPos.origin.x = _viewSlider.frame.origin.x + _viewSlider.frame.size.width;
    [_viewSlider setFrame:sliderPos];
    _viewSlider.layer.borderWidth = 1;
    _viewSlider.layer.borderColor = [[UIColor blackColor] CGColor];
    _viewSlider.layer.cornerRadius = 10;
    [_viewSlider setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    
    CGRect sliderFrame = self.slider_volume.frame;
    if (!IS_OS_7_OR_LATER)
    {
        sliderFrame.origin.y += 3;
        [self.slider_volume setFrame:sliderFrame];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.img_audiowire setHidden:YES];
//    [self.img_logo setHidden:YES];
//    [self.act_loader startAnimating];
    
    if (!IS_OS_7_OR_LATER)
    {
        CGRect rectTopView = self.topView.frame;
        rectTopView.origin.y -= 64;
        [self.topView setFrame:rectTopView];
        
        CGRect rectMiddelView = self.middleView.frame;
        rectMiddelView.origin.y -= 64;
        [self.middleView setFrame:rectMiddelView];
    }
}

-(void)loadData
{
    // Connect to server
    
    // Once connected
//    [self.img_audiowire setHidden:NO];
    [self.img_logo setHidden:NO];
    [self.act_loader setHidden:YES];
    [self.act_loader stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)clickSoundIcon:(id)sender
{
    if (_isSliderVolumeOpened == false)
    {
        CGRect sliderOpened = self.viewSlider.frame;
        sliderOpened.origin.x = 0;
        _isSliderVolumeOpened = true;
        
        [UIView animateWithDuration:(0.1) animations:^{
            [self.lb_titleMusic setAlpha:0];
        } completion:^(BOOL finished) {
            if (finished)
            {
                [UIView animateWithDuration:(0.5) animations:^{
                    [self.viewSlider setFrame:sliderOpened];
                }];
            }
        }];
    }
    else
    {
        CGRect sliderPos = self.viewSlider.frame;
        sliderPos.origin.x = self.viewSlider.frame.origin.x + self.viewSlider.frame.size.width;
        
        
        [UIView animateWithDuration:(0.5) animations:^{
            [_viewSlider setFrame:sliderPos];
        } completion:^(BOOL finished) {
            if (finished)
            {
                [UIView animateWithDuration:(0.2) animations:^{
                    [self.lb_titleMusic setAlpha:1];
                }];
                _isSliderVolumeOpened = false;
            }
        }];
        
    }
}

#pragma MediaControl
- (IBAction)click_playPause:(id)sender
{
    if (isPlaying)
    {
        [self.bt_playPause setSelected:NO];
        isPlaying = NO;
    }
    else
    {
        [self.bt_playPause setSelected:YES];
        isPlaying = YES;
    }
}

- (IBAction)click_prev:(id)sender
{
}

- (IBAction)click_next:(id)sender
{
}

- (IBAction)clicK_repeat:(id)sender
{
}

- (IBAction)click_shuffle:(id)sender
{
}

- (IBAction)modifyVolume:(id)sender
{
}

- (IBAction)modifyMusicOffset:(id)sender
{
}

@end
