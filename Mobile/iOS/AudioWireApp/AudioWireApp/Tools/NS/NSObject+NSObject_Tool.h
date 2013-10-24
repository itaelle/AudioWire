//
//  NSObject+NSObject_Tool.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/23/13.
//  Copyright (c) 2013 NetcoSports. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObject_Tool)

+ (int) getVerifiedInteger:(id)data;
+ (NSString *) getVerifiedString:(id)data;
+ (BOOL) getVerifiedBool:(id)data;
+ (NSDictionary *) getVerifiedDictionary:(id)data;
+ (NSArray *) getVerifiedArray:(id)data;

@end
