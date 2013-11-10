//
//  AWPlaylistManager.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/28/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWPlaylistManager.h"
#import "AWUserManager.h"
#import "AWConfManager.h"
#import "AWRequester.h"
#import "AWPlaylistModel.h"
#import "NSObject+NSObject_Tool.h"
#import "AWTrackModel.h"

@implementation AWPlaylistManager

+(void)getAllPlaylists:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(nil, false, NSLocalizedString(@"Something went wrong. You are trying to get data from the API but you are not actually logged in", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWGetPlaylists], token];
    
    [AWRequester requestAudiowireAPIGET:url cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successAPI = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             NSArray *list = [NSObject getVerifiedArray:[rep objectForKey:@"list"]];
             
             cb_rep([AWPlaylistModel fromJSONArray:list], successAPI, error);
         }
         else
             cb_rep(nil, false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
     }];
}

+(void)addPlaylist:(AWPlaylistModel *)playlist_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWAddPlaylists], token];
    
    if (!playlist_)
    {
        cb_rep(false, NSLocalizedString(@"Bad playlist sent !", @""));
        return ;
    }
    
    NSMutableDictionary *playlistDict = [NSMutableDictionary new];
    [playlistDict setObject:[playlist_ toDictionary] forKey:@"playlist"];
    
    [AWRequester requestAudiowireAPIPOST:url param:playlistDict cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successAPI = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             if (success)
                 cb_rep(successAPI, message);
             else
                 cb_rep(successAPI, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
         }
     }];
}

+(void)deletePlaylist:(NSArray *)playlistsToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    if (!playlistsToDelete_ || [playlistsToDelete_ count] == 0)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to delete some playlists but they do not exist", @""));
        return ;
    }
   
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWDelPlaylists], token];
    
    NSMutableDictionary *playlistsDict = [NSMutableDictionary new];
    [playlistsDict setObject:[AWPlaylistModel toArrayOfIds:playlistsToDelete_] forKey:@"playlists_id"];
    
    [AWRequester requestAudiowireAPIDELETE:url param:playlistsDict cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successAPI = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             if (success)
                 cb_rep(successAPI, message);
             else
                 cb_rep(successAPI, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
         }
     }];
}

+(void)updatePlaylist:(AWPlaylistModel *)playlistToUpdate_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    if (!playlistToUpdate_)
    {
        cb_rep(false, NSLocalizedString(@"Bad playlist sent !", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWUpdatePlaylists], token];
    
    [AWRequester requestAudiowireAPIPUT:url param:[playlistToUpdate_ toDictionary] cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successAPI = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             if (success)
                 cb_rep(successAPI, message);
             else
                 cb_rep(successAPI, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
         }
     }];
}

+(void)addTracksInPlaylist:(AWPlaylistModel *)playlist_ tracks:(NSArray *)tracks_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    if (!playlist_ || !playlist_._id)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to add some tracks in a playlist but its id does not exist", @""));
        return ;
    }
    
    if (!tracks_ || [tracks_ count] == 0)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to add some tracks in a playlist but those tracks seem to be inexsitant", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWAddTracksPlaylist], token];
    NSMutableDictionary *playlistsDict = [NSMutableDictionary new];
    [playlistsDict setObject:playlist_._id forKey:@"playlist_id"];
    [playlistsDict setObject:[AWTrackModel toArrayOfIds:tracks_] forKey:@"tracks_id"];
    
    [AWRequester requestAudiowireAPIPOST:url param:playlistsDict cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successAPI = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             if (success)
                 cb_rep(successAPI, message);
             else
                 cb_rep(successAPI, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
         }
     }];
}

+(void)delTracksInPlaylist:(AWPlaylistModel *)playlist_ tracks:(NSArray *)tracks_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    if (!playlist_ || !playlist_._id)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to add some tracks in a playlist but its id does not exist", @""));
        return ;
    }
    
    if (!tracks_ || [tracks_ count] == 0)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to add some tracks in a playlist but those tracks seem to be inexsitant", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWDelTracksPlaylist], token];
    NSMutableDictionary *playlistsDict = [NSMutableDictionary new];
    [playlistsDict setObject:playlist_._id forKey:@"playlist_id"];
    [playlistsDict setObject:[AWTrackModel toArrayOfIds:tracks_] forKey:@"tracks_id"];
    
    [AWRequester requestAudiowireAPIDELETE:url param:playlistsDict cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successAPI = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             if (success)
                 cb_rep(successAPI, message);
             else
                 cb_rep(successAPI, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
         }
     }];
}

@end
