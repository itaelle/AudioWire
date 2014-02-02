#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AWItunesImportManager : NSObject

@property (strong, nonatomic) NSArray *itunesMedia;

+(AWItunesImportManager*)getInstance;

-(NSArray *)getAllItunesMedia;

-(NSArray *)getItunesMediaAndIgnoreAlreadyImportedOnes;

-(void)integrateMediaInAWLibrary:(NSArray *)itunesMedia cb_rep:(void(^)(bool success, NSString *error))cb_rep;

@end
