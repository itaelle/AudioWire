//
//  MasterViewController.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "UIAWConnectViewController.h"
#import "SubPlayer.h"
#import "OLGhostAlertView.h"

@interface AWMasterViewController : UIAWConnectViewController<SubPlayerDelegate>
{
    UIView *loadingView_;
    UIActivityIndicatorView *spinner;
    bool isLoading;
    bool needASubPlayer;
    
    SubPlayer *miniPlayer;
    OLGhostAlertView *flash;
}

- (void) prepareNavBarForCancel;
- (void) prepareNavBarForCancel:(BOOL)isLeft;
- (void) prepareNavBarForClose;
- (void) prepareNavBarForEditing;
- (void) prepareNavBarForEditing:(BOOL)isLeft;
- (void) prepareNavBarForAdding;
- (void) prepareNavBarForAdding:(BOOL)isLeft;
- (void) prepareNavBarForImport;
- (void) prepareNavBarForRemote;
- (void) desactivateButtonBar:(bool)left right:(bool)right;

- (void) cancelAction:(id)sender;
- (void) closeAction:(id)sender;
- (void) addAction:(id)sender;

- (void) setFlashMessage:(NSString *)msg;
- (void) setFlashMessage:(NSString *)msg timeout:(NSTimeInterval)timeout_;
- (void) setUpNavLogo;
- (void) setUpLoadingView:(UIView *)viewToLoad;
- (void) cancelLoadingView:(UIView *)viewDidLoad;
- (void) updatePositionLoader:(CGRect)superViewRect;

@end
