//
//  AWUserManager.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/24/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWUserModel.h"

@interface AWUserManager : NSObject

@property (strong, nonatomic) NSString *connectedUserTokenAccess;
@property (strong, nonatomic) NSString *idUser;

+(AWUserManager*)getInstance;

-(BOOL)isLogin;

-(void)autologin:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)login:(AWUserModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)subscribe:(AWUserModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)updateUser:(AWUserModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)logOut:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)getAllUsers:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep;

-(void)getUserFromId:(NSString *)userId_ cb_rep:(void (^)(AWUserModel *data, BOOL success, NSString *error))cb_rep;

+(NSString *)pathOfileAutologin;

@end
