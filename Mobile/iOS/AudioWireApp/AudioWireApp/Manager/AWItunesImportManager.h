//
//  AWItunesImporManager.h
//  AudioWireApp
//
//  Created by Guilaume Derivery on 07/11/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AWItunesImportManager : NSObject

@property (strong, nonatomic) NSArray *itunesMedia;

+(AWItunesImportManager*)getInstance;

-(NSArray *)getAllItunesMedia;

-(NSArray *)getItunesMediaAndIgnoreAlreadyImportedOnes;

-(void)integrateMediaInAWLibrary:(NSArray *)itunesMedia cb_rep:(void(^)(bool success, NSString *error))cb_rep;

@end
