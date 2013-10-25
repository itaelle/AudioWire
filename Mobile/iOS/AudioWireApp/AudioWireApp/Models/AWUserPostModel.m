//
//  AWUserPostModel.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/24/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWUserPostModel.h"

@implementation AWUserPostModel

-(NSDictionary *)toDictionaryWithConfirmation
{
    return @{@"email" : self.email,
             @"password" : self.password,
             @"username" : self.username};
}

-(NSDictionary *)toDictionary
{
    return @{@"email" : self.email,
             @"password" : self.password};
}

@end
