#import "UIAudioWireCustomNavigationController.h"

@interface UIAWConnectViewController : UIViewController
{
    
}
@property (assign) BOOL skipAuth;
@property (assign) BOOL requireLogin;

@property (assign) int limit;
@property (assign) int page;
@property (assign) BOOL isSignedOut;
@property (strong, nonatomic) UIAudioWireCustomNavigationController *myCustomNavForLogin;

-(void)loadData;
-(void)runAuth;
-(void)reconnect:(BOOL)start;

@end
