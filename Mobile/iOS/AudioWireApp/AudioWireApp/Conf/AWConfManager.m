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

        case AWGetUserConntected:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/users/me?token=%@"];
        } break;
            
        case AWGetUsers:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/users?token=%@"];
        } break;
            
        case AWLostPassword:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/users/reset-password-link"];
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
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/tracks?token=%@"];
        } break;

        case AWAddTracks:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/tracks?token=%@"];
        } break;

        case AWUpdateTrack:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/tracks/%@?token=%@"];
        } break;
            
        case AWDelTrack:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/tracks/%@?token=%@"];
        } break;
            
        case AWDelTracks:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/tracks/delete?token=%@"];
        } break;

            // PLAYLISTS
        case AWGetPlaylists:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/playlist?token=%@"];
        } break;
        case AWAddPlaylists:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/playlist?token=%@"];
        } break;
        case AWDelPlaylists:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/playlist/delete?token=%@"];
        } break;
        case AWUpdatePlaylists:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/playlist/%@?token=%@"];
        } break;
        case AWGetTracksInPlaylist:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/playlist/%@/tracks?token=%@"];
        } break;
        case AWAddTracksPlaylist:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/playlist/%@/tracks?token=%@"];
        } break;
        case AWDelTracksPlaylist:
        {
            return [NSString stringWithFormat:@"%@%@", URL_API, @"/api/playlist/%@/tracks?token=%@"];
        } break;
            
        default:
            break;
    }

    return @"";
}

@end
