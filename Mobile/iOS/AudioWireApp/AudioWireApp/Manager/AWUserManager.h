//
//  AWUserManager.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/24/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWUserPostModel.h"

@interface AWUserManager : NSObject

@property (strong, nonatomic) NSString *connectedUserTokenAccess;

+(AWUserManager*)getInstance;

-(BOOL)isLogin;

-(void)autologin:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)login:(AWUserPostModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)subscribe:(AWUserPostModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)updateUser:(AWUserPostModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)logOut:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)getAllUsers:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep;

-(void)getUserFromId:(NSString *)userId_ cb_rep:(void (^)(AWUserPostModel *data, BOOL success, NSString *error))cb_rep;

+(NSString *)pathOfileAutologin;

@end
