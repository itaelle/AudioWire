#import "UIAWConnectViewController.h"
#import "AWUserManager.h"
#import "UIAWHomeLoginViewController.h"
#import "AFNetworking.h"

@implementation UIAWConnectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.skipAuth = NO;
        self.requireLogin = YES;
    }
    return self;
}

-(void)runAuth
{
    UIAWHomeLoginViewController *s = [[UIAWHomeLoginViewController alloc] initWithNibName:@"UIAWHomeLoginViewController" bundle:nil];
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

-(void)isInternetAvailable:(void(^)(BOOL available))cb_rep
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
        if (status == AFNetworkReachabilityStatusNotReachable)
            cb_rep(NO);
        else
            cb_rep(YES);
    }];
}

-(void)launchNavigation
{
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.myCustomNavForLogin animated:TRUE completion:^{}];
}

-(void)reconnect:(BOOL)start
{
    if (!self.view.window && !start)
        return;
    
    if (![[AWUserManager getInstance] isLogin])
    {
        NSLog(@"isLogin => FALSE => Autologin");
        [[AWUserManager getInstance] autologin:^(BOOL success, NSString *error)
        {
            if (!success)
            {
                NSLog(@"Autologin => FALSE => LOGIN SCREEN");
                [self runAuth];
            }
            else
            {
                NSLog(@"Autologin => TRUE");
                [self loadData];
            }
        }];
    }
    else
    {
//        NSLog(@"isLogin => TRUE => DONE");
//        return ;
        
        NSLog(@"isLogin => TRUE => Continue /LoadData/");
        [self loadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    if (self.skipAuth)
//        return;
//    [self reconnect:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.skipAuth)
    {
        [self loadData];
        return;
    }
    [self reconnect:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)loadData
{
    NSLog(@"LoadData connectViewController");
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
@end
