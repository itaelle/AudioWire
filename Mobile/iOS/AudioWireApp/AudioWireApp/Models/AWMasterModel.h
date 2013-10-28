//
//  AWMasterModel.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/24/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWMasterModel : NSObject

-(NSDictionary *)toDictionary;
+(AWMasterModel *) fromJSON:(NSDictionary*)data;
+(NSArray *) fromJSONArray:(NSArray*)data;

@end
