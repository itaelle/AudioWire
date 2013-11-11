//
//  NSObject_Tool.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/23/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "NSObject+NSObject_Tool.h"

@implementation NSObject (NSObject_Tool)

+(int) getVerifiedInteger:(id)data
{
    if (data != nil && [data isKindOfClass:[NSNumber class]])
        return [data intValue];
    
    else
        return 0;
}

+(NSString *) getVerifiedString:(id)data
{
    if (data != nil && [data isKindOfClass:[NSString class]])
        return data;
    
    else
        return @"";
}

+(BOOL) getVerifiedBool:(id)data
{
    if (data != nil && [data isKindOfClass:[NSNumber class]] && [(NSNumber *)data boolValue] == YES)
        return YES;
    
    else
        return FALSE;
}

+(NSDictionary *) getVerifiedDictionary:(id)data
{
    if (data != nil && [data isKindOfClass:[NSDictionary class]])
        return data;
    
    else
        return @{};
}

+(NSArray *) getVerifiedArray:(id)data
{
    if (data != nil && [data isKindOfClass:[NSArray class]])
        return data;
    
    else
        return @[];
}


@end
