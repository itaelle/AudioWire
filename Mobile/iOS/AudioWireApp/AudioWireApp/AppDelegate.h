//
//  AppDelegate.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIAudioWireCustomNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate>
{
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIAudioWireCustomNavigationController *navigationController;

@end
