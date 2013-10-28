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

-(void)getAllTracks:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep;
-(void)addTrack:(NSArray *)tracks_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;
-(void)deleteTrack:(NSArray *)tracksToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;
-(void)updateTrack:(AWTrackModel *)trackToUpdate_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

@end
