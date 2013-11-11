//
//  AWMusicPlayer.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/26/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWMusicPlayer.h"

@implementation AWMusicPlayer

+(AWMusicPlayer*)getInstance
{
    static AWMusicPlayer *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[AWMusicPlayer alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        player = [MPMusicPlayerController iPodMusicPlayer];
    }
    return self;
}

-(BOOL)start
{
    self.isEditingPlayingOffset = NO;
    [self registerNotifications];
    
    float volume = [player volume];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateVolumeValue:)])
    {
        [self.delegate performSelector:@selector(updateVolumeValue:) withObject:[NSNumber numberWithFloat:volume]];
    }
    
    if (self.playlist && [self.playlist count] > 0)
    {
        [self setPlaylistToPlay:self.playlist andStartAtIndex:0];
        return TRUE;
    }
    
    else if (self.track)
    {
        [self setMusicToPlay:self.track];
        return true;
    }
    else
        return false;
}

-(void)update
{
//    [self stopNotifications];
//    [self registerNotifications];
//    
//    float volume = [player volume];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(updateVolumeValue:)])
//    {
//        [self.delegate performSelector:@selector(updateVolumeValue:) withObject:[NSNumber numberWithFloat:volume]];
//    }
//    [self play];
}

-(void)end
{
    [self stopNotifications];
}

#pragma NotificationHandling
-(void)registerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
	[notificationCenter addObserver: self
						   selector: @selector (handle_NowPlayingItemChanged:)
							   name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
							 object: player];
	
	[notificationCenter addObserver: self
						   selector: @selector (handle_PlaybackStateChanged:)
							   name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
							 object: player];
    
    [notificationCenter addObserver: self
						   selector: @selector (handle_VolumeChanged:)
							   name: MPMusicPlayerControllerVolumeDidChangeNotification
							 object: player];
    
	[player beginGeneratingPlaybackNotifications];
}

-(void)stopNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) handle_NowPlayingItemChanged: (id) notification
{
   	MPMediaItem *currentItem = [player nowPlayingItem];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateMediaInfo:)])
    {
        [self.delegate performSelector:@selector(updateMediaInfo:) withObject:currentItem];
    }
}

- (void) handle_PlaybackStateChanged: (id) notification
{
    #warning Check if playBackStateChanged is necessary
    MPMusicPlaybackState playbackState = [player playbackState];
}

- (void) handle_VolumeChanged: (id) notification
{
    float volume = [player volume];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateVolumeValue:)])
    {
        [self.delegate performSelector:@selector(updateVolumeValue:) withObject:[NSNumber numberWithFloat:volume]];
    }
}

#pragma Controls
-(void) setVolume:(NSNumber *)value
{
    if (value && [value floatValue] <= 1.0 && [value floatValue] >= 0)
        player.volume = [value floatValue];
}

-(BOOL) setPlaylistToPlay:(NSArray *)musicsItunesMedia andStartAtIndex:(int)index
{
    if (musicsItunesMedia && [musicsItunesMedia count] > 0)
    {
        [player setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:musicsItunesMedia]];
        
        #warning GORE
        for (int i = 0; i < index; i++)
            [player skipToNextItem];
        [self play];
        return TRUE;
    }
    else
        return FALSE;
}

-(BOOL) setMusicToPlay:(MPMediaItem *)musicItunesMedia
{
    if (!musicItunesMedia)
        return FALSE;
    
    player.nowPlayingItem = musicItunesMedia;
    [self play];
    return TRUE;
}

-(void) play
{
    [player play];
    [self startTimer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(play:)])
    {
        [self.delegate performSelector:@selector(play:) withObject:self];
    }
}

-(void) pause
{
    [player pause];
    [self stopTimer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pause:)])
    {
        [self.delegate performSelector:@selector(pause:) withObject:self];
    }
}

-(void) stop
{
    [player stop];
    [self stopTimer];
    [self updateDisplay];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stop:)])
    {
        [self.delegate performSelector:@selector(stop:) withObject:self];
    }
}

-(void) prev
{
    [player skipToPreviousItem];
    [self play];
}

-(void) next
{
    [player skipToNextItem];
    [self play];
}

-(void)shuffle
{
    player.repeatMode = MPMusicRepeatModeNone;
    player.shuffleMode = MPMusicShuffleModeDefault;
}

-(void)repeat
{
    player.repeatMode = MPMusicRepeatModeAll;
    player.shuffleMode = MPMusicShuffleModeOff;
}

- (void)updateDisplay
{
    if (!player)
        return ;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateSliderValue:forMax:)])
    {
        [self.delegate performSelector:@selector(updateSliderValue:forMax:) withObject:[NSNumber numberWithFloat:player.currentPlaybackTime] withObject:[NSNumber numberWithFloat:[[player.nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue]]];
    }
}

-(BOOL) setNewTimeToPlay:(NSNumber *)newTimeOffset
{
    [self stopTimer];
    [player setCurrentPlaybackTime:[newTimeOffset floatValue]];
    [self updateDisplay];
    [self startTimer];
    return true;
}

-(void)startEditing
{
    self.isEditingPlayingOffset = YES;
}

-(void) endEditing
{
    self.isEditingPlayingOffset = NO;
}

-(BOOL)isPlaying
{
    if (player)
        return player.playbackState == MPMusicPlaybackStatePlaying;
    else
        return FALSE;
}

#pragma Timer
-(void)startTimer
{
    [self stopTimer];
    timer = [NSTimer
             scheduledTimerWithTimeInterval:0.5
             target:self selector:@selector(timerFired:)
             userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    [timer invalidate];
    timer = nil;
}

- (void)timerFired:(NSTimer*)timer
{
    [self updateDisplay];
}

-(void)dealloc
{
    [player endGeneratingPlaybackNotifications];
}

@end
