//
//  AWPlaylistSynchronizer.m
//  AudioWireApp
//
//  Created by Guilaume Derivery on 04/12/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWPlaylistSynchronizer.h"
#import "NSObject+NSObject_Tool.h"
#import "AWPlaylistManager.h"
#import "AWTracksManager.h"

@implementation AWPlaylistSynchronizer

+(NSString *)pathOfFilePlaylistSync
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = paths[0];
    return [directory stringByAppendingPathComponent:FILE_PLAYLIST_SYNCHRONISATION];
}

+(void)addPlaylistInSyncFile:(AWPlaylistModel *)playlist_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    if (!playlist_)
        return ;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistSynchronizer pathOfFilePlaylistSync]])
    {
        NSMutableArray *mutableArrayCommandsSync = [[NSArray arrayWithContentsOfFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync]] mutableCopy];
        
        NSDictionary *newCommandForFile = @{@"command" : @"ADD",
                                            @"playlist" : [playlist_ toDictionary]};
        
        [mutableArrayCommandsSync addObject:newCommandForFile];
        BOOL successWrite = [mutableArrayCommandsSync writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
        if (successWrite)
            cb_rep(successWrite, nil);
        else
            cb_rep(successWrite, NSLocalizedString(@"The application cannot write into the specificed file!", @""));
    }
    else
    {
        NSDictionary *newCommandForFile = @{@"command" : @"ADD",
                                            @"playlist" : playlist_};
        
        NSArray *arrayOfCommands = @[newCommandForFile];
        BOOL successWrite = [arrayOfCommands writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
        if (successWrite)
            cb_rep(successWrite, nil);
        else
            cb_rep(successWrite, NSLocalizedString(@"The application cannot write into the specificed file!", @""));
    }
}

+(void)deletePlaylistInSyncFile:(NSArray*)playlistsToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    if (!playlistsToDelete_)
        return ;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistSynchronizer pathOfFilePlaylistSync]])
    {
        NSMutableArray *mutableArrayCommandsSync = [[NSArray arrayWithContentsOfFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync]] mutableCopy];
        
        NSDictionary *newCommandForFile = @{@"command" : @"DEL",
                                            @"playlist" : [AWPlaylistModel toArray:playlistsToDelete_]};
        
        [mutableArrayCommandsSync addObject:newCommandForFile];
        [mutableArrayCommandsSync writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
    }
    else
    {
        NSDictionary *newCommandForFile = @{@"command" : @"DEL",
                                            @"playlists" : playlistsToDelete_};
        
        NSArray *arrayOfCommands = @[newCommandForFile];
        BOOL successWrite = [arrayOfCommands writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
        if (successWrite)
            cb_rep(successWrite, nil);
        else
            cb_rep(successWrite, NSLocalizedString(@"The application cannot write into the specificed file!", @""));
    }
}


+(void)deleteTracksInPlaylistInSyncFile:(AWPlaylistModel *)playlist_ tracksToDelete:(NSArray*)tracksToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    if (!tracksToDelete_ || !playlist_)
        return ;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistSynchronizer pathOfFilePlaylistSync]])
    {
        NSMutableArray *mutableArrayCommandsSync = [[NSArray arrayWithContentsOfFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync]] mutableCopy];
        
        NSDictionary *newCommandForFile = @{@"command" : @"DEL-TRACKS",
                                            @"tracks" : [AWTrackModel toArray:tracksToDelete_],
                                            @"playlist" : playlist_
                                            };
        
        [mutableArrayCommandsSync addObject:newCommandForFile];
        [mutableArrayCommandsSync writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
    }
    else
    {
        NSDictionary *newCommandForFile = @{@"command" : @"DEL-TRACKS",
                                            @"tracks" : [AWTrackModel toArray:tracksToDelete_],
                                            @"playlist" : playlist_};
        
        NSArray *arrayOfCommands = @[newCommandForFile];
        BOOL successWrite = [arrayOfCommands writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
        if (successWrite)
            cb_rep(successWrite, nil);
        else
            cb_rep(successWrite, NSLocalizedString(@"The application cannot write into the specificed file!", @""));
    }
}

