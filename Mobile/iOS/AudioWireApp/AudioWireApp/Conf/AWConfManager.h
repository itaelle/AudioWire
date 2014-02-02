#import <Foundation/Foundation.h>

typedef enum
{
    AWLogin,
    AWLogout,
    AWSubscribe,
    AWUpdateUser,
    
    AWGetUserConntected,
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
    
    AWLostPassword
    
} AWConfigURL;


@interface AWConfManager : NSObject

+(NSString*)getURL:(AWConfigURL)value;

@end
