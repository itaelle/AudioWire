//
//  AWTracksManager.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/27/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWTrackModel.h"

@interface AWTracksManager : NSObject

@property (nonatomic, strong) NSArray *itunesMedia;
@property (nonatomic, strong) NSArray *awTracks;

+(AWTracksManager*)getInstance;
+(NSString *)pathOfileLibrary;

-(void)getAllLocalTracks:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep;
-(void)deleteLocalTracks:(NSArray *)tracksToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;
-(void)deleteItunesTrack:(NSIndexPath *)indexPath cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)getAllTracks:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep;
+(void)addTrack:(NSArray *)tracks_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;
+(void)deleteTracks:(NSArray *)tracksToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;
+(void)deleteTrack:(AWTrackModel *)trackToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

+(void)updateTrack:(AWTrackModel *)trackToUpdate_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;
+(NSMutableArray *)matchWithITunesLibrary:(NSMutableArray *)arrayTrackModel;

//+(void)matchWithITunesLibrary:(NSArray *)arrayTrackModel cb_rep:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep;

@end
