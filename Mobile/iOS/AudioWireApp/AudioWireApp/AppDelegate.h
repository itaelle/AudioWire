#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIAudioWireCustomNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate>
{
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIAudioWireCustomNavigationController *navigationController;

@end
