//
//  MasterViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AWMasterViewController.h"
#import "OLGhostAlertView.h"

@implementation AWMasterViewController

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

    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    miniPlayer = [[[NSBundle mainBundle] loadNibNamed:@"SubPlayer" owner:self options:nil] objectAtIndex:0];
    miniPlayer.delegate = self;
    [miniPlayer myInit];
}

-(void)setFlasMessage:(NSString *)msg
{
    if ([NSThread isMainThread])
        [[[OLGhostAlertView alloc] initWithTitle:msg] show];
    else
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[[OLGhostAlertView alloc] initWithTitle:msg] show];
        });
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
    [self runAuth];
}

-(void)cancelAction:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)closeAction:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)editAction:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)addAction:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
}

-(void) prepareNavBarForEditing
{
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", @"") style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
    editButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = editButton;
}

-(void) prepareNavBarForClose
{
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];
    closeButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = closeButton;
}

-(void) prepareNavBarForCancel
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    cancelButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void) prepareNavBarForLogin
{
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Login", @"") style:UIBarButtonItemStylePlain target:self action:@selector(loginAction:)];
    loginButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = loginButton;
}

- (void) prepareNavBarForLogout
{
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", @"") style:UIBarButtonItemStylePlain target:self action:@selector(logoutAction:)];
    logoutButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = logoutButton;
}

- (void) prepareNavBarForAdd
{
    UIBarButtonItem *createPlaylistButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", @"") style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
    createPlaylistButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = createPlaylistButton;
}

-(void) setUpLoadingView:(UIView *)viewToLoad
{
    if (!viewToLoad)
        return ;
    
    isLoading = true;
    [viewToLoad setAlpha:0.2];
    
    CGRect insideFrame = viewToLoad.frame;
    
    if (!loadingView_)
    {
        loadingView_ = [[UIView alloc] init];
        [loadingView_ setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        //[loadingView_ setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        
        spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(insideFrame.size.width/2 - 20, insideFrame.size.height/2 - 20, 40, 40)];
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        
        [loadingView_ addSubview:spinner];
        [self.view addSubview:loadingView_];
    }
    [spinner startAnimating];
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
    if (loadingView_ && spinner)
    {
        [spinner stopAnimating];
        [self.view sendSubviewToBack:loadingView_];

        if (viewDidLoad)
            [viewDidLoad setAlpha:1];
        isLoading = false;
    }
}

-(void) desactivateButtonBar:(bool)left right:(bool)right
{
    if (left)
        self.navigationItem.leftBarButtonItem = nil;

    if (right)
        self.navigationItem.rightBarButtonItem = nil;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
