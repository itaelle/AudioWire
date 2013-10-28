//
//  AWUserPostModel.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/24/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWUserPostModel.h"
#import "NSObject+NSObject_Tool.h"

@implementation AWUserPostModel

-(NSDictionary *)toDictionary
{
    return @{@"email" : self.email,
             @"password" : self.password,
             @"username" : self.username};
}

-(NSDictionary *)toDictionaryLogin
{
    return @{@"email" : self.email,
             @"password" : self.password};
}

+(AWUserPostModel *) fromJSON:(NSDictionary*)data
{
    AWUserPostModel *userModel = [AWUserPostModel new];
    
    if (data && [data isKindOfClass:[NSDictionary class]])
    {
        userModel.password = [NSObject getVerifiedString:[data objectForKey:@"password"]];
        userModel.username = [NSObject getVerifiedString:[data objectForKey:@"username"]];
        userModel.email = [NSObject getVerifiedString:[data objectForKey:@"email"]];
        userModel._id = [NSObject getVerifiedString:[data objectForKey:@"id"]];
    }
    return userModel;
}

+(NSArray *) fromJSONArray:(NSArray*)data
{
    NSArray *a = [NSObject getVerifiedArray:data];
    
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    for (id object in a)
    {
        [ret addObject:[AWUserPostModel fromJSON:object]];
    }
    return ret;
}

@end
