//
//  AWTracksManager.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/27/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWTracksManager.h"
#import "AWUserManager.h"
#import "AWConfManager.h"
#import "AWRequester.h"
#import "NSObject+NSObject_Tool.h"
#import "AWTrackModel.h"

@implementation AWTracksManager

-(void)getAllTracks:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
        cb_rep(nil, false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWGetTracks], token];
    
    [AWRequester requestAudiowireAPIGET:url cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL success = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             NSArray *list = [NSObject getVerifiedArray:[rep objectForKey:@"list"]];
             NSArray *models = [AWTrackModel fromJSONArray:list];
             cb_rep(models, success, error);
         }
         else
             cb_rep(nil, false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
     }];
}

-(void)addTrack:(NSArray *)tracks_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWAddTrack], token];
    
    NSMutableDictionary *userDict = [NSMutableDictionary new];
    [userDict setObject:[AWTrackModel toArray:tracks_] forKey:@"tracks"];
    
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

-(void)updateTrack:(AWTrackModel *)trackToUpdate_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWUpdateTrack], token];
    
    if (!trackToUpdate_)
        cb_rep(false, NSLocalizedString(@"Bad track sent !", @""));
               
    [AWRequester requestAudiowireAPIPUT:url param:[trackToUpdate_ toDictionary] cb_rep:^(NSDictionary *rep, BOOL success)
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

-(void)deleteTrack:(NSArray *)tracksToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWAddTrack], token];
    
    NSMutableDictionary *userDict = [NSMutableDictionary new];
    [userDict setObject:[AWTrackModel toArrayOfIds:tracksToDelete_] forKey:@"tracks_id"];
    
    [AWRequester requestAudiowireAPIDELETE:url param:userDict cb_rep:^(NSDictionary *rep, BOOL success)
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

