//
//  UINsSnConnectViewController.m
//  NsSn
//
//  Created by adelskott on 27/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "UIAWConnectViewController.h"
//#import "NsSnUserManager.h"
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

    self.myCustomNavForLogin.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.myCustomNavForLogin.navigationBar.translucent = YES;

    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.myCustomNavForLogin animated:TRUE completion:^{}];
}

-(void)reconnect:(BOOL)start
{
    if (!self.view.window && !start)
        return;

    // TODO Warning
    
//    if (![[NsSnUserManager getInstance] isLogin])
//    {
//        if ([[NsSnUserManager getInstance] canReconect])
//        {
//            [[NsSnUserManager getInstance] autologin:^(BOOL ok)
//            {
//                if (!ok)
//                    [self runAuth];
//                else
//                    [self loadData];
//            }];
//        }
//        else
//            [self runAuth];
//    }
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
