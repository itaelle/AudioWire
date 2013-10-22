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
        case AWLogin:
        {
            
        } break;

        case AWLogout:
        {
            
        } break;
            
        case AWSubscribe:
        {
            
        } break;

        case AWGetUser:
        {
            
        } break;
            
        case AWGetUsers:
        {
            
        } break;
            
        case AWGetFriends:
        {
            
        } break;

        case AWAddFriend:
        {
            
        } break;
            
        case AWDelFriend:
        {
            
        } break;

        case AWGetTracks:
        {
            
        } break;

        case AWUpdateTrack:
        {
            
        } break;
            
        case AWAddTrack:
        {
            
        } break;
            
        case AWDelTrack:
        {
            
        } break;

            
            /**********/

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
}

@end
