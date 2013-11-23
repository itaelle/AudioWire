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
    
    if (!IS_OS_7_OR_LATER)
    {
        CGRect rectTopView = self.topView.frame;
        rectTopView.origin.y = 31;
        rectTopView.size.height += 31;
        
        [self.topView setFrame:rectTopView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

    [_bt_signout setTitle:NSLocalizedString(@"Sign out", @"") forState:UIControlStateNormal];
    [_bt_userInfo setTitle:NSLocalizedString(@"Modify user information", @"") forState:UIControlStateNormal];
    [_bt_reset setTitle:NSLocalizedString(@"Reset Library", @"") forState:UIControlStateNormal];
    [_topLabel setText:NSLocalizedString(@"What do you want to do ?", @"")];
    
    [_bt_userInfo.titleLabel setFont:FONTBOLDSIZE(14)];
    [_bt_signout.titleLabel setFont:FONTBOLDSIZE(15)];
    [_bt_reset.titleLabel setFont:FONTBOLDSIZE(15)];
    [_topLabel setFont:FONTSIZE(15)];
    
    NSString *format = [NSString stringWithFormat:@"%@\nMade for the EIP 2013\nv1.0 beta\nForum 2013", NSLocalizedString(@"AudioWire", @"")];
    
    [_bottomLabel setText:format];
    [_bottomLabel setFont:FONTSIZE(15)];
    
    [_bt_reset setBackgroundColor:[UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1]];
    [_bt_userInfo setBackgroundColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1]];
}

- (IBAction)click_signOut:(id)sender
{
    [FBSession.activeSession closeAndClearTokenInformation];
    
    [[AWUserManager getInstance] logOut:^(BOOL success, NSString *error)
    {
        if (success)
        {
            [[AWMusicPlayer getInstance] pause];
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
    // TODO userInfo
}

- (IBAction)click_reset:(id)sender
{
    BOOL sucess = [[NSFileManager defaultManager] removeItemAtPath:[AWTracksManager pathOfileLibrary] error:nil];
    
    if (sucess)
    {
        [self setFlashMessage:NSLocalizedString(@"The local library has been removed !", @"") timeout:1];
    }
    else
    {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
