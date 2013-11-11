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

+(NSString *)pathOfileImport
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = paths[0];
    return [directory stringByAppendingString:FILE_IMPORT];
}

-(NSArray *)getAllItunesMedia
{
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    NSArray *itemsFromGenericQuery = [everything items];
    return itemsFromGenericQuery;
}

-(NSArray *)getItunesMediaAndIgnoreAlreadyImportedOnes
{
    NSArray *importedTracks = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AWItunesImportManager pathOfileImport]])
    {
        importedTracks = [[NSArray alloc] initWithContentsOfFile:[AWItunesImportManager pathOfileImport]];
        importedTracks = [AWTrackModel fromJSONArray:importedTracks];
    }
    int nbImported = importedTracks == nil ? 0 : [importedTracks count];

    NSArray *itemsFromGenericQuery = [[[MPMediaQuery alloc] init] items];
    if (!importedTracks || [importedTracks count])
    {
        self.itunesMedia = itemsFromGenericQuery;
        return itemsFromGenericQuery;
    }
    NSMutableArray *rightTracks = [[NSMutableArray alloc] initWithCapacity:([itemsFromGenericQuery count] - nbImported)];
    for (MPMediaItem *song in itemsFromGenericQuery)
    {
        for (AWTrackModel *trackModel in importedTracks)
        {
            if (![trackModel.title isEqualToString:[song valueForProperty:MPMediaItemPropertyTitle]])
            {
                [rightTracks addObject:song];
            }
        }
    }
    self.itunesMedia = rightTracks;
    return rightTracks;
}

-(void)integrateMediaInAWLibrary:(NSArray *)itunesMedia cb_rep:(void(^)(bool success, NSString *error))cb_rep
{
    NSMutableArray *tracksToSend = [[NSMutableArray alloc] initWithCapacity:[itunesMedia count]];

    for (MPMediaItem *song in itunesMedia)
    {
        AWTrackModel *trackModel = [AWTrackModel new];
        trackModel.title = [song valueForProperty:MPMediaItemPropertyTitle];
        trackModel.genre = [song valueForProperty:MPMediaItemPropertyGenre];
        
        [tracksToSend addObject:trackModel];
    }
    [AWTracksManager addTrack:tracksToSend cb_rep:^(BOOL success, NSString *error)
    {
        if (success)
            [[AWTrackModel toArray:tracksToSend] writeToFile:[AWItunesImportManager pathOfileImport] atomically:NO];
        cb_rep(success, error);
    }];
}

@end
