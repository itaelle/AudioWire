//
//  HomeViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIImage.h>
#import "PlaylistViewController.h"
#import "ContactViewController.h"
#import "LibraryViewController.h"
#import "PlayerViewController.h"
#import "HomeViewController.h"
#import "SubPlayer.h"
#import "OptionsViewController.h"
#import "UIView+UIView_Tool.h"

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Home", @"");
        firstTime = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpViews];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [super prepareNavBarForLogin];
    clickLogoCount = 0;
    
    if (firstTime)
        [self firstWaveAnimation];
    firstTime = NO;
}

-(void)specialWaveAnimation
{
    [UIView transitionWithView:_libraryButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [_libraryButton setAlpha:0];
    } completion:^(BOOL finished) {
        if (finished)
        { }
    }];
    
    [UIView transitionWithView:_thirdButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [_thirdButton setAlpha:0];
    } completion:^(BOOL finished) {
        if (finished)
        { }
    }];
    
    
    [UIView transitionWithView:_chatButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [_chatButton setAlpha:0];
    } completion:^(BOOL finished) {
        if (finished)
        { }
    }];
    
    [UIView transitionWithView:_optionButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [_optionButton setAlpha:0];
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self.special_button setAlpha:1];
            [self.special_button bouingAppear:TRUE oncomplete:^{
                
            }];
        }
    }];
}

-(void)specialWaveAnimationBackToNormal
{
    [_libraryButton setAlpha:0];
    [_thirdButton setAlpha:0];
    [_chatButton setAlpha:0];
    [_optionButton setAlpha:0];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.special_button setAlpha:0];
    } completion:^(BOOL finished)
    {
        [UIView transitionWithView:_libraryButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [_libraryButton setAlpha:1];
        } completion:^(BOOL finished) {
            if (finished)
            { }
        }];
        
        [UIView transitionWithView:_thirdButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [_thirdButton setAlpha:1];
        } completion:^(BOOL finished) {
            if (finished)
            { }
        }];
        
        [UIView transitionWithView:_chatButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            [_chatButton setAlpha:1];
        } completion:^(BOOL finished) {
            if (finished)
            { }
        }];
        
        [UIView transitionWithView:_optionButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            [_optionButton setAlpha:1];
        } completion:^(BOOL finished) {
            if (finished)
            { }
        }];
    }];
}

-(void)secondWaveAnimation
{
    CGRect libraryRect = _libraryButton.frame;
    CGRect optionRect = _optionButton.frame;
    CGRect thirdRect = _thirdButton.frame;
    CGRect chatRect = _chatButton.frame;
    
    [UIView animateWithDuration:0.4 animations:^{
        [_optionButton setFrame:libraryRect];
        [_libraryButton setFrame:optionRect];
        
        [_thirdButton setFrame:chatRect];
        [_chatButton setFrame:thirdRect];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)firstWaveAnimation
{
    [self.headView setAlpha:1];
    [self.headView bouingAppear:TRUE oncomplete:^{
        
    }];
    
    [_optionButton setAlpha:1];
    [UIView transitionWithView:_optionButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
    } completion:^(BOOL finished)
     {
         [_thirdButton setAlpha:1];
         [UIView transitionWithView:_thirdButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
             
         } completion:^(BOOL finished)
          {
              [_chatButton setAlpha:1];
              [UIView transitionWithView:_chatButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                  
              } completion:^(BOOL finished)
               {
                   [_libraryButton setAlpha:1];
                   [UIView transitionWithView:_libraryButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                       
                   } completion:^(BOOL finished)
                   {
                       [self secondWaveAnimation];
                   }];
               }];
          }];
     }];
}

- (void) setUpViews
{
    [self.headView setAlpha:0];
    [self setUpMiddleView];
    
    [_playingView addSubview:miniPlayer];
}

-(void) setUpMiddleView
{
    [_special_button setBackgroundImage:[UIImage imageNamed:@"funny_monkey.jpg"] forState:UIControlStateNormal];
    
    [_libraryButton setTitle:NSLocalizedString(@"Library", @"Library") forState:UIControlStateNormal];
    [_chatButton setTitle:NSLocalizedString(@"Friends", @"Friends") forState:UIControlStateNormal];
    [_thirdButton setTitle:NSLocalizedString(@"Playlists", @"Playlists") forState:UIControlStateNormal];
    [_optionButton setTitle:NSLocalizedString(@"Options", @"Options") forState:UIControlStateNormal];
    
    UIImage * tempLibrary = [UIImage imageWithColor:[UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1]];
    UIImage * tempChat = [UIImage imageWithColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1]];
    UIImage * tempThird = [UIImage imageWithColor:[UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1]];
    UIImage * tempOption = [UIImage imageWithColor:[UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1]];
    
    [_libraryButton setBackgroundImage:tempLibrary forState:UIControlStateNormal];
    [_chatButton setBackgroundImage:tempChat forState:UIControlStateNormal];
    [_thirdButton setBackgroundImage:tempThird forState:UIControlStateNormal];
    [_optionButton setBackgroundImage:tempOption forState:UIControlStateNormal];

    [_special_button setAlpha:0];
    [_libraryButton setAlpha:0];
    [_chatButton setAlpha:0];
    [_thirdButton setAlpha:0];
    [_optionButton setAlpha:0];
    
    CGRect libraryRect = _libraryButton.frame;
    CGRect optionRect = _optionButton.frame;
    CGRect thirdRect = _thirdButton.frame;
    CGRect chatRect = _chatButton.frame;
    
    [_optionButton setFrame:libraryRect];
    [_libraryButton setFrame:optionRect];
    
    [_thirdButton setFrame:chatRect];
    [_chatButton setFrame:thirdRect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)clickBtLibrary:(id)sender
{
    LibraryViewController *library = [[LibraryViewController alloc] initWithNibName:@"LibraryViewController" bundle:nil];
    [self.navigationController pushViewController:library animated:true];
}

- (IBAction)clickBtThird:(id)sender
{
    PlaylistViewController *playlist =  [[PlaylistViewController alloc] initWithNibName:@"PlaylistViewController" bundle:nil];
    [self.navigationController pushViewController:playlist animated:true];
}

- (IBAction)clickBtContact:(id)sender
{
    ContactViewController *contact = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
    [self.navigationController pushViewController:contact animated:true];
}

- (IBAction)clickBtOption:(id)sender
{
    OptionsViewController *temp = [[OptionsViewController alloc] initWithNibName:@"OptionsViewController" bundle:nil];
    [self.navigationController pushViewController:temp animated:true];
}

- (IBAction)clickLogoTop:(id)sender
{
    clickLogoCount += 1;
    if (clickLogoCount == DEFINE_TIMES_TO_CLICK_LOGO)
    {
        clickLogoCount = 0;
        
        [self.btLogo highlight:^{
            
        }];
        [self specialWaveAnimation];
        return ;
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hell Yeah !"
                                                    message:@"You found that trick :)"
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        [message show];
    }
}

- (IBAction)clickSpecialButtonBack:(id)sender
{
    [self specialWaveAnimationBackToNormal];
}

@end
