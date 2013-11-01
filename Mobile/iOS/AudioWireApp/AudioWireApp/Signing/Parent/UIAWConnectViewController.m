#import "UIAWConnectViewController.h"
#import "AWUserManager.h"
#import "UIAWHomeLoginViewController.h"

@implementation UIAWConnectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.skipAuth = NO;
        self.isSignedOut = NO;
    }
    return self;
}

-(void)runAuth
{
    UIAWHomeLoginViewController *s = [[UIAWHomeLoginViewController alloc] initWithNibName:@"UIAWHomeLoginViewController" bundle:nil];
    
    self.myCustomNavForLogin = [[UIAudioWireCustomNavigationController alloc] initWithRootViewController:s];
    s.isSignedOut = self.isSignedOut;

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
        NSLog(@"isLogin => TRUE => Continue /LoadData/");
        [self loadData];
    }
}


-(void)reconnectActive{
    [self reconnect:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    if (self.skipAuth)
        return;
    [self reconnect:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    NSLog(@"ERRORR RRRR RRR RR");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    return;
    
    // adding menu
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reconnectActive) name:@"NsSnUserErrorValueNotLogin" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NsSnUserErrorValueNotLogin" object:nil];    
}
@end
