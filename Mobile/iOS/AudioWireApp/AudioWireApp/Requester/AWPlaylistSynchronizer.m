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

+(void)addPlaylistInSyncFile:(AWPlaylistModel *)playlist_ cb_rep:(void (^)(BOOL success,NSString *idPLaylistCreated,  NSString *error))cb_rep
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
            cb_rep(successWrite, playlist_._id, nil);
        else
            cb_rep(successWrite, nil, NSLocalizedString(@"The application cannot write into the specificed file!", @""));
    }
    else
    {
        NSDictionary *playlistDict = [playlist_ toDictionary];
        NSDictionary *newCommandForFile = @{@"command" : @"ADD",
                                            @"playlist" : playlistDict};
        
        NSArray *arrayOfCommands = @[newCommandForFile];
        BOOL successWrite = [arrayOfCommands writeToFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync] atomically:YES];
        if (successWrite)
            cb_rep(successWrite, playlist_._id, nil);
        else
            cb_rep(successWrite, nil, NSLocalizedString(@"The application cannot write into the specificed file!", @""));
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
    NSLog(@"DELETE track in Sync FILE");

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
        
        // Delete tracks in playlist from file if ADDED earlier
        BOOL found = NO;
        for (id object in mutableArrayCommandsSync)
        {
            if (object && [object isKindOfClass:[NSDictionary class]])
            {
                if ([[object objectForKey:@"command"] isEqualToString:@"ADD-TRACKS"])
                {
                    NSMutableArray *addedTracksInSyncFile = [[NSObject getVerifiedArray:[object objectForKey:@"tracks"]]mutableCopy];
                    NSDictionary *dictPlaylistAlreadyAdded = [object objectForKey:@"playlist"];

                    if ([dictPlaylistAlreadyAdded isEqualToDictionary:[playlist_ toDictionary]])
                    {
                        for (NSDictionary *dictTrackPlaylistToDelete in arrayOfDictTracksToDelete)
                        {
                            NSMutableArray *toDeleteInAddedTracksInSyncFile = [[NSMutableArray alloc] init];
                            for (NSDictionary *dictTrackPlaylistAdded in addedTracksInSyncFile)
                                
                            {
                                if ([dictTrackPlaylistAdded isEqualToDictionary:dictTrackPlaylistToDelete])
                                {
                                    found = YES;
                                    [toDeleteInAddedTracksInSyncFile addObject:dictTrackPlaylistAdded];
                                }
                            }
                            [addedTracksInSyncFile removeObjectsInArray:toDeleteInAddedTracksInSyncFile];
                            [object setValue:addedTracksInSyncFile forKey:@"tracks"];
                            break;
                        }
                    }
                }
            }
            if (found == YES)
                break;
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
    BOOL addTracksInNewPlaylistFound = NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AWPlaylistSynchronizer pathOfFilePlaylistSync]])
    {
        NSMutableArray *arrayOfComands = [[NSArray arrayWithContentsOfFile:[AWPlaylistSynchronizer pathOfFilePlaylistSync]] mutableCopy];
        __block NSMutableArray *toDelete = [[NSMutableArray alloc] init];
        __block int nbCommandsToExecute = [arrayOfComands count];
        __block int nbCommandsExecuted = 0;
        
        for (id object in arrayOfComands)
        {
            if (object && [object isKindOfClass:[NSDictionary class]])
            {
                NSString *command = [NSObject getVerifiedString:[((NSDictionary *)object) objectForKey:@"command"]];
                if ([command isEqualToString:@"DEL"])
                {
                    NSArray *arrayOfPlaylistsToDelete = [NSObject getVerifiedArray:[((NSDictionary *)object) objectForKey:@"playlists"]];
                    NSArray *arrayOfModelsPlaylistsToDelete = [AWPlaylistModel fromJSONArray:arrayOfPlaylistsToDelete];
                    [AWPlaylistManager deletePlaylists:arrayOfModelsPlaylistsToDelete cb_rep:^(BOOL success, NSString *error) {
                        nbCommandsExecuted += 1;
                        nbCommandsExecuted += 1;
                        if (nbCommandsExecuted == nbCommandsToExecute)
                            cb_rep(YES, nil);
                    }];

                    [toDelete addObject:object];
                }
                else if ([command isEqualToString:@"ADD"])
                {
                    NSDictionary *dictOfPlaylistToAdd = [NSObject getVerifiedDictionary:[((NSDictionary *)object) objectForKey:@"playlist"]];
                    AWPlaylistModel *playlistAWToAdd = [AWPlaylistModel fromJSON:dictOfPlaylistToAdd];
                    
                    __block AWPlaylistModel *foundPlaylistModel;
                    __block NSArray *foundArrayOfTracks;
                    addTracksInNewPlaylistFound = NO;

                    // Prepare addMusic if necessary
                    for (id object2 in arrayOfComands)
                    {
                        if (object2 && [object2 isKindOfClass:[NSDictionary class]])
                        {
                            NSString *command2 = [NSObject getVerifiedString:[((NSDictionary *)object2) objectForKey:@"command"]];
                            
                            if ([command2 isEqualToString:@"ADD-TRACKS"])
                            {
                                AWPlaylistModel *playlistModel = [AWPlaylistModel fromJSON:[((NSDictionary *)object2) objectForKey:@"playlist"]];
                                
                                if ([playlistModel.title isEqualToString:playlistAWToAdd.title])
                                {
                                    foundArrayOfTracks = [NSObject getVerifiedArray:[((NSDictionary *)object2) objectForKey:@"tracks"]];
                                    addTracksInNewPlaylistFound = YES;
                                    foundPlaylistModel = playlistModel;
                                    [toDelete addObject:object2];
                                }
                            }
                        }
                    }
                    
                    // REQUEST Add playlist
                    [AWPlaylistManager addPlaylist:playlistAWToAdd cb_rep:^(BOOL success, NSString *idPlaylistCreated, NSString *error)
                    {
                        if (success)
                        {
                            foundPlaylistModel._id = idPlaylistCreated;

                            if (addTracksInNewPlaylistFound)
                            {
                                // REQUEST Add Musics in playlist
                                [AWPlaylistManager addTracksInPlaylist:foundPlaylistModel tracks:[AWTrackModel fromJSONArray:foundArrayOfTracks] cb_rep:^(BOOL success, NSString *error)
                                {
                                    NSLog(@"Server => Music added in playlist");
                                    nbCommandsExecuted += 1;
                                    if (nbCommandsExecuted == nbCommandsToExecute)
                                        cb_rep(YES, nil);
                                }];
                            }
                        }
                        nbCommandsExecuted += 1;
                        if (nbCommandsExecuted == nbCommandsToExecute)
                            cb_rep(YES, nil);

                    }];
                    [toDelete addObject:object];
                }
                else if ([command isEqualToString:@"DEL-TRACKS"])
                {
                    NSArray *arrayOfTracks = [NSObject getVerifiedArray:[((NSDictionary *)object) objectForKey:@"tracks"]];
                    
                    AWPlaylistModel *playlistModel = [AWPlaylistModel fromJSON:[((NSDictionary *)object) objectForKey:@"playlist"]];
                    
                    [AWPlaylistManager delTracksInPlaylist:playlistModel tracks:[AWTrackModel fromJSONArray:arrayOfTracks] cb_rep:^(BOOL success, NSString *error) {
                        nbCommandsExecuted += 1;
                        if (nbCommandsExecuted == nbCommandsToExecute)
                            cb_rep(YES, nil);
                    }];

                    [toDelete addObject:object];
                }
                else if ([command isEqualToString:@"ADD-TRACKS"])
                {
                    NSArray *arrayOfTracks = [NSObject getVerifiedArray:[((NSDictionary *)object) objectForKey:@"tracks"]];
                    
                    AWPlaylistModel *playlistModel = [AWPlaylistModel fromJSON:[((NSDictionary *)object) objectForKey:@"playlist"]];
                    
                    if (playlistModel && playlistModel._id && [playlistModel._id length] > 0)
                    {
                        [AWPlaylistManager addTracksInPlaylist:playlistModel tracks:[AWTrackModel fromJSONArray:arrayOfTracks] cb_rep:^(BOOL success, NSString *error) {
                            nbCommandsExecuted += 1;
                            if (nbCommandsExecuted == nbCommandsToExecute)
                                cb_rep(YES, nil);
                        }];
                        [toDelete addObject:object];
                    }
                }
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
        if (nbCommandsExecuted == nbCommandsToExecute)
            cb_rep(YES, nil);
    }
    else
    {
        cb_rep(NO, NSLocalizedString(@"No synchronisation file for the playlists found.", @""));
    }
}





@end
