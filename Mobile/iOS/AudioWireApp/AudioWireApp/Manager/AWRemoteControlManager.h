//
//  AWRemoteControlManager.h
//  AudioWireApp
//
//  Created by Guilaume Derivery on 12/12/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SocketIO.h"
#import <UIKit/UIKit.h>

#define AWPLAY @"PLAY"
#define AWPAUSE @"PAUSE"
#define AWSTOP @"STOP"
#define AWPREV @"PREV"
#define AWNEXT @"NEXT"
#define AWSHUFFLE @"SHUFFLE"
#define AWREPEAT @"REPEAT"

typedef enum
{
    AWPlay,
    AWPause,
    AWStop,
    AWPrev,
    AWNext,
    AWShuffle,
    AWRepeat
} AWRemoteCommand;

@interface AWRemoteControlManager : NSObject<NSStreamDelegate>
{
    void(^callBackReceiveMsg)(NSString *);
    void(^callBackConnection)(BOOL);
    void(^callBackDisconnection)(BOOL);
//    SocketIO *socketIO;
    
    NSInputStream	*inputStream;
	NSOutputStream	*outputStream;
    
	NSMutableArray	*messages;
}

+(AWRemoteControlManager*)getInstance;

-(void)connectToAWHost:(void(^)(BOOL ok))cb_connect cb_receive:(void(^)(NSString *msg))cb_receive_;

-(void)sendCommand:(AWRemoteCommand)command;

-(void)discconnectFromAWHost:(void(^)(BOOL ok))cb_disconnection;

@end
