//
//  AWUserManager.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/24/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWUserManager.h"
#import "AWRequester.h"
#import "AWConfManager.h"
#import "NSObject+NSObject_Tool.h"

@implementation AWUserManager

+(AWUserManager*)getInstance
{
    static AWUserManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[AWUserManager alloc] init];
    });
    return sharedMyManager;
}

-(BOOL)isLogin
{
    if (self.connectedUserTokenAccess && [self.connectedUserTokenAccess length] > 0)
        return true;
    else
       return false;
}

+(NSString *)pathOfileAutologin
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:FILE_AUTOLOGIN];
}

-(void)autologin:(void (^)(BOOL success, NSString *error))cb_rep
{
//    NSLog(@"AUTOLOGIN method");
    NSString *autologinFilePath = [AWUserManager pathOfileAutologin];
    if ([[NSFileManager defaultManager] fileExistsAtPath:autologinFilePath])
    {
        NSDictionary *ids = [[NSDictionary alloc] initWithContentsOfFile:autologinFilePath];
//         NSLog(@"AUTOLOGIN => file exists : %@", ids);
        AWUserModel *loginModel = [AWUserModel fromJSON:ids];
        [self login:loginModel cb_rep:cb_rep];
    }
    else
        cb_rep(false, nil);
}

-(void)login:(AWUserModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *url = [AWConfManager getURL:AWLogin];
    
    [AWRequester requestAudiowireAPIPOST:url param:[user_ toDictionaryLogin] cb_rep:^(NSDictionary *rep, BOOL success)
    {
        if (success && rep)
        {
            BOOL successCreation = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];

            if (successCreation)
            {
                NSLog(@"LOGIN => OK");
                self.connectedUserTokenAccess = [NSObject getVerifiedString:[rep objectForKey:@"token"]];
                
                [[user_ toDictionaryLogin] writeToFile:[AWUserManager pathOfileAutologin] atomically:YES];
                NSDictionary *ids = [[NSDictionary alloc] initWithContentsOfFile:[AWUserManager pathOfileAutologin]];
                NSLog(@"Wrote to file => %@", [ids description]);

                [[NSNotificationCenter defaultCenter] postNotificationName:@"loggedIn" object:nil];
                
                cb_rep(true, nil);
            }
            else
            {
                NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
                NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];

                if ([message length] > 0)
                    cb_rep(FALSE, message);
                else if ([error length] > 0)
                    cb_rep(FALSE, error);
                else
                    cb_rep(false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
            }
        }
        else
        {
            cb_rep(false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
        }
    }];
}

-(void)subscribe:(AWUserModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *url = [AWConfManager getURL:AWSubscribe];
    
    NSMutableDictionary *userDict = [NSMutableDictionary new];
    [userDict setObject:[user_ toDictionary] forKey:@"user"];
    
    [AWRequester requestAudiowireAPIPOST:url param:userDict cb_rep:^(NSDictionary *rep, BOOL success)
    {
        if (success && rep)
        {
            BOOL successCreation = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
            self.connectedUserTokenAccess = [NSObject getVerifiedString:[rep objectForKey:@"token"]];
            self.idUser = [NSObject getVerifiedString:[rep objectForKey:@"id"]];
            
            if (successCreation && [self.connectedUserTokenAccess length] > 0)
            {
                [[user_ toDictionaryLogin] writeToFile:[AWUserManager pathOfileAutologin] atomically:YES];
                NSDictionary *ids = [[NSDictionary alloc] initWithContentsOfFile:[AWUserManager pathOfileAutologin]];
                NSLog(@"Wrote to file => %@", [ids description]);
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loggedIn" object:nil];
                cb_rep(true, nil);
            }
            else
            {
                NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
                NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
                
                if ([message length] > 0)
                    cb_rep(FALSE, message);
                else if ([error length] > 0)
                    cb_rep(FALSE, error);
                else
                    cb_rep(false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
            }
        }
        else
        {
            cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
        }
    }];
}

-(void)updateUser:(AWUserModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    if (!self.connectedUserTokenAccess)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to log out but you are not actually logged in", @""));
        return ;
    }

    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWUpdateUser], self.connectedUserTokenAccess];
    
//    NSMutableDictionary *dict_updateUser = [NSMutableDictionary new];
//    [dict_updateUser setObject:self.connectedUserTokenAccess forKey:@"token"];
//    [dict_updateUser setObject:user_.password forKey:@"password"];
    
    [AWRequester requestAudiowireAPIPUT:url param:[user_ toDictionary] cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL successUpdate = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];

             cb_rep(successUpdate, message);
         }
         else
         {
             cb_rep(false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
         }
     }];
}

-(void)logOut:(void (^)(BOOL success, NSString *error))cb_rep
{
    if (!self.connectedUserTokenAccess)
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to log out but you are not actually logged in", @""));
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWLogout], self.connectedUserTokenAccess];
    
    [AWRequester requestAudiowireAPIDELETE:url cb_rep:^(NSDictionary *rep, BOOL success)
    {
        if (success && rep)
        {
            BOOL successLogout = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
            NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
            
            if (successLogout)
            {
                [[NSFileManager defaultManager] removeItemAtPath:[AWUserManager pathOfileAutologin] error:nil];
                self.idUser = nil;
                self.connectedUserTokenAccess = nil;
            }
            cb_rep(successLogout, message);
        }
        else
            cb_rep(false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
    }];
}

-(void)getAllUsers:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep
{
    if (!self.connectedUserTokenAccess)
    {
        cb_rep(nil, false, NSLocalizedString(@"Something went wrong. You are trying to get data from the API but you are not actually logged in", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWGetUsers], self.connectedUserTokenAccess];

    [AWRequester requestAudiowireAPIGET:url cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL success = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             NSArray *list = [NSObject getVerifiedArray:[rep objectForKey:@"list"]];
             
             NSArray *models = [AWUserModel fromJSONArray:list];
             
             cb_rep(models, success, error);
         }
         else
             cb_rep(nil, false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
     }];
}

-(void)getUserFromId:(NSString *)userId_ cb_rep:(void (^)(AWUserModel *data, BOOL success, NSString *error))cb_rep
{
    if (!self.connectedUserTokenAccess)
    {
        cb_rep(nil, false, NSLocalizedString(@"Something went wrong. You are trying to get data from the API but you are not actually logged in", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWGetUser], userId_, self.connectedUserTokenAccess];
    
    [AWRequester requestAudiowireAPIGET:url cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL success = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             NSDictionary *userDict = [NSObject getVerifiedDictionary:[rep objectForKey:@"user"]];
             cb_rep([AWUserModel fromJSON:userDict], success, error);
         }
         else
             cb_rep(nil, false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
     }];
}

@end


