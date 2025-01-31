#import <Foundation/Foundation.h>
#import "AWUserModel.h"

@interface AWFriendManager : NSObject

+(void)getAllFriends:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep;

+(void)addFriend:(NSString *)userToAddinFrien_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

+(void)deleteFriend:(NSArray *)friendsToDel_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

@end
