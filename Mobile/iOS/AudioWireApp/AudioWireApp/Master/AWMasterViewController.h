//
//  MasterViewController.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "UIAWConnectViewController.h"
#import "SubPlayer.h"

@interface AWMasterViewController : UIAWConnectViewController<SubPlayerDelegate>
{
    UIView *loadingView_;
    UIActivityIndicatorView *spinner;
    bool isLoading;
    
    SubPlayer *miniPlayer;
}

- (void) prepareNavBarForLogin;
- (void) prepareNavBarForLogout;
- (void) prepareNavBarForCancel;
- (void) prepareNavBarForClose;
- (void) prepareNavBarForEditing;
- (void) prepareNavBarForAdd;
- (void) desactivateButtonBar:(bool)left right:(bool)right;

- (void) setFlasMessage:(NSString *)msg;
- (void) loginAction:(id)sender;
- (void) cancelAction:(id)sender;
- (void) addAction:(id)sender;
- (void) setUpNavLogo;
- (void) setUpLoadingView:(UIView *)viewToLoad;
- (void) cancelLoadingView:(UIView *)viewDidLoad;
- (void) updatePositionLoader:(CGRect)superViewRect;

@end
