//
//  AppDelegate.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AWXMPPManager.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

@implementation AppDelegate

-(void)setupAppearanceForSlider
{
    UIImage *minImage = [[UIImage imageNamed:@"slider_minimum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    UIImage *maxImage = [[UIImage imageNamed:@"slider_maximum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    UIImage *thumbImage = [UIImage imageNamed:@"sliderhandle.png"];
    
    [[UISlider appearance] setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateNormal];
}

-(void)setupJabberConnexion
{
    [[AWXMPPManager getInstance] setupStream];
    
    if ([[AWXMPPManager getInstance] connect] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Unable to connect! There is no jabber ids stored", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];
    }
}

-(void) setupNavbarStyle
{
    if (IS_OS_7_OR_LATER)
    {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.navigationController.navigationBar.translucent = YES;
    }
    else
    {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [self setupJabberConnexion];
    [self setupAppearanceForSlider];
    
    HomeViewController *masterViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.navigationController = [[UIAudioWireCustomNavigationController alloc] initWithRootViewController:masterViewController];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self setupNavbarStyle];
    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}


//- (void)applicationWillResignActive:(UIApplication *)application
//{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//}

//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[AWMusicPlayer getInstance] update];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterForeground" object:nil];

    [FBAppEvents setFlushBehavior:FBAppEventsFlushBehaviorExplicitOnly];
}

//- (void)applicationWillTerminate:(UIApplication *)application
//{
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (!url)
        return NO;
    
    NSString *strUrl = [url absoluteString];
    
    if ([strUrl isSubString:@"fb"])
    {
        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call)
        {
            NSLog(@"In fallback handler");
        }];
    }
    return NO;
}

-(void)dealloc
{
    [[AWXMPPManager getInstance] unSetupStream];
    [[AWXMPPManager getInstance] teardownStream];
}

@end