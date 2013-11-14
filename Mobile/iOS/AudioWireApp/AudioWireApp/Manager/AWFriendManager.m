//
//  AWFriendManager.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/28/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWFriendManager.h"
#import "AWUserManager.h"
#import "AWConfManager.h"
#import "AWRequester.h"
#import "NSObject+NSObject_Tool.h"

@implementation AWFriendManager

-(void)getAllFriends:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(nil, false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWGetFriends], token];
    
    [AWRequester requestAudiowireAPIGET:url cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL success = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             NSArray *list = [NSObject getVerifiedArray:[rep objectForKey:@"list"]];
             
             // TODO LIST ARRAY TO MODEL ARRAY
             
             //NSArray *models = [AWUserModel fromJSONArray:list];
             
             cb_rep(list, success, error);
         }
         else
             cb_rep(nil, false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
     }];
}

-(void)addFriend:(AWUserModel *)userToAddinFrien_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWAddFriend], token];
    
    NSMutableDictionary *userDict = [NSMutableDictionary new];
    [userDict setObject:userToAddinFrien_._id forKey:@"friend_id"];
    
    [AWRequester requestAudiowireAPIPOST:url param:userDict cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL success = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             if (success)
                 cb_rep(success, message);
             else
                 cb_rep(success, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
         }
     }];
}

-(void)deleteFriend:(AWUserModel *)frienToDel_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWAddFriend], token];
    
//    NSMutableDictionary *userDict = [NSMutableDictionary new];
//    [userDict setObject:frienToDel_._id forKey:@"friend_id"];
    
    [AWRequester requestAudiowireAPIDELETE:url cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL success = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             if (success)
                 cb_rep(success, message);
             else
                 cb_rep(success, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
         }
     }];
}
@end
