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

-(void)login:(AWUserPostModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *url = [AWConfManager getURL:AWLogin];
    
    [AWRequester requestAudiowireAPIPOST:url param:[user_ toDictionary] cb_rep:^(NSDictionary *rep, BOOL success)
    {
        if (success && rep)
        {
            BOOL successCreation = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];

            if (successCreation)
            {
                self.connectedUserTokenAccess = [NSObject getVerifiedString:[rep objectForKey:@"token"]];
                cb_rep(true, @"");
            }
            else
            {
                NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
                NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
                if ([message length] > 0)
                    cb_rep(FALSE, message);
                else if ([error length] > 0)
                    cb_rep(FALSE, message);
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

-(void)subscribe:(AWUserPostModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *url = [AWConfManager getURL:AWSubscribe];
    
    NSMutableDictionary *userDict = [NSMutableDictionary new];
    [userDict setObject:[user_ toDictionaryWithConfirmation] forKey:@"user"];
    
    [AWRequester requestAudiowireAPIPOST:url param:userDict cb_rep:^(NSDictionary *rep, BOOL success)
    {
        if (success && rep)
        {
            BOOL successCreation = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
            self.connectedUserTokenAccess = [NSObject getVerifiedString:[rep objectForKey:@"token"]];
            
            if (successCreation && [self.connectedUserTokenAccess length] > 0)
            {
                cb_rep(true, @"");
            }
            else
            {
                NSDictionary *errors = [NSObject getVerifiedDictionary:[rep objectForKey:@"errors"]];
                NSArray *email_errors = [NSObject getVerifiedArray:[errors objectForKey:@"email"]];
                NSArray *password_errors = [NSObject getVerifiedArray:[errors objectForKey:@"password"]];
                
                if ([email_errors count] > 0)
                {
                    NSString *emailFirstError = [NSObject getVerifiedString:[email_errors objectAtIndex:0]];
                    cb_rep(FALSE, [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"The email", @""), emailFirstError]);
                }
                else if ([password_errors count] > 0)
                {
                    NSString *passwordFirstError = [NSObject getVerifiedString:[password_errors objectAtIndex:0]];
                    cb_rep(FALSE, [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"The password", @""), passwordFirstError]);
                }
                else
                    cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
            }
        }
        else
        {
            cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
        }
    }];
}

-(void)updateUser:(AWUserPostModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *url = [AWConfManager getURL:AWUpdateUser];
    
    NSMutableDictionary *dict_updateUser = [NSMutableDictionary new];
    [dict_updateUser setObject:self.connectedUserTokenAccess forKey:@"token"];
    [dict_updateUser setObject:user_.password forKey:@"password"];
    
    [AWRequester requestAudiowireAPIPOST:url param:[user_ toDictionary] cb_rep:^(NSDictionary *rep, BOOL success)
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
    NSString *url = [AWConfManager getURL:AWLogout];

    NSMutableDictionary *dict_token = [NSMutableDictionary new];
    [dict_token setObject:self.connectedUserTokenAccess forKey:@"token"];
    
    [AWRequester requestAudiowireAPIDELETE:url param:dict_token cb_rep:^(NSDictionary *rep, BOOL success)
    {
        if (success && rep)
        {
            BOOL successLogout = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
            NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
            cb_rep(successLogout, message);
        }
        else
        {
            cb_rep(false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
        }
    }];
}

@end


