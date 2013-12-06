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
#import "AWTracksManager.h"
#import "AWPlaylistSynchronizer.h"

@implementation AWPlaylistManager

+(AWPlaylistManager*)getInstance
{
    static AWPlaylistManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[AWPlaylistManager alloc] init];
    });
    return sharedMyManager;
}

/****************************************************/
/************* BASIC LOCAL FUNCTIONNING *************/
/****************************************************/

+(NSString *)pathOfile:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = paths[0];
    return [directory stringByAppendingPathComponent:filename];
}

+(NSString *)pathOfilePlaylist
{
    return [AWPlaylistManager pathOfile:FILE_PLAYLISTS];
}

+(void)getAllLocalPlaylists:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep
{
    dispatch_queue_t queueGlobal = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queueGlobal, ^{
        
        NSLog(@"GET in LOCAL playlists");
        NSArray *playlistsInAudioWire = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistManager pathOfilePlaylist]])
        {
            playlistsInAudioWire = [NSArray arrayWithContentsOfFile:[AWPlaylistManager pathOfilePlaylist]];
            playlistsInAudioWire = [AWPlaylistModel fromJSONArray:playlistsInAudioWire];
            
            for (AWPlaylistModel *playlist in playlistsInAudioWire)
                NSLog(@"Playlist in FILE_PLAYLISTS : %@", playlist.title);
        }
        
        if (!playlistsInAudioWire)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                cb_rep(nil, false, NSLocalizedString(@"There is no playlist stored in AudioWire. Please try to create new ones or connect your device to internet if you have created playlists on another device.", @""));
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                cb_rep(playlistsInAudioWire, true, nil);
            });
        }
    });
}

+(void)addLocalPlaylist:(AWPlaylistModel *)playlist_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    dispatch_queue_t queueGlobal = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queueGlobal, ^{
       
        NSLog(@"ADD in LOCAL playlists");
        NSMutableArray *playlistsInAudioWire = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistManager pathOfilePlaylist]])
        {
            playlistsInAudioWire = [[NSArray arrayWithContentsOfFile:[AWPlaylistManager pathOfilePlaylist]] mutableCopy];
            
            for (AWPlaylistModel *playlist in playlistsInAudioWire)
                NSLog(@"Playlist in FILE_PLAYLISTS : %@", playlist.title);
        }
        
        if (!playlistsInAudioWire)
            playlistsInAudioWire = [[NSMutableArray alloc] init];

        // ADD new playlist
        [playlistsInAudioWire addObject:[playlist_ toDictionary]];
        
        [playlistsInAudioWire writeToFile:[AWPlaylistManager pathOfilePlaylist] atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cb_rep(YES, nil);
        });
    });
}

+(void)deleteLocalPlaylist:(NSArray *)playlistsToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    dispatch_queue_t queueGlobal = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queueGlobal, ^{
        
        NSLog(@"DELETE in LOCAL playlists");
        NSMutableArray *playlistsInAudioWire = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistManager pathOfilePlaylist]])
        {
            playlistsInAudioWire = [[NSArray arrayWithContentsOfFile:[AWPlaylistManager pathOfilePlaylist]] mutableCopy];
            
            for (AWPlaylistModel *playlist in playlistsInAudioWire)
                NSLog(@"Playlist in FILE_PLAYLISTS : %@", playlist.title);
            
            
            [playlistsInAudioWire removeObjectsInArray:playlistsToDelete_];
            [playlistsInAudioWire writeToFile:[AWPlaylistManager pathOfilePlaylist] atomically:YES];
            
            
            for (AWPlaylistModel *playlist_ in playlistsToDelete_)
            {
                if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistManager pathOfile:[NSString stringWithFormat:@"%@.txt", playlist_._id]]])
                {
                    NSError *error;
                    [[NSFileManager defaultManager] removeItemAtPath:[AWPlaylistManager pathOfile:[NSString stringWithFormat:@"%@.txt", playlist_._id]] error:&error];
                     
                     NSLog(@"DELETE LOCAL tracks file : %@", [AWPlaylistManager pathOfile:[NSString stringWithFormat:@"%@.txt", playlist_._id]]);
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                cb_rep(YES, nil);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                cb_rep(NO, NSLocalizedString(@"The local file of playlists does not exist.", @""));
            });
        }
    });
}

