#import "AWTrackModel.h"
#import "NSObject+NSObject_Tool.h"

@implementation AWTrackModel

-(NSDictionary *)toDictionary
{
    if (self._id)
        return @{@"id" : self._id,
                 @"title" : self.title,
                 @"album" : self.album,
                 @"artist" : self.artist,
                 @"genre" : self.genre,
                 @"numberTrack" : self.numberTrack,
                 @"time" : [NSNumber numberWithInteger:[self.time integerValue]]
                 };
    else
        return @{
                 @"title" : self.title,
                 @"album" : self.album,
                 @"artist" : self.artist,
                 @"genre" : self.genre,
                 @"numberTrack" : self.numberTrack,
                 @"time" : [NSNumber numberWithInteger:[self.time integerValue]]
                 };
}

+(NSArray *)toArray:(NSArray *)trackModels_
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[trackModels_ count]];
    for (id object in trackModels_)
    {
        if (object && [object isKindOfClass:[AWTrackModel class]])
            [ret addObject:[object toDictionary]];
    }
    return ret;
}

+(NSArray *)toArrayOfIds:(NSArray *)trackModels_
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[trackModels_ count]];
    for (id object in trackModels_)
    {
        if (object && [object isKindOfClass:[AWTrackModel class]])
            [ret addObject:((AWTrackModel*)object)._id];
    }
    return ret;
}

+(AWTrackModel *) fromJSON:(NSDictionary*)data
{
    AWTrackModel *userModel = [AWTrackModel new];
    
    if (data && [data isKindOfClass:[NSDictionary class]])
    {
        userModel._id = [NSString stringWithFormat:@"%d", [NSObject getVerifiedInteger:[data objectForKey:@"id"]]];
        userModel.title = [NSObject getVerifiedString:[data objectForKey:@"title"]];
        userModel.album = [NSObject getVerifiedString:[data objectForKey:@"album"]];
        userModel.artist = [NSObject getVerifiedString:[data objectForKey:@"artist"]];
        userModel.genre = [NSObject getVerifiedString:[data objectForKey:@"genre"]];
        userModel.time = [NSNumber numberWithInt:[NSObject getVerifiedInteger:[data objectForKey:@"time"]]];
        userModel.numberTrack = [NSNumber numberWithInt:[NSObject getVerifiedInteger:[data objectForKey:@"numberTrack"]]];
    }
    return userModel;
}

+(NSArray *) fromJSONArray:(NSArray*)data
{
    NSArray *a = [NSObject getVerifiedArray:data];
    
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    for (id object in a)
    {
        [ret addObject:[AWTrackModel fromJSON:object]];
    }
    return ret;
}

@end
