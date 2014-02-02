#import "AWFriendManager.h"
#import "AWUserManager.h"
#import "AWConfManager.h"
#import "AWRequester.h"
#import "NSObject+NSObject_Tool.h"

@implementation AWFriendManager

+(void)getAllFriends:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;
    
    if (!token)
    {
        cb_rep(nil, false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWGetFriends], token];
    
    [AWRequester requestAudiowireAPIGET:url cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL success = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             NSArray *list = [NSObject getVerifiedArray:[rep objectForKey:@"friends"]];
             NSArray *models = [AWUserModel fromJSONArray:list];

             cb_rep(models, success, error);
         }
         else
             cb_rep(nil, false, NSLocalizedString(@"Something went wrong while attempting to retrieve data from the AudioWire - API", @""));
     }];
}

+(void)addFriend:(NSString *)userToAddinFrien_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;

    if (!token)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }

    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWAddFriend], token];

    NSMutableDictionary *userDict = [NSMutableDictionary new];
    [userDict setObject:userToAddinFrien_ forKey:@"friend_email"];
    
    [AWRequester requestAudiowireAPIPOST:url param:userDict cb_rep:^(NSDictionary *rep, BOOL success)
     {
         if (success && rep)
         {
             BOOL success = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
             if (success)
                 cb_rep(success, message);
             else
                 cb_rep(success, error);
         }
         else
         {
             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
         }
     }];
}

+(void)deleteFriend:(NSArray *)friendsToDel_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep
{
    NSString *token = [AWUserManager getInstance].connectedUserTokenAccess;

    if (!token)
    {
        cb_rep(false, NSLocalizedString(@"Something went wrong. You are trying to access data from the API but you are not actually logged in", @""));
        return ;
    }
    
    NSString *url = [NSString stringWithFormat:[AWConfManager getURL:AWDelFriend], token];
    
    NSMutableDictionary *userDict = [NSMutableDictionary new];
    [userDict setObject:[AWUserModel arrayOfEmail:friendsToDel_] forKey:@"friends_email"];

    [AWRequester requestAudiowireAPIPOST:url param:userDict cb_rep:^(NSDictionary *rep, BOOL success)
    {
        if (success && rep)
        {
            BOOL success = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
            NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
            NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
            if (success)
                cb_rep(success, message);
            else
                cb_rep(success, error);
        }
        else
        {
            cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
        }
    }];
    
//    [AWRequester requestAudiowireAPIPOST:url cb_rep:^(NSDictionary *rep, BOOL success)
//     {
//         if (success && rep)
//         {
//             BOOL success = [NSObject getVerifiedBool:[rep objectForKey:@"success"]];
//             NSString *message = [NSObject getVerifiedString:[rep objectForKey:@"message"]];
//             NSString *error = [NSObject getVerifiedString:[rep objectForKey:@"error"]];
//             if (success)
//                 cb_rep(success, message);
//             else
//                 cb_rep(success, error);
//         }
//         else
//         {
//             cb_rep(FALSE, NSLocalizedString(@"Something went wrong while attempting to send data to the AudioWire - API", @""));
//         }
//     }];
}
@end