-(void)getLocalTracksInPlaylist:(AWPlaylistModel *)playlist_ cb_rep:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep
{
    dispatch_queue_t queueGlobal = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queueGlobal, ^{
        
        NSLog(@"GET Tracks in LOCAL Playlist");
        NSMutableArray *tracksInPlaylistAudiowire = nil;

        if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistManager pathOfile:[NSString stringWithFormat:@"%@.txt", playlist_._id]]])
        {
            tracksInPlaylistAudiowire = [[NSArray arrayWithContentsOfFile:[AWPlaylistManager pathOfile:[NSString stringWithFormat:@"%@.txt", playlist_._id]]] mutableCopy];
            
            for (AWTrackModel *track in tracksInPlaylistAudiowire)
                NSLog(@"Tracks local in Playlist : %@", playlist_.title);
        }
        
        if (tracksInPlaylistAudiowire)
        {
            self.itunesMedia = nil;
            self.itunesMedia = [AWTracksManager matchWithITunesLibrary:[tracksInPlaylistAudiowire mutableCopy]];

            dispatch_async(dispatch_get_main_queue(), ^{
                cb_rep(tracksInPlaylistAudiowire, YES, nil);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                cb_rep(nil, NO, NSLocalizedString(@"The local file of playlists tracks does not exist.", @""));
            });
        }
    });
}

+(void)addLocalTracksInPlaylist:(AWPlaylistModel *)playlist_ tracks:(NSArray *)tracks_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    dispatch_queue_t queueGlobal = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queueGlobal, ^{
        
        NSLog(@"ADD Tracks in LOCAL playlists");
        
        NSMutableArray *tracksInPlaylistAudiowire = nil;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistManager pathOfile:[NSString stringWithFormat:@"%@.txt", playlist_._id]]])
        {
            tracksInPlaylistAudiowire = [[NSArray arrayWithContentsOfFile:[AWPlaylistManager pathOfile:[NSString stringWithFormat:@"%@.txt", playlist_._id]]] mutableCopy];
        }
        
        if (!tracksInPlaylistAudiowire)
            tracksInPlaylistAudiowire = [[NSMutableArray alloc] init];
        
        [tracksInPlaylistAudiowire addObjectsFromArray:tracks_];
        [tracksInPlaylistAudiowire writeToFile:[AWPlaylistManager pathOfile:[NSString stringWithFormat:@"%@.txt", playlist_._id]] atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cb_rep(YES, nil);
        });
    });
}

+(void)delLocalTracksInPlaylist:(AWPlaylistModel *)playlist_ tracks:(NSArray *)tracks_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    dispatch_queue_t queueGlobal = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queueGlobal, ^{
        
        NSLog(@"DELETE Tracks in LOCAL playlists");
        
        NSMutableArray *tracksInPlaylistAudiowire = nil;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistManager pathOfile:[NSString stringWithFormat:@"%@.txt", playlist_._id]]])
        {
            tracksInPlaylistAudiowire = [[NSArray arrayWithContentsOfFile:[AWPlaylistManager pathOfile:[NSString stringWithFormat:@"%@.txt", playlist_._id]]] mutableCopy];
            
            [tracksInPlaylistAudiowire removeObjectsInArray:tracks_];
            [tracksInPlaylistAudiowire writeToFile:[AWPlaylistManager pathOfile:[NSString stringWithFormat:@"%@.txt", playlist_._id]] atomically:YES];
        }
        
        if (tracksInPlaylistAudiowire)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                cb_rep(YES, nil);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                cb_rep(NO, NSLocalizedString(@"The local file of playlists tracks does not exist.", @""));
            });
        }
    });
}

/****************************************************/
/****************************************************/
/****************************************************/
/****************************************************/

+(void)canWorkOnline:(void(^)(BOOL workonline))cb_rep
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if (status == AFNetworkReachabilityStatusNotReachable)
             cb_rep(NO);
         else if ([[AWUserManager getInstance] isLogin] == NO)
             cb_rep(NO);
         else
             cb_rep(YES);
     }];
}

+(void)getAllPlaylists:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep
{
    [AWPlaylistManager canWorkOnline:^(BOOL workonline) {
        if (workonline)
            [AWPlaylistManager getAllServerPlaylists:cb_rep];
        
        else
            [AWPlaylistManager getAllLocalPlaylists:cb_rep];
    }];
}

