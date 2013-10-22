//
//  UINsSnConnectViewController.h
//  NsSn
//
//  Created by adelskott on 27/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

//#import "UINsSnNavigationSignViewController.h"
#import "UIAudioWireCustomNavigationController.h"

@interface UIAWConnectViewController : UIViewController
{
    
}
@property (assign) BOOL skipAuth;
@property (assign) int limit;
@property (assign) int page;
@property (assign) BOOL isSignedOut;

@property (strong, nonatomic) UIAudioWireCustomNavigationController *myCustomNavForLogin;

-(void)loadData;
-(void)runAuth;

@end
