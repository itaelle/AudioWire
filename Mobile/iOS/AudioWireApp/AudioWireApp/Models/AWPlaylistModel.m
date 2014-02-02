#import "AWPlaylistModel.h"
#import "NSObject+NSObject_Tool.h"

@implementation AWPlaylistModel

-(NSDictionary *)toDictionary
{
    if (self._id && [self._id length] > 0)
        return @{@"id" : [NSNumber numberWithInt:[self._id intValue]],
                 @"title" : self.title,
                 @"nb_tracks" : [NSNumber numberWithInt:self.nb_tracks]
                 };
    else if (self.nb_tracks == -1)
        return @{@"title" : self.title
//                 @"nb_tracks" : [NSNumber numberWithInt:self.nb_tracks]
                 };
    else
        return @{@"title" : self.title,
                 @"nb_tracks" : [NSNumber numberWithInt:self.nb_tracks] };
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

+(NSArray *)toArray:(NSArray *)playlistModels_
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[playlistModels_ count]];
    for (id object in playlistModels_)
    {
        if (object && [object isKindOfClass:[AWPlaylistModel class]])
            [ret addObject:[((AWPlaylistModel*)object) toDictionary]];
    }
    return ret;
}

+(AWPlaylistModel *) fromJSON:(NSDictionary*)data
{
    AWPlaylistModel *playlistModel = [AWPlaylistModel new];
    
    if (data && [data isKindOfClass:[NSDictionary class]])
    {
        playlistModel._id = [NSString stringWithFormat:@"%d", [NSObject getVerifiedInteger:[data objectForKey:@"id"]]];
        if ([data objectForKey:@"id"] == nil)
            playlistModel._id = nil;
        playlistModel.title = [NSObject getVerifiedString:[data objectForKey:@"title"]];
        playlistModel.nb_tracks = [NSObject getVerifiedInteger:[data objectForKey:@"nb_tracks"]];
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
