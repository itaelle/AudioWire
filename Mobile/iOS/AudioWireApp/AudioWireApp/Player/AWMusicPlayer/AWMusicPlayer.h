//
//  AWMusicPlayer.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/26/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol AWMusicPlayerDelegate <NSObject>

@required
-(void)initSliderValueWithMax:(NSNumber *)max_;
-(void)updateSliderValue:(NSNumber *)current_;

-(void) play:(id)sender;
-(void) pause:(id)sender;
-(void) stop:(id)sender;

@end

@interface AWMusicPlayer : NSObject<AVAudioPlayerDelegate>
{
    AVAudioPlayer *player;
    NSTimer* timer;
}

@property (weak, nonatomic) id<AWMusicPlayerDelegate> delegate;
@property (assign) BOOL isEditingPlayingOffset;

+(AWMusicPlayer*)getInstance;

-(void) setVolume:(NSNumber *)value;
-(BOOL) setNewTimeToPlay:(NSNumber *)newTimeOffset;
-(void) endEditing;
-(BOOL) setPlaylistToPlay:(NSArray *)musicsFileName;
-(BOOL) setMusicToPlay:(NSString *)musicFileName;
-(void) play;
-(void) pause;
-(void) stop;

@end
