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

/****************************************************/
/************* BASIC LOCAL FUNCTIONNING *************/
/****************************************************/

+(NSString *)pathOfileLibrary
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = paths[0];
    return [directory stringByAppendingPathComponent:FILE_LIBRARY];
}

-(void)deleteItunesTrack:(NSIndexPath *)indexPath cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    if (self.itunesMedia)
    {
        if ([self.itunesMedia count] > indexPath.row)
        {
            NSMutableArray *tempItunesMedia = [self.itunesMedia mutableCopy];
            [tempItunesMedia removeObjectAtIndex:indexPath.row];

            self.itunesMedia = tempItunesMedia;
        }
    }
    else
        cb_rep(NO, NSLocalizedString(@"Itunes media list is not currently available!", @""));
}

-(void)deleteLocalTracks:(NSArray *)tracksToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    dispatch_queue_t queueGlobal = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queueGlobal, ^{
        
        NSMutableArray *mutableAwTracks = [self.awTracks mutableCopy];
        
        for (AWTrackModel *trackToDelete in tracksToDelete_)
        {
            if ([mutableAwTracks containsObject:trackToDelete])
            {
                [mutableAwTracks removeObject:trackToDelete];
            }
        }
        
        self.awTracks = nil;
        self.awTracks = mutableAwTracks;

        BOOL success = [[AWTrackModel toArray:mutableAwTracks] writeToFile:[AWTracksManager pathOfileLibrary] atomically:YES];;
    
        if (success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                cb_rep(YES, nil);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                cb_rep(NO, NSLocalizedString(@"Write in library file failed!", @""));
            });
        }
    });
}

-(void)getAllLocalTracks:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep
{
    // Get from Local file
    // Remove in local file the deleted tracks from itunes
    // Create an array of matched MPMediaItems from tracks in AudioWire
    
    dispatch_queue_t queueGlobal = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queueGlobal, ^{
        
        NSArray *alreadyInAudioWire = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[AWTracksManager pathOfileLibrary]])
        {
            alreadyInAudioWire = [NSArray arrayWithContentsOfFile:[AWTracksManager pathOfileLibrary]];
            alreadyInAudioWire = [AWTrackModel fromJSONArray:alreadyInAudioWire];
            
            for (AWTrackModel *track in alreadyInAudioWire)
                NSLog(@"Tracks FILE_LIBRARY : %@", track.title);
        }
        if (!alreadyInAudioWire || [alreadyInAudioWire count] == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                cb_rep(nil, false, NSLocalizedString(@"You don't have any tracks in your AudioWire library, you can import new ones from the home screen!", @""));
            });
            return ;
        }
        
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>> File");
        for (int index = 0; index < [alreadyInAudioWire count]; index++)
        {
            NSLog(@"%@", ((AWTrackModel *)[alreadyInAudioWire objectAtIndex:index]).title);
        }
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>> File");
        
        
        NSMutableArray *alreadyInAudioWireAndNewOnesFromItunes = [alreadyInAudioWire mutableCopy];
        NSArray *itemsFromGenericQuery = [[AWItunesImportManager getInstance] getAllItunesMedia];
        
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>> Found from Itunes LIBRARY");
        for (int index = 0; index < [itemsFromGenericQuery count]; index++)
        {
            NSLog(@"%@", [[itemsFromGenericQuery objectAtIndex:index] valueForProperty:MPMediaItemPropertyTitle]);
        }
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>> Found from Itunes LIBRARY");
        
        
        NSMutableArray *sortedArray = [[alreadyInAudioWireAndNewOnesFromItunes sortedArrayUsingComparator:^NSComparisonResult(id a, id b)
        {
            NSString *first = [(AWTrackModel*)a title];
            NSString *second = [(AWTrackModel*)b title];
            return [first compare:second];
        }] mutableCopy];
        
        alreadyInAudioWireAndNewOnesFromItunes = sortedArray;
        
        // DELETE TRACKS IN AW THAT HAS BEEN DELETED IN iTUNES.
        NSMutableArray *toDelete = [[NSMutableArray alloc] init];
        NSMutableArray *itunesMediaMatch = [[NSMutableArray alloc] initWithCapacity:[alreadyInAudioWireAndNewOnesFromItunes count]];
        for (AWTrackModel *trackModel in alreadyInAudioWireAndNewOnesFromItunes)
        {
            BOOL found = FALSE;
            for (MPMediaItem *song in itemsFromGenericQuery)
            {
                if ([trackModel.title isEqualToString:[song valueForProperty:MPMediaItemPropertyTitle]])
                {
                    // The media saved in file is still in iTunes library;
                    found = YES;
                    [itunesMediaMatch addObject:song];
                    break;
                }
            }
            if (found == NO)
                [toDelete addObject:trackModel];
        }
        [alreadyInAudioWireAndNewOnesFromItunes removeObjectsInArray:toDelete];
        BOOL successWrite = [[AWTrackModel toArray:alreadyInAudioWireAndNewOnesFromItunes] writeToFile:[AWTracksManager pathOfileLibrary] atomically:YES];
        //
        
        if (!successWrite)
        {
            NSLog(@"Write failed in GetAllLocalTracks");
        }
        
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>> AWTrackModel match With Itunes");
        for (int index = 0; index < [alreadyInAudioWireAndNewOnesFromItunes count]; index++)
        {
            NSLog(@"%@", ((AWTrackModel *)[alreadyInAudioWireAndNewOnesFromItunes objectAtIndex:index]).title);
        }
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>> AWTrackModel match With Itunes");
        
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>> Match with Itunes");
        for (int index = 0; index < [itunesMediaMatch count]; index++)
        {
            NSLog(@"%@", [[itunesMediaMatch objectAtIndex:index] valueForProperty:MPMediaItemPropertyTitle]);
        }
        NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>> Match with Itunes");
        
        self.awTracks = alreadyInAudioWireAndNewOnesFromItunes; // TODO necessary ?
        self.itunesMedia = itunesMediaMatch;
        
        if (!self.awTracks || !self.itunesMedia || [self.itunesMedia count] == 0 || [self.awTracks count] == 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                cb_rep(nil, false, NSLocalizedString(@"The tracks of your library doesn't match the ones you have in iTunes. You can import new from the home screen!", @""));
            });
            return ;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cb_rep(alreadyInAudioWireAndNewOnesFromItunes, true, nil);
        });
    });
}

