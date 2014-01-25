//
//  AWUserModel.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/24/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWMasterModel.h"

@interface AWUserModel : AWMasterModel

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *friend_id;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;

-(NSDictionary *)toDictionaryLogin;
+(AWUserModel *)fromJSON:(NSDictionary *)data;
+(NSArray *)arrayOfEmail:(NSArray *)friendsModels;

@end
