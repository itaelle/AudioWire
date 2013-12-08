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
    NSLog(@"SYNC => ADD playlist in FILE");
    if (!playlist_)
        return ;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistSynchronizer pathOfFilePlaylistSync]])
    {
        NSMutableArray *mutableArrayCommandsSync = [[NSArray arrayWithContentsOfFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync]] mutableCopy];
        
        NSDictionary *playlistDict = [playlist_ toDictionary];
        NSDictionary *newCommandForFile = @{@"command" : @"ADD",
                                            @"playlist" : playlistDict};
        
        [mutableArrayCommandsSync addObject:newCommandForFile];
        BOOL successWrite = [mutableArrayCommandsSync writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
        if (successWrite)
            cb_rep(successWrite, nil);
        else
            cb_rep(successWrite, NSLocalizedString(@"The application cannot write into the specificed file!", @""));
    }
    else
    {
        NSDictionary *playlistDict = [playlist_ toDictionary];
        NSDictionary *newCommandForFile = @{@"command" : @"ADD",
                                            @"playlist" : playlistDict};
        
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
    NSLog(@"SYNC => ADD playlist in FILE");
    
    if (!playlistsToDelete_)
        return ;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistSynchronizer pathOfFilePlaylistSync]])
    {
        NSMutableArray *mutableArrayCommandsSync = [[NSArray arrayWithContentsOfFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync]] mutableCopy];
        
        NSArray *arrayOfPLaylistToDelete = [AWPlaylistModel toArray:playlistsToDelete_];
        NSDictionary *newCommandForFile = @{@"command" : @"DEL",
                                            @"playlists" : arrayOfPLaylistToDelete};
        
        // Delete playlist from file if ADDED earlier
        for (id object in mutableArrayCommandsSync)
        {
            if (object && [object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"command"] isEqualToString:@"ADD"])
                {
                    NSDictionary *addedPlaylistInSyncFile = [object objectForKey:@"playlist"];
                    
                    for (NSDictionary *dictPlaylistToDelete in arrayOfPLaylistToDelete)
                    {
                        if ([addedPlaylistInSyncFile isEqualToDictionary:dictPlaylistToDelete])
                        {
                            [mutableArrayCommandsSync removeObject:object];
                            BOOL successWrite = [mutableArrayCommandsSync writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
                            
                            if (successWrite)
                                cb_rep(successWrite, nil);
                            else
                                cb_rep(successWrite, NSLocalizedString(@"The application cannot write into the specificed file!", @""));
                            return ;
                        }
                    }
                }
            }
        }
        //
        
        [mutableArrayCommandsSync addObject:newCommandForFile];
        BOOL successWrite = [mutableArrayCommandsSync writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
        
        if (successWrite)
            cb_rep(successWrite, nil);
        else
            cb_rep(successWrite, NSLocalizedString(@"The application cannot write into the specificed file!", @""));

    }
    else
    {
        NSArray *arrayOfDict = [AWPlaylistModel toArray:playlistsToDelete_];
        NSDictionary *newCommandForFile = @{@"command" : @"DEL",
                                            @"playlists" : arrayOfDict};
        
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
        
        NSArray *arrayOfDictTracksToDelete = [AWTrackModel toArray:tracksToDelete_];
        NSDictionary *newCommandForFile = @{@"command" : @"DEL-TRACKS",
                                            @"tracks" : [AWTrackModel toArray:tracksToDelete_],
                                            @"playlist" : [playlist_ toDictionary]
                                            };
        
        BOOL found = NO;
        // Delete tracks in playlist from file if ADDED earlier
        for (id object in mutableArrayCommandsSync)
        {
            if (object && [object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"command"] isEqualToString:@"ADD-TRACKS"])
                {
                    NSMutableArray *addedTracksInSyncFile = [[NSObject getVerifiedArray:[object objectForKey:@"tracks"]]mutableCopy];
                    NSDictionary *dictPlaylistAlreadyAdded = [object objectForKey:@"playlist"];;
                    
                    for (NSDictionary *dictTrackPlaylistToDelete in arrayOfDictTracksToDelete)
                    {
                        for (NSDictionary *dictTrackPlaylistAdded in addedTracksInSyncFile)
                            
                        {
                            if ([dictTrackPlaylistAdded isEqualToDictionary:dictTrackPlaylistToDelete])
                            {
                                if ([dictPlaylistAlreadyAdded isEqualToDictionary:[playlist_ toDictionary]])
                                {
                                    found = YES;
                                    [addedTracksInSyncFile removeObject:dictTrackPlaylistAdded];
                                    [object setValue:addedTracksInSyncFile forKey:@"tracks"];
                                }
                            }
                        }
                    }
                }
            }
        }
        //
        if (!found)
            [mutableArrayCommandsSync addObject:newCommandForFile];
        BOOL successWrite = [mutableArrayCommandsSync writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
        if (successWrite)
            cb_rep(successWrite, nil);
        else
            cb_rep(successWrite, NSLocalizedString(@"The application cannot write into the specificed file!", @""));
    }
    else
    {
        NSDictionary *newCommandForFile = @{@"command" : @"DEL-TRACKS",
                                            @"tracks" : [AWTrackModel toArray:tracksToDelete_],
                                            @"playlist" : [playlist_ toDictionary]};
        
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
    NSLog(@"ADD track in Sync File");

    if (!tracksToAdd_  || !playlist_)
        return ;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistSynchronizer pathOfFilePlaylistSync]])
    {
        NSMutableArray *mutableArrayCommandsSync = [[NSArray arrayWithContentsOfFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync]] mutableCopy];
        
        NSDictionary *newCommandForFile = @{@"command" : @"ADD-TRACKS",
                                            @"tracks" : [AWTrackModel toArray:tracksToAdd_ ],
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
        NSDictionary *newCommandForFile = @{@"command" : @"ADD-TRACKS",
                                            @"tracks" : [AWTrackModel toArray:tracksToAdd_ ],
                                            @"playlist" : [playlist_ toDictionary]};
        
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
        __block NSMutableArray *toDelete = [[NSMutableArray alloc] init];
        
        for (id object in arrayOfComands)
        {
            if (object && [object isKindOfClass:[NSDictionary class]])
            {
                NSString *command = [NSObject getVerifiedString:[((NSDictionary *)object) objectForKey:@"command"]];
                if ([command isEqualToString:@"DEL"])
                {
                    NSArray *arrayOfPlaylistsToDelete = [NSObject getVerifiedArray:[((NSDictionary *)object) objectForKey:@"playlists"]];
                    NSArray *arrayOfModelsPlaylistsToDelete = [AWPlaylistModel fromJSONArray:arrayOfPlaylistsToDelete];
                    [AWPlaylistManager deletePlaylists:arrayOfModelsPlaylistsToDelete cb_rep:nil];
                    
                    [toDelete addObject:object];
                }
                else if ([command isEqualToString:@"ADD"])
                {
                    NSDictionary *dictOfPlaylistToAdd = [NSObject getVerifiedDictionary:[((NSDictionary *)object) objectForKey:@"playlist"]];
                    
                    // Add playlist
                    AWPlaylistModel *playlistAWToAdd = [AWPlaylistModel fromJSON:dictOfPlaylistToAdd];
                    [AWPlaylistManager addPlaylist:playlistAWToAdd cb_rep:^(BOOL success, NSString *error)
                    {
                        if (success)
                        {
                            // Add music in playlist
                            for (id object2 in arrayOfComands)
                            {
                                if (object && [object isKindOfClass:[NSDictionary class]])
                                {
                                    if ([command isEqualToString:@"ADD-TRACKS"])
                                    {
                                        AWPlaylistModel *playlistModel = [AWPlaylistModel fromJSON:[((NSDictionary *)object) objectForKey:@"playlist"]];
                                        
                                        if ([playlistModel.title isEqualToString:playlistAWToAdd.title])
                                        {
                                            NSArray *arrayOfTracks = [NSObject getVerifiedArray:[((NSDictionary *)object) objectForKey:@"tracks"]];
                                            
                                            [AWPlaylistManager addTracksInPlaylist:playlistModel tracks:arrayOfTracks cb_rep:nil];
                                            
                                            [toDelete addObject:object2];
                                        }
                                    }
                                }
                            }
                        }
                    }];
                    [toDelete addObject:object];
                }
                else if ([command isEqualToString:@"DEL-TRACKS"])
                {
                    NSArray *arrayOfTracks = [NSObject getVerifiedArray:[((NSDictionary *)object) objectForKey:@"tracks"]];
                    
                    AWPlaylistModel *playlistModel = [AWPlaylistModel fromJSON:[((NSDictionary *)object) objectForKey:@"playlist"]];
                    
                    [AWPlaylistManager delTracksInPlaylist:playlistModel tracks:arrayOfTracks cb_rep:nil];

                    [toDelete addObject:object];
                }
//                else if ([command isEqualToString:@"ADD-TRACKS"])
//                {
//                    NSArray *arrayOfTracks = [NSObject getVerifiedArray:[((NSDictionary *)object) objectForKey:@"tracks"]];
//                    
//                    AWPlaylistModel *playlistModel = [AWPlaylistModel fromJSON:[((NSDictionary *)object) objectForKey:@"playlist"]];
//                    
//                    [AWPlaylistManager addTracksInPlaylist:playlistModel tracks:arrayOfTracks cb_rep:nil];
//                    
//                    [toDelete addObject:object];
//                }
//                else
//                {
//                    [arrayOfComands removeObjectsInArray:toDelete];
//                    [arrayOfComands writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
//                    cb_rep(NO, NSLocalizedString(@"Bad command found in the synchronisation file of playlists. Stop syncing!", @""));
//                    return ;
//                }
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
