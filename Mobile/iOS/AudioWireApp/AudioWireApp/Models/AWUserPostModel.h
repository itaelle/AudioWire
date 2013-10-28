//
//  AWUserPostModel.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/24/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWMasterModel.h"

@interface AWUserPostModel : AWMasterModel

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *username;

-(NSDictionary *)toDictionaryLogin;
+(AWUserPostModel *) fromJSON:(NSDictionary*)data;

@end
