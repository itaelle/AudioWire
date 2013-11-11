//
//  AWTrackModel.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/27/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "AWMasterModel.h"

@interface AWTrackModel : AWMasterModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *genre;

@property (nonatomic, strong) MPMediaItem *iTunesItem;

+(NSArray *)toArrayOfIds:(NSArray *)trackModels_;
+(AWTrackModel *) fromJSON:(NSDictionary*)data;
+(NSArray *)toArray:(NSArray *)trackModels_;

@end
