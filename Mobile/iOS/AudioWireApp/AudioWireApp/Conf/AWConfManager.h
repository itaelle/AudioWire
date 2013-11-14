//
//  AWConfManager.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/20/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    AWLogin,
    AWLogout,
    AWSubscribe,
    AWUpdateUser,
    
    AWGetUser,
    AWGetUsers,
    
    AWGetTracks,
    AWUpdateTrack,
    AWAddTracks,
    AWDelTrack,
    AWDelTracks,
    
    AWGetPlaylists,
    AWAddPlaylists,
    AWDelPlaylists,
    AWUpdatePlaylists,
    AWGetTracksInPlaylist,
    AWAddTracksPlaylist,
    AWDelTracksPlaylist,
    
    AWGetFriends,
    AWAddFriend,
    AWDelFriend,
    
    /**********/
    
    AWAddPicture,
    AWGetPicture, // Pas de requête, just un lien
    AWDelPicture,
    
    AWGetAllConversations, // On a Friends => Conversation avec cet ami nan ?
    AWGetAllMsgSent,
    AWGetAllMsgReceived,
    
    AWGet2UsersCp, // Sert à rien.
    AWModifyMessage, // Sert à rien

    AWSendMsg,
    AWDelMessage,
    ASDelConv,

} AWConfigURL;


@interface AWConfManager : NSObject

+(NSString*)getURL:(AWConfigURL)value;

@end
