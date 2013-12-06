//
//  AWFriendManager.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/28/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWUserModel.h"

@interface AWFriendManager : NSObject

+(void)getAllFriends:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep;

+(void)addFriend:(NSString *)userToAddinFrien_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

+(void)deleteFriend:(AWUserModel *)frienToDel_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

@end
