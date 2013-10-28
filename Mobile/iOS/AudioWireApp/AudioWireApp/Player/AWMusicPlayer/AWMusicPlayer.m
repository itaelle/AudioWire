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
        // TODO PLAYER INSTANTIATION
        self.isEditingPlayingOffset = NO;
    }
    return self;
}

-(void) setVolume:(NSNumber *)value
{
    if (value && [value floatValue] <= 1.0 && [value floatValue] >=0)
        player.volume = [value floatValue];
}

-(BOOL) setPlaylistToPlay:(NSArray *)musicsFileName
{
    return FALSE;
}

-(BOOL) setMusicToPlay:(NSString *)musicFileName
{
    // TEST
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"TheWho_WeWontGetFooledAgain" withExtension:@"mp3"];
    NSError* error = nil;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    ///////
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(initSliderValueWithMax:)])
    {
        float duration = player.duration;
        [self.delegate performSelector:@selector(initSliderValueWithMax:) withObject:[NSNumber numberWithFloat:duration]];
    }
    return TRUE;
}

-(void) play
{
    [player play];
    
    timer = [NSTimer
                  scheduledTimerWithTimeInterval:0.1
                  target:self selector:@selector(timerFired:)
                  userInfo:nil repeats:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(play:)])
    {
        [self.delegate performSelector:@selector(play:) withObject:self];
    }
}

-(void) pause
{
    [player pause];
    [self stopTimer];
    [self updateDisplay];
    
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

- (void)updateDisplay
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateSliderValue:)])
    {
        [self.delegate performSelector:@selector(updateSliderValue:) withObject:[NSNumber numberWithFloat:player.currentTime]];
    }
}


-(BOOL) setNewTimeToPlay:(NSNumber *)newTimeOffset
{
    self.isEditingPlayingOffset = YES;

    // TODO SET TIME
    //[self updateDisplay];
    
    return true;
}

-(void) endEditing
{
    self.isEditingPlayingOffset = NO;
}

#pragma Timer

- (void)stopTimer
{
    [timer invalidate];
    timer = nil;
}

- (void)timerFired:(NSTimer*)timer
{
    [self updateDisplay];
}


@end
