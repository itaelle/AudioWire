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
        hasRequestAPlayAction = NO;
        isUpdating = NO;
    }
    return self;
}

-(BOOL)start
{
    return [self startAtIndex:0];
}

-(BOOL)startAtIndex:(NSUInteger)index
{
 //   NSLog(@"MusicPlayer => start");
    self.isEditingPlayingOffset = NO;
    [self stopNotifications];
    [self registerNotifications];
    
    float volume = [player volume];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateVolumeValue:)])
    {
        [self.delegate performSelector:@selector(updateVolumeValue:) withObject:[NSNumber numberWithFloat:volume]];
    }
    
    if (self.playlist && [self.playlist count] > 0 && [self.playlist count] > index)
    {
        [self setPlaylistToPlay:self.playlist andStartAtIndex:index];
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
//    NSLog(@"MusicPlayer => updates");
    self.isEditingPlayingOffset = NO;

    [self stopNotifications];
    [self registerNotifications];
    
    float volume = [player volume];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateVolumeValue:)])
    {
        [self.delegate performSelector:@selector(updateVolumeValue:) withObject:[NSNumber numberWithFloat:volume]];
    }
    
    if (player.playbackState == MPMusicPlaybackStatePlaying || hasRequestAPlayAction)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(play:)])
        {
            [self.delegate performSelector:@selector(play:) withObject:self];
        }
    }
    else if (player.playbackState == MPMusicPlaybackStatePaused && !hasRequestAPlayAction)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pause:)])
        {
            [self.delegate performSelector:@selector(pause:) withObject:self];
        }
    }
    else
    {
        NSLog(@"PLAYBACKSTATE => %d", player.playbackState);
    }
    
    [self updateMediaInfo];
    [self updatePlayerVolume];
    [self updateDisplayTime];
    [self startTimer];
}

-(void)end
{
//    NSLog(@"MusicPlayer => end");
    self.isEditingPlayingOffset = NO;
    [self stopTimer];
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
   // [self updateMediaInfo];
}

- (void) handle_PlaybackStateChanged: (id) notification
{
//    MPMusicPlaybackState playbackState = [player playbackState];
}

- (void) handle_VolumeChanged: (id) notification
{
    [self updatePlayerVolume];
}

#pragma Controls
-(void) setVolume:(NSNumber *)value
{
    if (value && [value floatValue] <= 1.0 && [value floatValue] >= 0)
        player.volume = [value floatValue];
}

-(BOOL) setPlaylistToPlay:(NSArray *)musicsItunesMedia andStartAtIndex:(int)index
{
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>> Found from Itunes");
    for (int index = 0; index < [musicsItunesMedia count]; index++)
    {
        NSLog(@"%@", [[musicsItunesMedia objectAtIndex:index] valueForProperty:MPMediaItemPropertyTitle]);
    }
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>> Found from Itunes");
    
    if (musicsItunesMedia && [musicsItunesMedia count] > 0)
    {
        [player setQueueWithItemCollection:[MPMediaItemCollection collectionWithItems:musicsItunesMedia]];

        player.repeatMode = MPMusicRepeatModeAll;
        player.shuffleMode = MPMusicShuffleModeOff;

        player.nowPlayingItem = [musicsItunesMedia objectAtIndex:index];
        
//        #warning GORE
//        for (int i = 0; i < index; i++)
//        {
//            [player skipToNextItem];
//            MPMediaItem *now = player.nowPlayingItem;
//            NSLog(@"Skip => %@", [now valueForProperty:MPMediaItemPropertyTitle]);
//        }

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
    
    // TEST
    //player.nowPlayingItem = musicItunesMedia;
    [self setPlaylistToPlay:@[musicItunesMedia] andStartAtIndex:0];
    //
    
    [self play];
    return TRUE;
}

-(MPMediaItem *)nowPlaying
{
    return player.nowPlayingItem;
}

-(void) play
{
    NSLog(@"PLAY PLAYER");
    hasRequestAPlayAction = YES;
    [player play];
    [self updateDisplayTime];
    [self startTimer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(play:)])
    {
        [self.delegate performSelector:@selector(play:) withObject:self];
    }
}

-(void) pause
{
    NSLog(@"PAUSE PLAYER");
    hasRequestAPlayAction = NO;
    [player pause];
    [self stopTimer];
    [self updateDisplayTime];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pause:)])
    {
        [self.delegate performSelector:@selector(pause:) withObject:self];
    }
}

-(void) stop
{
    hasRequestAPlayAction = NO;
    [player stop];
    [self stopTimer];
    [self updateDisplayTime];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(stop:)])
    {
        [self.delegate performSelector:@selector(stop:) withObject:self];
    }
}

-(void) prev
{
    hasRequestAPlayAction = NO;
    [player skipToPreviousItem];
    [self updateMediaInfo];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(prev:)])
    {
        [self.delegate performSelector:@selector(prev:) withObject:self];
    }
    [self play];
}

-(void) next
{
    hasRequestAPlayAction = NO;
    [player skipToNextItem];
    [self updateMediaInfo];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(next:)])
        [self.delegate performSelector:@selector(next:) withObject:self];

    [self play];
}

-(void)shuffle
{
    if (player.shuffleMode == MPMusicShuffleModeSongs)
        player.shuffleMode = MPMusicShuffleModeOff;
    else
        player.shuffleMode = MPMusicShuffleModeSongs;
}

-(void)repeat
{
    if (player.repeatMode == MPMusicRepeatModeNone || player.repeatMode == MPMusicRepeatModeAll)
        player.repeatMode = MPMusicRepeatModeOne;
    
    if (player.repeatMode == MPMusicRepeatModeOne)
        player.repeatMode = MPMusicRepeatModeAll;
}

- (void)updateDisplayTime
{
    if (!player)
        return ;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateSliderValue:forMax:)])
    {
        [self.delegate performSelector:@selector(updateSliderValue:forMax:) withObject:[NSNumber numberWithFloat:player.currentPlaybackTime] withObject:[NSNumber numberWithFloat:[[player.nowPlayingItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue]]];
    }
}

-(void)updateMediaInfo
{
   	MPMediaItem *currentItem = [player nowPlayingItem];
//    NSLog(@"Now playing => %@", [currentItem valueForProperty:MPMediaItemPropertyTitle]);
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateMediaInfo:)])
    {
        [self.delegate performSelector:@selector(updateMediaInfo:) withObject:currentItem];
    }
}

-(void)updatePlayerVolume
{
    float volume = [player volume];
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateVolumeValue:)])
    {
        [self.delegate performSelector:@selector(updateVolumeValue:) withObject:[NSNumber numberWithFloat:volume]];
    }
}

-(BOOL) setNewTimeToPlay:(NSNumber *)newTimeOffset
{
    // [self stopTimer]; => test pour décalage
    [player setCurrentPlaybackTime:[newTimeOffset floatValue]];
    [self updateDisplayTime];
    // [self startTimer]; => test
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
    [self updateDisplayTime];
}

-(void)dealloc
{
    [self stopTimer];
    [player endGeneratingPlaybackNotifications];
}

@end