+(void)addPlaylist:(AWPlaylistModel *)playlist_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    if (!playlist_)
    {
        cb_rep(false, NSLocalizedString(@"Bad playlist sent !", @""));
        return ;
    }
    
    [AWPlaylistManager canWorkOnline:^(BOOL workonline)
    {
        if (workonline)
            [AWPlaylistManager addServerPlaylist:playlist_ cb_rep:cb_rep];
        else
        {
            [AWPlaylistManager addLocalPlaylist:playlist_ cb_rep:cb_rep];
            [AWPlaylistSynchronizer addPlaylistInSyncFile:playlist_ cb_rep:cb_rep];
        }
    }];
}

+(void)deletePlaylists:(NSArray *)playlistToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    if (!playlistToDelete_)
    {
        cb_rep(false, NSLocalizedString(@"Bad playlist sents !", @""));
        return ;
    }
    
    [AWPlaylistManager canWorkOnline:^(BOOL workonline)
     {
         if (workonline)
         {
             [AWPlaylistManager deleteServerPlaylists:playlistToDelete_ cb_rep:cb_rep];
         }
         else
         {
             [AWPlaylistManager deleteLocalPlaylist:playlistToDelete_ cb_rep:cb_rep];
             [AWPlaylistSynchronizer deletePlaylistInSyncFile:playlistToDelete_ cb_rep:cb_rep];
         }
     }];
}

+(void)getTracksInPlaylist:(AWPlaylistModel *)playlist_ cb_rep:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep
{
    if (!playlist_)
    {
        cb_rep(nil, false, NSLocalizedString(@"Bad playlist sents !", @""));
        return ;
    }
    
    [AWPlaylistManager canWorkOnline:^(BOOL workonline)
     {
         if (workonline)
         {
             [[AWPlaylistManager getInstance] getServerTracksInPlaylist:playlist_ cb_rep:cb_rep];
         }
         else
         {
             [[AWPlaylistManager getInstance] getLocalTracksInPlaylist:playlist_ cb_rep:cb_rep];
         }
     }];
}

+(void)addTracksInPlaylist:(AWPlaylistModel *)playlist_ tracks:(NSArray *)tracks_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    if (!playlist_)
    {
        cb_rep(false, NSLocalizedString(@"Bad playlist sents !", @""));
        return ;
    }
    
    [AWPlaylistManager canWorkOnline:^(BOOL workonline)
     {
         if (workonline)
         {
             [AWPlaylistManager addServerTracksInPlaylist:playlist_ tracks:tracks_ cb_rep:cb_rep];
         }
         else
         {
             [AWPlaylistManager addLocalTracksInPlaylist:playlist_ tracks:tracks_ cb_rep:cb_rep];
             [AWPlaylistSynchronizer addTracksInPlaylistInSyncFile:playlist_ tracksToAdd:tracks_ cb_rep:cb_rep];
         }
     }];
}

+(void)delTracksInPlaylist:(AWPlaylistModel *)playlist_ tracks:(NSArray *)tracks_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    if (!playlist_)
    {
        cb_rep(false, NSLocalizedString(@"Bad playlist sents !", @""));
        return ;
    }
    
    [AWPlaylistManager canWorkOnline:^(BOOL workonline)
     {
         if (workonline)
         {
             [AWPlaylistManager delServerTracksInPlaylist:playlist_ tracks:tracks_ cb_rep:cb_rep];
         }
         else
         {
             [AWPlaylistManager delLocalTracksInPlaylist:playlist_ tracks:tracks_ cb_rep:cb_rep];
             [AWPlaylistSynchronizer deleteTracksInPlaylistInSyncFile:playlist_ tracksToDelete:tracks_ cb_rep:cb_rep];
         }
     }];
}

/****************************************************/
/************* ONLY ONLINE FUNCTIONNING *************/
/****************************************************/

