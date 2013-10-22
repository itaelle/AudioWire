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

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Home", @"Home");
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
    [self setUpMiniPlayer];
}

- (void) setUpMiniPlayer
{
    SubPlayer *miniPlayer = [[[NSBundle mainBundle] loadNibNamed:@"SubPlayer" owner:self options:nil] objectAtIndex:0];
    miniPlayer.delegate = self;
    [_playingView addSubview:miniPlayer];
    [miniPlayer myInit];
}

-(void) setUpMiddleView
{
    [_libraryButton setTitle:NSLocalizedString(@"Library", @"Library") forState:UIControlStateNormal];
    [_chatButton setTitle:NSLocalizedString(@"Chat", @"Chat") forState:UIControlStateNormal];
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
   // PlayerViewController *player = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
   // [self.navigationController pushViewController:player animated:true];
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
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hell Yeah !"
                                                    message:@"You found that trick :)"
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        [message show];
    }
}


#pragma SubPlayerDelegate
-(void) didSelectPlayer:(id)sender
{
}

-(void) play:(id)sender
{
}

-(void) pause:(id)sender
{
}

-(void) prev:(id)sender
{
}

-(void) next:(id)sender
{
}

@end
