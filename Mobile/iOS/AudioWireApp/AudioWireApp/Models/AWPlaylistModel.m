//
//  AWPlaylistModel.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/28/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWPlaylistModel.h"
#import "NSObject+NSObject_Tool.h"

@implementation AWPlaylistModel

-(NSDictionary *)toDictionary
{
    if (self._id)
        return @{@"playlist_id" : self._id,
                 @"title" : self.title,
                 @"nb_tracks" : [NSNumber numberWithInt:self.nb_tracks]
                 };
    else
        return @{@"title" : self.title
                 };
}

+(NSArray *)toArrayOfIds:(NSArray *)playlistModels_
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[playlistModels_ count]];
    for (id object in playlistModels_)
    {
        if (object && [object isKindOfClass:[AWPlaylistModel class]])
            [ret addObject:((AWPlaylistModel*)object)._id];
    }
    return ret;
}

+(AWPlaylistModel *) fromJSON:(NSDictionary*)data
{
    AWPlaylistModel *playlistModel = [AWPlaylistModel new];
    
    if (data && [data isKindOfClass:[NSDictionary class]])
    {
        playlistModel._id = [NSObject getVerifiedString:[data objectForKey:@"id"]];
        playlistModel.title = [NSObject getVerifiedString:[data objectForKey:@"title"]];
    }
    return playlistModel;
}

+(NSArray *) fromJSONArray:(NSArray*)data
{
    NSArray *a = [NSObject getVerifiedArray:data];
    
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    for (id object in a)
    {
        [ret addObject:[AWPlaylistModel fromJSON:object]];
    }
    return ret;
}

@end
