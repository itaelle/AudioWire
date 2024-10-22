#import <QuartzCore/QuartzCore.h>
#import "AWMasterViewController.h"
#import "AWRemoteViewController.h"

@implementation AWMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        needASubPlayer = YES;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSLog(@"********** %@ willAppear **********", self.title);

    if (IS_OS_7_OR_LATER)
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

    if (miniPlayer)
        [miniPlayer updatePlayerStatus];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    NSLog(@"********** %@ willDisAppear **********", self.title);

    if (miniPlayer)
        [miniPlayer endPlayerHandling];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isLoading = false;
    [self setUpNavTitle];
    
    if (needASubPlayer)
    {
        miniPlayer = [[[NSBundle mainBundle] loadNibNamed:@"SubPlayer" owner:self options:nil] objectAtIndex:0];
        miniPlayer.delegate = self;
        [miniPlayer myInit];
    }
    else
        miniPlayer = nil;
}

-(void)setFlashMessage:(NSString *)msg
{
    if ([NSThread isMainThread])
    {
        if (flash)
            [flash hide];
        flash = nil;
        flash = [[OLGhostAlertView alloc] initWithTitle:msg];
        [flash show];
    }
    else
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (flash)
                [flash hide];
            flash = nil;
            flash = [[OLGhostAlertView alloc] initWithTitle:msg];
            [flash show];
        });
}

-(void)setFlashMessage:(NSString *)msg timeout:(NSTimeInterval)timeout_
{
    if ([NSThread isMainThread])
        [[[OLGhostAlertView alloc] initWithTitle:msg timeout:timeout_] show];
    else
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[[OLGhostAlertView alloc] initWithTitle:msg timeout:timeout_] show];
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

- (void) setUpNavTitle
{
    UIView *titleView =  self.navigationItem.titleView;
    if (titleView && [titleView isKindOfClass:[UILabel class]])
    {
        NSLog(@"TITLEVIEW IS LABEL");
        UILabel *labelTitle = (UILabel *)titleView;
        [labelTitle setFont:FONTBOLDSIZE(25)];
    }
}

//-(void)logoutAction:(id)sender
//{
//    self.navigationItem.rightBarButtonItem = nil;
//}
//
//-(void)loginAction:(id)sender
//{
//    self.navigationItem.rightBarButtonItem = nil;
//}

-(void)cancelAction:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)closeAction:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:true completion:^{
        
    }];
}

-(void)editAction:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)addAction:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)importAction:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
}

-(void)remoteAction:(id)sender
{
    AWRemoteViewController *remoteVC = [[AWRemoteViewController alloc] initWithNibName:@"AWRemoteViewController" bundle:nil];
    
    UIAudioWireCustomNavigationController *nav = [[UIAudioWireCustomNavigationController alloc] initWithRootViewController:remoteVC];
    
    if (IS_OS_7_OR_LATER)
    {
        nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        nav.navigationBar.translucent = YES;
    }
    else
    {
        nav.navigationBar.barStyle = UIBarStyleBlack;
        nav.navigationBar.translucent = NO;
    }
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:nav animated:TRUE completion:^{}];
}

-(void) prepareNavBarForEditing:(BOOL)isLeft
{
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", @"") style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];

    if (IS_OS_7_OR_LATER)
        editButton.tintColor = [UIColor whiteColor];
    
    if (!isLeft)
    {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = editButton;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = editButton;
    }
}

-(void) prepareNavBarForEditing
{
    [self prepareNavBarForEditing:NO];
}

-(void) prepareNavBarForRemote
{
    UIBarButtonItem *remoteButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Remote", @"") style:UIBarButtonItemStylePlain target:self action:@selector(remoteAction:)];
    
    if (IS_OS_7_OR_LATER)
        remoteButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = remoteButton;
}


-(void) prepareNavBarForClose
{
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];

    if (IS_OS_7_OR_LATER)
        closeButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = closeButton;
}

-(void) prepareNavBarForCancel
{
    [self prepareNavBarForCancel:NO];
}

-(void) prepareNavBarForCancel:(BOOL)isLeft
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    
    if (IS_OS_7_OR_LATER)
        cancelButton.tintColor = [UIColor whiteColor];
    
    if (!isLeft)
    {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = cancelButton;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = cancelButton;
    }
}

- (void) prepareNavBarForAdding:(BOOL)isLeft
{
    UIBarButtonItem *createPlaylistButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", @"") style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
    
    if (IS_OS_7_OR_LATER)
        createPlaylistButton.tintColor = [UIColor whiteColor];
    
    if (isLeft)
    {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = createPlaylistButton;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = createPlaylistButton;
    }
}

- (void) prepareNavBarForAdding
{
    [self prepareNavBarForAdding:NO];
}

-(void)prepareNavBarForImport
{
    UIBarButtonItem *importButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Import", @"") style:UIBarButtonItemStylePlain target:self action:@selector(importAction:)];
    
    if (IS_OS_7_OR_LATER)
        importButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = importButton;
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
