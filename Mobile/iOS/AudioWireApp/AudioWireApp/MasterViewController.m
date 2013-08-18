//
//  MasterViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIImage+tools.h"
#import "MasterViewController.h"

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isLoading = false;
}

- (void) setUpNavLogo
{
    UIImageView *nav = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_logo.png"]];
    CGRect temp = self.navigationController.navigationItem.titleView.frame;
    temp.origin.x = 0;
    temp.origin.y = 0;
    temp.size.width = 50;
    temp.size.height = 50;
    [nav setFrame:temp];
    self.navigationItem.titleView = nav;
}

-(void)logoutAction:(id)sender
{
    // Log out
    
    [self prepareNavBarForLogin];
}

-(void)loginAction:(id)sender
{
    UIAlertView * alertLogin = [[UIAlertView alloc] initWithTitle:@"Login" message:@"You are now logged in." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertLogin show];
    
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
//    self.navigationItem.rightBarButtonItem = nil;
//    self.navigationItem.rightBarButtonItem = cancelButton;
    [self prepareNavBarForCancel];
    // PopUP de login
    // if () Try Login
    {
        
        [self prepareNavBarForLogout];
    }
}

-(void)cancelAction:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)createPlaylist:(id)sender
{
    UIAlertView * alertLogin = [[UIAlertView alloc] initWithTitle:@"Playlist" message:@"You will be able to create a playlist here !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertLogin show];
    
    [self prepareNavBarForCancel];
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
//    self.navigationItem.rightBarButtonItem = nil;
//    self.navigationItem.rightBarButtonItem = cancelButton;
}

-(void) prepareNavBarForCancel
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void) prepareNavBarForLogin
{
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Login", @"Login") style:UIBarButtonItemStylePlain target:self action:@selector(loginAction:)];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = loginButton;
}

- (void) prepareNavBarForLogout
{
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", @"Logout") style:UIBarButtonItemStylePlain target:self action:@selector(logoutAction:)];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = loginButton;
}

- (void) prepareNavBarForCreatingPlaylist
{
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Create Playlist", @"Create Playlist") style:UIBarButtonItemStylePlain target:self action:@selector(createPlaylist:)];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = loginButton;
}

-(void) setUpLoadingView:(UIView *)viewToLoad
{
    if (!viewToLoad)
        return ;
    
    isLoading = true;
    [viewToLoad setAlpha:0];
    
    CGRect insideFrame = viewToLoad.frame;
    
    if (!loadingView_)
    {
        loadingView_ = [[UIView alloc] init];
        [loadingView_ setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        //[loadingView_ setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        
        spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(insideFrame.size.width/2 - 20, insideFrame.size.height/2 - 20, 40, 40)];

        [loadingView_ addSubview:spinner];
        [spinner startAnimating];
        
        [self.view addSubview:loadingView_];
    }
    [loadingView_ setFrame:insideFrame];
    [self.view bringSubviewToFront:loadingView_];
}

-(void)updatePositionLoader:(CGRect)superViewRect
{
    if (loadingView_ && spinner)
    {
        [loadingView_ setFrame:superViewRect];
        [spinner setFrame:CGRectMake(superViewRect.size.width/2 - 20, superViewRect.size.height/2 - 20, 40, 40)];
    }
}

-(void) cancelLoadingView:(UIView *)viewDidLoad
{
    if (loadingView_)
    {
        [self.view sendSubviewToBack:loadingView_];

        if (viewDidLoad)
            [viewDidLoad setAlpha:1];
        
        isLoading = false;
    }
}

-(void) desactivateButtonBar:(bool)left right:(bool)right
{
    if (left)
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    if (right)
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
