#import <Foundation/Foundation.h>
#import "AWPlaylistModel.h"

@interface AWPlaylistSynchronizer : NSObject

+(void)deletePlaylistInSyncFile:(NSArray*)playlistsToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

+(void)addPlaylistInSyncFile:(AWPlaylistModel *)playlist_ cb_rep:(void (^)(BOOL success,NSString *idPLaylistCreated,  NSString *error))cb_rep;

+(void)addTracksInPlaylistInSyncFile:(AWPlaylistModel *)playlist_ tracksToAdd:(NSArray*)tracksToAdd_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

+(void)deleteTracksInPlaylistInSyncFile:(AWPlaylistModel *)playlist_ tracksToDelete:(NSArray*)tracksToDelete_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

+(void)runPlaylistSync:(void (^)(BOOL success, NSString *error))cb_rep;

+(BOOL)isThereSomethingToSynchronize;

+(NSString *)pathOfFilePlaylistSync;

@end
