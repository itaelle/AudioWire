//
//  HomeViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIImage.h>
#import "ContactViewController.h"
#import "LibraryViewController.h"
#import "PlayerViewController.h"
#import "UIImage+tools.h"
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
        [super prepareNavBarForLogin];
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
    clickLogoCount = 0;
}

- (void) setUpViews
{
    // Logo TOP
    UIImage *logo = [UIImage imageNamed:@"logoAudiowire.png"];
    UIImageView *imgLogo = [[UIImageView alloc] initWithImage:logo];
    imgLogo.contentMode = UIViewContentModeScaleToFill;
    [_btLogo setBackgroundImage:imgLogo.image forState:UIControlStateNormal];
    
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

#pragma SubPlayerDelegate
-(void) didSelectPlayer
{
    PlayerViewController *player = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
    [self.navigationController pushViewController:player animated:true];
}

-(void) setUpMiddleView
{
    [_libraryButton setTitle:NSLocalizedString(@"Library", @"Library") forState:UIControlStateNormal];
    [_chatButton setTitle:NSLocalizedString(@"Chat", @"Chat") forState:UIControlStateNormal];
    [_thirdButton setTitle:NSLocalizedString(@"Player", @"Player") forState:UIControlStateNormal];
    [_optionButton setTitle:NSLocalizedString(@"Options", @"Options") forState:UIControlStateNormal];
    
    UIImage * tempLibrary = [UIImage imageWithColor:[UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1]];
    UIImage * tempChat = [UIImage imageWithColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1]];
    UIImage * tempThird = [UIImage imageWithColor:[UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1]];
    UIImage * tempOption = [UIImage imageWithColor:[UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1]];
    
    [_libraryButton setBackgroundImage:tempLibrary forState:UIControlStateNormal];
    [_chatButton setBackgroundImage:tempChat forState:UIControlStateNormal];
    [_thirdButton setBackgroundImage:tempThird forState:UIControlStateNormal];
    [_optionButton setBackgroundImage:tempOption forState:UIControlStateNormal];
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
    PlayerViewController *player = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
    [self.navigationController pushViewController:player animated:true];
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

@end
