//
//  OptionsViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/5/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "OptionsViewController.h"
#import "AWUserManager.h"
#import "AWTracksManager.h"
#import "AWPlaylistSynchronizer.h"
#import "AWPlaylistManager.h"
#import "UIAWSubscribeViewController.h"

@implementation OptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Options", @"");
        needASubPlayer = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginButtonRender) name:@"loggedIn" object:nil];

    if (!IS_OS_7_OR_LATER && firstTime)
    {
        firstTime = NO;
        CGRect rectTopView = self.topView.frame;
        rectTopView.origin.y = 31;
        rectTopView.size.height += 31;
        
        [self.topView setFrame:rectTopView];
    }
    
    [self loginButtonRender];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loginButtonRender
{
    if ([[AWUserManager getInstance] isLogin])
    {
        [_bt_signout setBackgroundImage:[UIImage imageNamed:@"sign-out.png"] forState:UIControlStateNormal];
        [_bt_signout setTitle:NSLocalizedString(@"Sign out", @"") forState:UIControlStateNormal];
        [_bt_signout addTarget:self action:@selector(click_signOut:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [_bt_signout setBackgroundImage:[UIImage imageNamed:@"bt-go.png"] forState:UIControlStateNormal];
        [_bt_signout setTitle:NSLocalizedString(@"Sign in", @"") forState:UIControlStateNormal];
        [_bt_signout addTarget:self action:@selector(click_signUp:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavLogo];
    firstTime = YES;
    self.skipAuth = YES;
    [self setUpOptionViews];
}

-(void)setUpOptionViews
{
    [_topView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    [_bottomView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    
    _topView.layer.cornerRadius = 10;
    _bottomView.layer.cornerRadius = 10;
    
    _topView.layer.borderColor = [[UIColor blackColor]CGColor];
    _bottomView.layer.borderColor = [[UIColor blackColor]CGColor];
    
    _topView.layer.borderWidth = 1;
    _bottomView.layer.borderWidth = 1;


    [_bt_userInfo setTitle:NSLocalizedString(@"Modify user information", @"") forState:UIControlStateNormal];
    [_bt_reset setTitle:NSLocalizedString(@"Reset library & playlists", @"") forState:UIControlStateNormal];
    [_topLabel setText:NSLocalizedString(@"What do you want to do ?", @"")];
    
    [_bt_userInfo.titleLabel setFont:FONTBOLDSIZE(14)];
    [_bt_signout.titleLabel setFont:FONTBOLDSIZE(14)];
    [_bt_reset.titleLabel setFont:FONTBOLDSIZE(14)];
    [_topLabel setFont:FONTSIZE(17)];
    
    _bt_userInfo.titleLabel.numberOfLines = 2;
    [_bt_userInfo.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_bt_userInfo.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    _bt_reset.titleLabel.numberOfLines = 2;
    [_bt_reset.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_bt_reset.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    NSString *format = [NSString stringWithFormat:@"%@\nMade for the EIP 2013\nv1.0 beta\nForum 2013", NSLocalizedString(@"AudioWire", @"")];
    
    [_bottomLabel setText:format];
    [_bottomLabel setFont:FONTSIZE(15)];
    
    [_bt_reset setBackgroundColor:[UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1]];
    [_bt_userInfo setBackgroundColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1]];
    
    return ;
    
    [_bt_userInfo setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1]] forState:UIControlStateNormal];
    [_bt_reset setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1]] forState:UIControlStateNormal];
}

- (IBAction)click_signUp:(id)sender
{
    [self reconnect:YES];
}

- (IBAction)click_signOut:(id)sender
{
    [FBSession.activeSession closeAndClearTokenInformation];
    
    [[AWUserManager getInstance] logOut:^(BOOL success, NSString *error)
    {
        if (success)
        {
//            [[AWMusicPlayer getInstance] pause];
            [self loginButtonRender];
            [self.navigationController popViewControllerAnimated:TRUE];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:error delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (IBAction)click_userInfo:(id)sender
{
    if ([[AWUserManager getInstance] isLogin])
    {
        UIAWSubscribeViewController *s = [[UIAWSubscribeViewController alloc] initWithNibName:@"UIAWSubscribeViewController" bundle:nil];
        s.requireLogin = self.requireLogin;
        
        self.myCustomNavForLogin = [[UIAudioWireCustomNavigationController alloc] initWithRootViewController:s];
        
        if (IS_OS_7_OR_LATER)
        {
            self.myCustomNavForLogin.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            self.myCustomNavForLogin.navigationBar.translucent = YES;
        }
        else
        {
            self.myCustomNavForLogin.navigationBar.barStyle = UIBarStyleBlack;
            self.myCustomNavForLogin.navigationBar.translucent = NO;
        }
        [self performSelector:@selector(launchNavigation) withObject:nil afterDelay:0.3];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"You should be logged in to be able to modify you personal information.", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)click_reset:(id)sender
{
    BOOL sucess = [[NSFileManager defaultManager] removeItemAtPath:[AWTracksManager pathOfileLibrary] error:nil];
    sucess = [[NSFileManager defaultManager] removeItemAtPath:[AWPlaylistSynchronizer pathOfFilePlaylistSync] error:nil];
    sucess = [[NSFileManager defaultManager] removeItemAtPath:[AWPlaylistManager pathOfilePlaylist] error:nil];
    
     [self setFlashMessage:NSLocalizedString(@"All local files have been deleted!", @"") timeout:1];
    
    return ;
    
    if (sucess)
    {
        [self setFlashMessage:NSLocalizedString(@"All local files have been deleted!", @"") timeout:1];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Somehting went wrong while attempting to remove local files.", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
