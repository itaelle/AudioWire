//
//  MasterViewController.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "UIAWConnectViewController.h"

@interface AWMasterViewController : UIAWConnectViewController
{
    UIView *loadingView_;
    UIActivityIndicatorView *spinner;

    bool isLoading;
}

- (void) prepareNavBarForLogin;
- (void) prepareNavBarForLogout;
- (void) prepareNavBarForCancel;
- (void) prepareNavBarForClose;
- (void) prepareNavBarForCreatingPlaylist;
- (void) desactivateButtonBar:(bool)left right:(bool)right;

- (void) setFlasMessage:(NSString *)msg;
- (void) loginAction:(id)sender;
- (void) cancelAction:(id)sender;
- (void) createPlaylist:(id)sender;
- (void) setUpNavLogo;
- (void) setUpLoadingView:(UIView *)viewToLoad;
- (void) cancelLoadingView:(UIView *)viewDidLoad;
- (void) updatePositionLoader:(CGRect)superViewRect;

@end
