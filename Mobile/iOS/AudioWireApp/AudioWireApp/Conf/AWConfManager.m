//
//  AWConfManager.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/20/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWConfManager.h"

@implementation AWConfManager

+(NSString*)getURL:(AWConfigURL)value
{
    switch (value)
    {
        case AWSubscribe:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/users"];
        } break;
            
        case AWLogin:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/users/login"];
        } break;

        case AWLogout:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/users/logout"];
        } break;
            
        case AWUpdateUser:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/users"];
        } break;

        case AWGetUser:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/users/%@?token=%@"];
        } break;
            
        case AWGetUsers:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/users/?token=%@"];
        } break;

        case AWAddFriend:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/friends"];
        } break;

        case AWDelFriend:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/friends/%@"];
        } break;
        
        case AWGetFriends:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/friends?token=%@"];
        } break;
            
        case AWGetTracks:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/tracks?token=%@"];
        } break;

        case AWAddTrack: // To modify, we don't upload a music
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/tracks/upload?token=%@"];
        } break;

        case AWUpdateTrack:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/tracks?token=%@"];
        } break;
            
        case AWDelTrack:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/tracks?token=%@"];
        } break;

///////////////////////////////////////////////////////////////////////////////////////////////////

        case AWPlaylists:
        {
            
        } break;
            
        case AWAddPicture:
        {
            
        } break;
            
        case AWGetPicture:
        {
            
        } break;
            
        case AWDelPicture:
        {
            
        } break;
            
        case AWGetAllConversations:
        {
            
        } break;
            
        case AWGetAllMsgSent:
        {
            
        } break;
            
        case AWGetAllMsgReceived:
        {
            
        } break;
            
        case AWGet2UsersCp:
        {
            
        } break;
            
        case AWModifyMessage:
        {
            
        } break;

        case AWSendMsg:
        {
            
        } break;

        case AWDelMessage:
        {
            
        } break;

        case ASDelConv:
        {
            
        } break;
            
        default:
            break;
    }

    return @"";
}

@end
