#import <MediaPlayer/MediaPlayer.h>
#import "AWMasterModel.h"

@interface AWTrackModel : AWMasterModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *album;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *genre;
@property (nonatomic, strong) NSNumber *numberTrack;
@property (nonatomic, strong) NSNumber *time;

//@property (nonatomic, strong) MPMediaItem *iTunesItem;

+(NSArray *)toArrayOfIds:(NSArray *)trackModels_;
+(AWTrackModel *) fromJSON:(NSDictionary*)data;
+(NSArray *)toArray:(NSArray *)trackModels_;

@end