-(void)getServerTracksInPlaylist:(AWPlaylistModel *)playlist_ cb_rep:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(nil, false, NSLocalizedString(@"Something went wrong. You are trying to get data from the API but you are not actually logged in", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWGetTracksInPlaylist], playlist_._id, token];
    
    [AWRequester requestAudiowireAPIGET:url cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successAPI = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             NSArray *list = [NSObject getVerifiedArray:[rep objectForKey:@"tracks"]];
             
             NSArray *modelsTracks = [AWTrackModel fromJSONArray:list];
             
             if (!successAPI)
                 cb_rep(nil, successAPI, error);
             else if ([modelsTracks count] == 0)
                 cb_rep(nil, false, NSLocalizedString(@"No tracks in this playlist. You should add them first from your library!", @""));
             else
             {
                 self.itunesMedia = nil;
                 self.itunesMedia = [AWTracksManager matchWithITunesLibrary:[modelsTracks mutableCopy]];
                 
                 [modelsTracks writeToFile:[AWPlaylistManager pathOfile:[NSString stringWithFormat:@"%@.txt", playlist_._id]] atomically:YES];
                 
                 cb_rep(modelsTracks, successAPI, nil);
             }
             //[AWTracksManager matchWithITunesLibrary:modelsTracks cb_rep:cb_rep];
         }
         else
             cb_rep(nil, false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
     }];
}

+(void)addServerTracksInPlaylist:(AWPlaylistModel *)playlist_ tracks:(NSArray *)tracks_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
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
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWAddTracksPlaylist], playlist_._id, token];
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
             
             if (successAPI)
                 [AWPlaylistManager addLocalTracksInPlaylist:playlist_ tracks:tracks_ cb_rep:cb_rep];
             else
                 cb_rep(successAPI, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
         }
     }];
}

+(void)delServerTracksInPlaylist:(AWPlaylistModel *)playlist_ tracks:(NSArray *)tracks_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
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
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWDelTracksPlaylist], playlist_._id, token];
    
    NSMutableDictionary *playlistsDict = [NSMutableDictionary new];
    [playlistsDict setObject:[AWTrackModel toArrayOfIds:tracks_] forKey:@"tracks_id"];
    
    [AWRequester requestAudiowireAPIPOST:url param:playlistsDict cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successAPI = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             
             if (successAPI)
                 [AWPlaylistManager delLocalTracksInPlaylist:playlist_ tracks:tracks_ cb_rep:cb_rep];
             else
                 cb_rep(successAPI, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
         }
     }];
}

+(void)addServerPlaylist:(AWPlaylistModel *)playlist_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSLog(@"ADD in SERVER playlist");
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWAddPlaylists], token];
    
    NSMutableDictionary *playlistDict = [NSMutableDictionary new];
    [playlistDict setObject:[playlist_ toDictionary] forKey:@"playlist"];
    
    [AWRequester requestAudiowireAPIPOST:url param:playlistDict cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successAPI = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];

             if (successAPI)
                 [AWPlaylistManager addLocalPlaylist:playlist_ cb_rep:cb_rep];
             else
                 cb_rep(successAPI, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
         }
     }];
}

+(void)deleteServerPlaylists:(NSArray *)playlistsToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSLog(@"DELETE in SERVER playlist");
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
    [playlistsDict setObject:[AWPlaylistModel toArrayOfIds:playlistsToDelete_] forKey:@"playlist_ids"];
    NSLog(@"Playlist to delete : %@", [playlistsDict description]);
    
    [AWRequester requestAudiowireAPIPOST:url param:playlistsDict cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successAPI = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];

             if (successAPI)
                 [AWPlaylistManager deleteLocalPlaylist:playlistsToDelete_ cb_rep:cb_rep];
             else
                 cb_rep(successAPI, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
         }
     }];
}

+(void)getAllServerPlaylists:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep
{
    NSLog(@"GET in SERVER playlist");
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
             
             if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistManager pathOfilePlaylist]])
             {
                 NSError *error;
                 [[NSFileManager defaultManager] removeItemAtPath:[AWPlaylistManager pathOfilePlaylist] error:&error];
                 if (error)
                 {
                     NSLog(@"Error => Cannot remove file at path : %@", [AWPlaylistManager pathOfilePlaylist]);
                 }
             }
             [list writeToFile:[AWPlaylistManager pathOfilePlaylist] atomically:YES];
             cb_rep([AWPlaylistModel fromJSONArray:list], successAPI, error);
         }
         else
             cb_rep(nil, false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
     }];
}


//////
/*
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
 
 NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWUpdatePlaylists],playlistToUpdate_._id,  token];
 
 [AWRequester requestAudiowireAPIPUT:url param:[playlistToUpdate_ toDictionary] cb_rep:^(NSDictionary *rep, BOOL success)
 {
 if (success && rep)
 {
 BOOL successAPI = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
 NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
 NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
 if (successAPI)
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
 */

/****************************************************/
/****************************************************/
/****************************************************/
/****************************************************/

@end
