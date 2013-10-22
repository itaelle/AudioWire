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
    
    AWGetUser,
    AWGetUsers,
    
    AWGetFriends,
    AWAddFriend,
    AWDelFriend,
    
    AWGetTracks,  // Playlist ou pas ?  Possibilité d'ajout de plusieurs dans une requête ? (métadata)
    AWUpdateTrack,
    AWAddTrack,
    AWDelTrack,
    
    /**********/
    
    AWPlaylists,

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
