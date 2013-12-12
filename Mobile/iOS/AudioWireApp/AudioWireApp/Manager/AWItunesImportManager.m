//
//  AWItunesImportManager.m
//  AudioWireApp
//
//  Created by Guilaume Derivery on 07/11/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWItunesImportManager.h"
#import "AWTrackModel.h"
#import "AWTracksManager.h"

@implementation AWItunesImportManager

+(AWItunesImportManager*)getInstance
{
    static AWItunesImportManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[AWItunesImportManager alloc] init];
    });
    return sharedMyManager;
}

-(NSArray *)getAllItunesMedia
{
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    [everything addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithBool:NO] forProperty:MPMediaItemPropertyIsCloudItem]];
    NSArray *itemsFromGenericQuery = [everything items];
    
    return itemsFromGenericQuery;
}

-(NSArray *)getItunesMediaAndIgnoreAlreadyImportedOnes
{
    NSArray *importedTracks = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AWTracksManager pathOfileLibrary]])
    {
        importedTracks = [[NSArray alloc] initWithContentsOfFile:[AWTracksManager pathOfileLibrary]];
        importedTracks = [AWTrackModel fromJSONArray:importedTracks];
        
        for (AWTrackModel *track in importedTracks)
            NSLog(@"Importe file found : %@", track.title);
    }
    int nbImported = importedTracks == nil ? 0 : [importedTracks count];
    
    NSArray *itemsFromGenericQuery = [self getAllItunesMedia];
    if (!importedTracks || [importedTracks count] == 0)
    {
        self.itunesMedia = itemsFromGenericQuery;
        return itemsFromGenericQuery;
    }
    NSMutableArray *rightTracks = [[NSMutableArray alloc] initWithCapacity:([itemsFromGenericQuery count] - nbImported)];
    for (MPMediaItem *song in itemsFromGenericQuery)
    {
        BOOL found = NO;
        
        for (AWTrackModel *trackModel in importedTracks)
        {
            if ([trackModel.title isEqualToString:[song valueForProperty:MPMediaItemPropertyTitle]])
            {
                found = YES;
                break;
            }
        }
        if (found == NO)
            [rightTracks addObject:song];
    }
    self.itunesMedia = rightTracks;
    return rightTracks;
}

-(void)integrateMediaInAWLibrary:(NSArray *)itunesMedia cb_rep:(void(^)(bool success, NSString *error))cb_rep
{
    dispatch_queue_t queueGlobal = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queueGlobal, ^{
        //code to be executed in the background
        
        NSMutableArray *tracksToSend = [[NSMutableArray alloc] initWithCapacity:[itunesMedia count]];
        for (MPMediaItem *song in itunesMedia)
        {
            if (song && [song isKindOfClass:[MPMediaItem class]])
            {
                AWTrackModel *trackModel = [AWTrackModel new];
                trackModel.title = [song valueForProperty:MPMediaItemPropertyTitle];
                trackModel.album = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
                trackModel.artist = [[song valueForProperty:MPMediaItemPropertyArtist]length] > 0 ? [song valueForProperty:MPMediaItemPropertyArtist] : [song valueForProperty:MPMediaItemPropertyAlbumArtist];
                trackModel.genre = [song valueForProperty:MPMediaItemPropertyGenre];
                trackModel.numberTrack = [song valueForProperty:MPMediaItemPropertyAlbumTrackNumber];
                trackModel.time = [song valueForProperty:MPMediaItemPropertyPlaybackDuration];
                
                if (trackModel.numberTrack == nil)
                    trackModel.numberTrack = @0;
                
                if (trackModel.title == nil)
                    trackModel.title = @"";

                if (trackModel.album == nil)
                    trackModel.album = @"";
                
                if (trackModel.artist == nil)
                    trackModel.artist = @"";
                
                if (trackModel.genre == nil)
                    trackModel.genre = @"";
                
                if (trackModel.time == nil)
                    trackModel.time = @0;
                
                [tracksToSend addObject:trackModel];
            }
        }
        
        // Local
        NSString *pathOfLibraryAW = [AWTracksManager pathOfileLibrary];
        NSLog(@"Write into file : %@", pathOfLibraryAW);
        
        BOOL sucess = [[AWTrackModel toArray:tracksToSend] writeToFile:pathOfLibraryAW atomically:NO];
        
        NSLog(@"Sucess write : %d", sucess);
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[AWTracksManager pathOfileLibrary]])
        {
            NSLog(@"Nb Items in file => %d", [[NSArray arrayWithContentsOfFile:[AWTracksManager pathOfileLibrary]] count]);
            NSLog(@"GET FROM FILE => %@", [[NSArray arrayWithContentsOfFile:[AWTracksManager pathOfileLibrary]] description]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            cb_rep(true, nil);
        });
    });
    
    // AudioWire - API Server

    //    [AWTracksManager addTrack:tracksToSend cb_rep:^(BOOL success, NSString *error)
    //    {
    //        if (success)
    //        {
    //            // TODO incorporer token sinon pour un autre user, ce sera la même chose, il ne pourra pa tout importer s'il ne l'a jamais fais
    //            [[AWTrackModel toArray:tracksToSend] writeToFile:[AWItunesImportManager pathOfileImport] atomically:NO];
    //            NSLog(@"Wrote into file %@", [AWTrackModel toArray:tracksToSend]);
    //        }
    //        cb_rep(success, error);
    //    }];
}

//+(NSString *)pathOfileImport
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *directory = paths[0];
//    return [directory stringByAppendingPathComponent:FILE_IMPORT];
//}


@end
