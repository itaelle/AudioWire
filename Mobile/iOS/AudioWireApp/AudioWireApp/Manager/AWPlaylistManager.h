#import <Foundation/Foundation.h>
#import "AWPlaylistModel.h"

@interface AWPlaylistManager : NSObject

@property (nonatomic, strong) NSArray *itunesMedia;

+(AWPlaylistManager*)getInstance;

+(NSString *)pathOfilePlaylist;

+(void)getAllPlaylists:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep;

+(void)addPlaylist:(AWPlaylistModel *)playlist_ cb_rep:(void (^)(BOOL success, NSString *idPLaylistCreated, NSString *error))cb_rep;

+(void)deletePlaylists:(NSArray *)playlistsToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)deleteItunesTrack:(NSIndexPath *)indexPath cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

+(void)getTracksInPlaylist:(AWPlaylistModel *)playlist_ cb_rep:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep;

+(void)addTracksInPlaylist:(AWPlaylistModel *)playlist_ tracks:(NSArray *)tracks_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

+(void)delTracksInPlaylist:(AWPlaylistModel *)playlist_ tracks:(NSArray *)tracks_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

/*
 +(void)updatePlaylist:(AWPlaylistModel *)playlistToUpdate_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;
 */

@end
