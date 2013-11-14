//
//  AWMusicPlayer.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/26/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AWItunesImportManager.h"

@protocol AWMusicPlayerDelegate <NSObject>

@required
-(void)updateSliderValue:(NSNumber *)current_ forMax:(NSNumber *)max_;
-(void)updateVolumeValue:(NSNumber *)current_;
-(void)updateMediaInfo:(MPMediaItem *)item_;

@optional
-(void) play:(id)sender;
-(void) pause:(id)sender;
-(void) stop:(id)sender;
-(void) prev:(id)sender;
-(void) next:(id)sender;
@end

@interface AWMusicPlayer : NSObject<AVAudioPlayerDelegate>
{
    MPMusicPlayerController *player;
    NSTimer* timer;
    
    // Dans update le player ne play pas encore. Donc on met un flag pour checker si on a play avant.
    BOOL hasRequestAPlayAction;
    
    BOOL isUpdating;
}
// DATA PLAYING
@property (nonatomic, strong) NSArray *playlist;
@property (nonatomic, strong) MPMediaItem *track;

@property (weak, nonatomic) id<AWMusicPlayerDelegate> delegate;
@property (assign) BOOL isEditingPlayingOffset;

+(AWMusicPlayer*)getInstance;

// Player life cycle
-(BOOL) start;
-(BOOL) startAtIndex:(NSUInteger)index;
-(void) update;
-(void) end;

// Player volume and data set
-(void) setVolume:(NSNumber *)value;
-(BOOL) setNewTimeToPlay:(NSNumber *)newTimeOffset;
-(void) startEditing;
-(void) endEditing;
-(MPMediaItem *)nowPlaying;
-(BOOL) isPlaying;
-(BOOL) setPlaylistToPlay:(NSArray *)musicsItunesMedia andStartAtIndex:(int)index;
-(BOOL) setMusicToPlay:(MPMediaItem *)musicItunesMedia;

// Player standart controls
-(void) play;
-(void) pause;
-(void) stop;
-(void) prev;
-(void) next;
-(void) repeat;
-(void) shuffle;

@end
