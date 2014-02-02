#import "AWMasterModel.h"

@interface AWPlaylistModel : AWMasterModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) int nb_tracks;

+(AWPlaylistModel *) fromJSON:(NSDictionary*)data;
+(NSArray *)toArrayOfIds:(NSArray *)playlistModels_;
+(NSArray *)toArray:(NSArray *)playlistModels_;

@end
