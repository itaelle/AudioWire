//
//  AWPlaylistModel.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/28/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWMasterModel.h"

@interface AWPlaylistModel : AWMasterModel

@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) int nb_tracks;

+(AWPlaylistModel *) fromJSON:(NSDictionary*)data;
+(NSArray *)toArrayOfIds:(NSArray *)playlistModels_;

@end
