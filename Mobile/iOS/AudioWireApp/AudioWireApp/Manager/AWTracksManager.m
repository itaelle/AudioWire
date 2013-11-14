//
//  AWTracksManager.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/27/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "AWTracksManager.h"
#import "AWUserManager.h"
#import "AWConfManager.h"
#import "AWRequester.h"
#import "NSObject+NSObject_Tool.h"
#import "AWTrackModel.h"
#import "AWItunesImportManager.h"

@implementation AWTracksManager

+(AWTracksManager*)getInstance
{
    static AWTracksManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[AWTracksManager alloc] init];
    });
    return sharedMyManager;
}

//+(void)matchWithITunesLibrary:(NSArray *)arrayTrackModel cb_rep:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep
//{
//    NSArray *itunesMedia = [[AWItunesImportManager getInstance] getAllItunesMedia];
// 
//    for (MPMediaItem *object in itunesMedia)
//    {
//        for (AWTrackModel *trackModel in arrayTrackModel)
//        {
//            if ([trackModel.title isEqualToString:[object valueForProperty:MPMediaItemPropertyTitle]])
//            {
//                trackModel.iTunesItem = [object copy];
//                break;
//            }
//        }
//    }
//    cb_rep(arrayTrackModel, true, nil);
//}

+(NSMutableArray *)matchWithITunesLibrary:(NSArray *)arrayTrackModel
{
    NSArray *itunesMedia = [[AWItunesImportManager getInstance] getAllItunesMedia];
    NSMutableArray *itunesMediaMatch = [[NSMutableArray alloc] initWithCapacity:[arrayTrackModel count]];
    
    for (AWTrackModel *trackModel in arrayTrackModel)
    {
        for (MPMediaItem *object in itunesMedia)
        {
            if ([trackModel.title isEqualToString:[object valueForProperty:MPMediaItemPropertyTitle]])
            {
                //trackModel.iTunesItem = [object copy];
                [itunesMediaMatch addObject:object];
                break;
            }
        }
    }
    return itunesMediaMatch;
}

-(void)getAllTracks:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(nil, false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWGetTracks], token];
    
    [AWRequester requestAudiowireAPIGET:url cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successApi = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             NSArray *list = [NSObject getVerifiedArray:[rep objectForKey:@"list"]];
             NSArray *models = [AWTrackModel fromJSONArray:list];
             
             if (!successApi)
                 cb_rep(nil, successApi, error);
             else if ([models count] == 0)
                 cb_rep(nil, false, NSLocalizedString(@"No tracks in your library. You should import them first from your home screen!", @""));
             else
             {
                 self.itunesMedia = nil;
                 self.itunesMedia = [AWTracksManager matchWithITunesLibrary:models];
                 cb_rep(models, successApi, nil);
             }
         }
         else
             cb_rep(nil, false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
     }];
}

+(void)addTrack:(NSArray *)tracks_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWAddTracks], token];
    
    NSMutableDictionary *userDict = [NSMutableDictionary new];
    [userDict setObject:[AWTrackModel toArray:tracks_] forKey:@"tracks"];
    
    [AWRequester requestAudiowireAPIPOST:url param:userDict cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successApi = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             if (success)
                 cb_rep(successApi, message);
             else
                 cb_rep(successApi, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
         }
     }];
}

+(void)updateTrack:(AWTrackModel *)trackToUpdate_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    if (!trackToUpdate_ || !trackToUpdate_._id)
    {
        cb_rep(false, NSLocalizedString(@"The selected track is incorrect, it cannot be updated !", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWUpdateTrack], trackToUpdate_._id, token];
    
    [AWRequester requestAudiowireAPIPUT:url param:[trackToUpdate_ toDictionary] cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successApi = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             if (success)
                 cb_rep(successApi, message);
             else
                 cb_rep(successApi, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
         }
     }];
}

+(void)deleteTracks:(NSArray *)tracksToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWDelTracks], token];
    
    NSMutableDictionary *userDict = [NSMutableDictionary new];
    [userDict setObject:[AWTrackModel toArrayOfIds:tracksToDelete_] forKey:@"tracks_id"];
    
    [AWRequester requestAudiowireAPIPOST:url param:userDict cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successApi = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             if (success)
                 cb_rep(successApi, message);
             else
                 cb_rep(successApi, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
         }
     }];
}

+(void)deleteTrack:(AWTrackModel *)trackToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    if (!trackToDelete_ || !trackToDelete_._id)
    {
        cb_rep(false, NSLocalizedString(@"The selected track is incorrect, it cannot be updated !", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWDelTrack], trackToDelete_._id, token];

    [AWRequester requestAudiowireAPIDELETE:url cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successApi = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             if (success)
                 cb_rep(successApi, message);
             else
                 cb_rep(successApi, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
         }
     }];
}

@end