+(void)addTracksInPlaylistInSyncFile:(AWPlaylistModel *)playlist_ tracksToAdd:(NSArray*)tracksToAdd_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    if (!tracksToAdd_  || !playlist_)
        return ;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistSynchronizer pathOfFilePlaylistSync]])
    {
        NSMutableArray *mutableArrayCommandsSync = [[NSArray arrayWithContentsOfFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync]] mutableCopy];
        
        NSDictionary *newCommandForFile = @{@"command" : @"ADD-TRACKS",
                                            @"tracks" : [AWTrackModel toArray:tracksToAdd_ ],
                                            @"playlist" : playlist_};
        
        [mutableArrayCommandsSync addObject:newCommandForFile];
        [mutableArrayCommandsSync writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
    }
    else
    {
        NSDictionary *newCommandForFile = @{@"command" : @"ADD-TRACKS",
                                            @"tracks" : [AWTrackModel toArray:tracksToAdd_ ],
                                            @"playlist" : playlist_};
        
        NSArray *arrayOfCommands = @[newCommandForFile];
        BOOL successWrite = [arrayOfCommands writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
        if (successWrite)
            cb_rep(successWrite, nil);
        else
            cb_rep(successWrite, NSLocalizedString(@"The application cannot write into the specificed file!", @""));
    }
}

+(BOOL)isThereSomethingToSynchronize
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistSynchronizer pathOfFilePlaylistSync]])
    {
        NSArray *arrayOfComands = [NSArray arrayWithContentsOfFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync]];
        if (arrayOfComands && [arrayOfComands count] > 0)
            return YES;
    }
    return NO;
}

+(void)runPlaylistSync:(void (^)(BOOL success, NSString *error))cb_rep
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistSynchronizer pathOfFilePlaylistSync]])
    {
        NSMutableArray *arrayOfComands = [[NSArray arrayWithContentsOfFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync]] mutableCopy];
        NSMutableArray *toDelete = [[NSMutableArray alloc] init];
        
        for (id object in arrayOfComands)
        {
            if (object && [object isKindOfClass:[NSDictionary class]])
            {
                NSString *command = [NSObject getVerifiedString:[((NSDictionary *)object) objectForKey:@"command"]];
                if ([command isEqualToString:@"DEL"])
                {
                    NSArray *arrayOfPlaylistsToDelete = [NSObject getVerifiedArray:[((NSDictionary *)object) objectForKey:@"playlists"]];
                    NSArray *arrayOfModelsPlaylistsToDelete = [AWPlaylistModel fromJSONArray:arrayOfPlaylistsToDelete];
                    [AWPlaylistManager deletePlaylists:arrayOfModelsPlaylistsToDelete cb_rep:cb_rep];
                    
                    [toDelete addObject:object];
                }
                else if ([command isEqualToString:@"ADD"])
                {
                    NSDictionary *dictOfPlaylistToAdd = [NSObject getVerifiedDictionary:[((NSDictionary *)object) objectForKey:@"playlist"]];
                    
                    [AWPlaylistManager addPlaylist:[AWPlaylistModel fromJSON:dictOfPlaylistToAdd] cb_rep:cb_rep];
                    
                    [toDelete addObject:object];
                }
                else if ([command isEqualToString:@"DEL-TRACKS"])
                {
                    NSArray *arrayOfTracks = [NSObject getVerifiedArray:[((NSDictionary *)object) objectForKey:@"tracks"]];
                    
                    AWPlaylistModel *playlistModel = [AWPlaylistModel fromJSON:[((NSDictionary *)object) objectForKey:@"playlist"]];
                    
                    [AWPlaylistManager delTracksInPlaylist:playlistModel tracks:arrayOfTracks cb_rep:cb_rep];

                    [toDelete addObject:object];
                }
                else if ([command isEqualToString:@"ADD-TRACKS"])
                {
                    NSArray *arrayOfTracks = [NSObject getVerifiedArray:[((NSDictionary *)object) objectForKey:@"tracks"]];
                    
                    AWPlaylistModel *playlistModel = [AWPlaylistModel fromJSON:[((NSDictionary *)object) objectForKey:@"playlist"]];
                    
                    [AWPlaylistManager addTracksInPlaylist:playlistModel tracks:arrayOfTracks cb_rep:cb_rep];
                    
                    [toDelete addObject:object];
                }
                else
                {
                    [arrayOfComands removeObjectsInArray:toDelete];
                    [arrayOfComands writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
                    cb_rep(NO, NSLocalizedString(@"Bad command found in the synchronisation file of playlists.", @""));
                }
            }
        }
        [arrayOfComands removeObjectsInArray:toDelete];
        [arrayOfComands writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
        cb_rep(YES, nil);
    }
    else
    {
        cb_rep(NO, NSLocalizedString(@"No synchronisation file for the playlists found.", @""));
    }
}





@end
