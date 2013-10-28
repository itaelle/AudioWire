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
            // USER
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
            // return [NSString stringWithFormat:@"%@%@", URL_API, @"/users"];
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/users?token=%@"];
        } break;

        case AWGetUser:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/users/%@?token=%@"];
        } break;
            
        case AWGetUsers:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/users?token=%@"];
        } break;

            // FRIENDS
        case AWAddFriend:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/friends?token=%@"];
        } break;

        case AWDelFriend:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/friends/%@?token=%@"];
        } break;
        
        case AWGetFriends:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/friends?token=%@"];
        } break;
           
            // TRACKS
        case AWGetTracks:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/tracks/list?token=%@"];
        } break;

        case AWAddTrack: // To modify, we don't upload a music
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/tracks/upload?token=%@"];
        } break;

        case AWUpdateTrack:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/tracks/update?token=%@"];
        } break;
            
        case AWDelTrack:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/tracks/delete?token=%@"];
        } break;

            // PLAYLISTS
        case AWGetPlaylists:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/playlist/list?token=%@"];
        } break;
        case AWAddPlaylists:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/playlist/create?token=%@"];
        } break;
        case AWDelPlaylists:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/playlist/delete?token=%@"];
        } break;
        case AWUpdatePlaylists:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/playlist/update?token=%@"];
        } break;
        case AWAddTracksPlaylist:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/playlist/add-tracks?token=%@"];
        } break;
        case AWDelTracksPlaylist:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/playlist/delete-tracks?token=%@"];
        } break;
            
///////////////////////////////////////////////////////////////////////////////////////////////////
            
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
