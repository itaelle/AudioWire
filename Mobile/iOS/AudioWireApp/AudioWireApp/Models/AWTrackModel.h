//
//  AWTrackModel.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/27/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWMasterModel.h"

@interface AWTrackModel : AWMasterModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *genre;

+(NSArray *)toArrayOfIds:(NSArray *)trackModels_;
+(NSArray *)toArray:(NSArray *)trackModels_;
+(AWTrackModel *) fromJSON:(NSDictionary*)data;

@end
