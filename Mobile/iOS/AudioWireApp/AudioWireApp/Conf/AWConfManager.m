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
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/users"];
        } break;
            
        case AWLogin:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/users/login"];
        } break;

        case AWLogout:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/users/logout?token=%@"];
        } break;
            
        case AWUpdateUser:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/users?token=%@"];
        } break;

        case AWGetUser:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/users/%@?token=%@"];
        } break;
            
        case AWGetUsers:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/users?token=%@"];
        } break;

            // FRIENDS
        case AWAddFriend:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/friends?token=%@"];
        } break;

        case AWDelFriend:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/friends/%@?token=%@"];
        } break;
        
        case AWGetFriends:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/friends?token=%@"];
        } break;
           
            // TRACKS
        case AWGetTracks:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/tracks/list?token=%@"];
        } break;

        case AWAddTrack: // To modify, we don't upload a music
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/tracks/upload?token=%@"];
        } break;

        case AWUpdateTrack:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/tracks/update?token=%@"];
        } break;
            
        case AWDelTrack:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/tracks/delete?token=%@"];
        } break;

            // PLAYLISTS
        case AWGetPlaylists:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/playlist/list?token=%@"];
        } break;
        case AWAddPlaylists:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/playlist/create?token=%@"];
        } break;
        case AWDelPlaylists:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/playlist/delete?token=%@"];
        } break;
        case AWUpdatePlaylists:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/playlist/update?token=%@"];
        } break;
        case AWAddTracksPlaylist:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/playlist/add-tracks?token=%@"];
        } break;
        case AWDelTracksPlaylist:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/playlist/delete-tracks?token=%@"];
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