/****************************************************/
/****************************************************/
/****************************************************/
/****************************************************/








/****************************************************/
/************* ONLY ONLINE FUNCTIONNING *************/
/****************************************************/

+(NSMutableArray *)matchWithITunesLibrary:(NSMutableArray *)arrayTrackModel
{
    NSMutableArray *toDelete = [[NSMutableArray alloc] init];
    NSArray *itunesMedia = [[AWItunesImportManager getInstance] getAllItunesMedia];
    NSMutableArray *itunesMediaMatch = [[NSMutableArray alloc] initWithCapacity:[arrayTrackModel count]];
    
    if (!itunesMedia || [itunesMedia count] == 0)
        [arrayTrackModel removeAllObjects];
    for (int index = 0; index < [arrayTrackModel count]; index++)
    {
        AWTrackModel *trackModel = [arrayTrackModel objectAtIndex:index];
        BOOL foundInItunes = NO;
        
        for (int i = 0; i < [itunesMedia count]; i++)
        {
            MPMediaItem *object = [itunesMedia objectAtIndex:i];
            
            if ([trackModel.title isEqualToString:[object valueForProperty:MPMediaItemPropertyTitle]])
            {
                foundInItunes = YES;
                [itunesMediaMatch addObject:[object copy]];
                break;
            }
        }
        if (foundInItunes == NO)
        {
            NSLog(@"Delete from api %@ at index %d", trackModel.title, index);
            [toDelete addObject:trackModel];
        }
        else
        {
            NSLog(@"Keep from api %@", trackModel.title);
        }
    }
    // TODO SYNC remove objects on server side that is not in your itunes
    [arrayTrackModel removeObjectsInArray:toDelete];

    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>> Found from Itunes");
    for (int index = 0; index < [itunesMediaMatch count]; index++)
    {
        NSLog(@"%@", [[itunesMediaMatch objectAtIndex:index] valueForProperty:MPMediaItemPropertyTitle]);
    }
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>> Found from Itunes");
    
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>> Available from API after Match");
    for (int index = 0; index < [arrayTrackModel count]; index++)
    {
        NSLog(@"%@", ((AWTrackModel *)[arrayTrackModel objectAtIndex:index]).title);
    }
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>> Available from API after Match");
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
             NSMutableArray *models = [[AWTrackModel fromJSONArray:list] mutableCopy];
             
             if (!successApi)
                 cb_rep(nil, successApi, error);
             else if ([models count] == 0)
                 cb_rep(nil, false, NSLocalizedString(@"No tracks in your library. You should import them first from your home screen!", @""));
             else
             {
                 self.itunesMedia = nil;
                 self.itunesMedia = [AWTracksManager matchWithITunesLibrary:models];
                 if ([models count] == 0)
                 {
                     cb_rep(nil, false, NSLocalizedString(@"The tracks of your library doesn't match the ones you have in iTunes. You can import new from the home screen!", @""));
                     return ;
                 }
                 else
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

/****************************************************/
/****************************************************/
/****************************************************/
/****************************************************/

@end

