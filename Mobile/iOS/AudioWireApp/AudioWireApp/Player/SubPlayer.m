#import <QuartzCore/QuartzCore.h>
#import "ANPopOverSlider.h"
#import "PlayerViewController.h"
#import "SubPlayer.h"

@implementation SubPlayer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(void)dealloc
{
    [self stopTimer];
}

-(void) myInit
{
    isPlaying = false;
    isSoundOpen = false;
    
    [self setUpPlayer];
    [self setUpViews];
}

-(void)stopTrackInItsPlaying:(AWTrackModel *)track
{
    MPMediaItem *playing = [musicPlayer nowPlaying];
    
    if ([[playing valueForProperty:MPMediaItemPropertyTitle] isEqualToString:track.title] &&
        [[playing valueForProperty:MPMediaItemPropertyAlbumTitle] isEqualToString:track.album] &&
        [[playing valueForProperty:MPMediaItemPropertyArtist] isEqualToString:track.artist] &&
        [playing valueForProperty:MPMediaItemPropertyPlaybackDuration] == track.time)
    {
        NSLog(@"This is track is playing, so STOP");
        [musicPlayer stop];
    }
}

-(void)endPlayerHandling
{
    [musicPlayer end];
    [self stopTimer];
}

-(void)updatePlayerStatus
{
    [self setUpPlayer];
    [musicPlayer update];
    
    CGRect label = _lbMusicPlaying.frame;
    label.origin.x = 0;
    label.size = [_lbMusicPlaying.text sizeWithFont:FONTSIZE(17)];
    [_lbMusicPlaying setFrame:label];
    
    [self startTimer];
}

-(void)setUpPlayer
{
    if (musicPlayer)
    {
        musicPlayer.delegate = nil;
        musicPlayer = nil;
    }
    
    musicPlayer = [AWMusicPlayer getInstance];
    musicPlayer.delegate = self;
}

- (void) setUpViews
{
    // Font
    [_lbMusicPlaying setFont:FONTSIZE(17)];
    [_lbMusicTime setFont:FONTSIZE(17)];
    
    // Buttons
    [_playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    //    [_playButton setBackgroundImage:[UIImage imageNamed:@"play_pressed.png"] forState:UIControlStateHighlighted];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"pause_pressed.png"] forState:UIControlStateSelected];
    
    // Slider Volume Placement
    _sliderVolume.popupView.hidden = true;
    CGRect sliderPos = _viewSlider.frame;
    sliderPos.origin.x = _viewSlider.frame.origin.x + _viewSlider.frame.size.width;
    [_viewSlider setFrame:sliderPos];
    _viewSlider.layer.borderWidth = 1;
    _viewSlider.layer.borderColor = [[UIColor blackColor] CGColor];
    _viewSlider.layer.cornerRadius = 10;
    [_viewSlider setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];

    if (!IS_OS_7_OR_LATER)
    {
        CGRect rectSlider = self.sliderVolume.frame;
        rectSlider.origin.y += 3;
        [self.sliderVolume setFrame:rectSlider];
    }
    
    CGRect label = _lbMusicPlaying.frame;
    label.origin.x = 0;
    label.size = [_lbMusicPlaying.text sizeWithFont:FONTSIZE(17)];
    [_lbMusicPlaying setFrame:label];
}

-(void)startTimer
{
    [self stopTimer];
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:DELAY_BEFORE_SLIDING_TITLE] interval:0.1 target:self selector:@selector(timerFinish:) userInfo:nil repeats:true];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

-(void)stopTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

-(IBAction) timerFinish:(id) sender
{
    CGRect labelTopFrame = _lbMusicPlaying.frame;
    if (labelTopFrame.origin.x + labelTopFrame.size.width > 0)
        labelTopFrame.origin.x -= 4;
    else
        labelTopFrame.origin.x = _soundButton.frame.origin.x;
    
    if (labelTopFrame.origin.x == _soundButton.frame.origin.x)
        [_lbMusicPlaying setFrame:labelTopFrame];
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            [_lbMusicPlaying setFrame:labelTopFrame];
        }];
    }
}

- (IBAction)clickVolumeIcon:(id)sender
{
    if (_isSliderVolumeOpened == false)
    {
        CGRect sliderOpened = _viewSlider.frame;
        sliderOpened.origin.x = 10;
        _isSliderVolumeOpened = true;
        
        [UIView animateWithDuration:(0.1) animations:^{
                [_vw_labels setAlpha:0];
//            [_playButton setAlpha:0];
//            [_prevButton setAlpha:0];
//            [_nextButton setAlpha:0];
        } completion:^(BOOL finished)
        {
            if (finished)
            {
                [UIView animateWithDuration:(0.5) animations:^{
                    [_viewSlider setFrame:sliderOpened];
                }];
            }
        }];
    }
    else
    {
        CGRect sliderPos = _viewSlider.frame;
        sliderPos.origin.x = _viewSlider.frame.origin.x + _viewSlider.frame.size.width;
        
        
        [UIView animateWithDuration:(0.5) animations:^{
            [_viewSlider setFrame:sliderPos];
        } completion:^(BOOL finished) {
            if (finished)
            {
                [UIView animateWithDuration:(0.2) animations:^{
                    [_vw_labels setAlpha:1];
//                    [_playButton setAlpha:1];
//                    [_prevButton setAlpha:1];
//                    [_nextButton setAlpha:1];
                }];
                _isSliderVolumeOpened = false;
            }
        }];
        
    }
}

- (IBAction)clickTitleGoToPlayer:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectPlayer:)])
    {
        [_delegate performSelector:@selector(didSelectPlayer:) withObject:self];
    }
    if ([_delegate isKindOfClass:[UIViewController class]])
    {
        PlayerViewController *player = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
        [((UIViewController *)_delegate).navigationController pushViewController:player animated:true];
    }
}

- (IBAction)clickPlay:(id)sender
{
    if (isPlaying == true)
    {
        [musicPlayer pause];
//        [_playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
        if (_delegate && [_delegate respondsToSelector:@selector(play:)])
            [_delegate performSelector:@selector(play:) withObject:self];
    }
    else
    {
        [musicPlayer play];
//        [_playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        
        if (_delegate && [_delegate respondsToSelector:@selector(pause:)])
            [_delegate performSelector:@selector(pause:) withObject:self];
    }
}

- (IBAction)clicKNext:(id)sender
{
    [musicPlayer next];
    if (_delegate && [_delegate respondsToSelector:@selector(next:)])
        [_delegate performSelector:@selector(next:) withObject:self];
}

- (IBAction)clickPrev:(id)sender
{
    [musicPlayer prev];
    if (_delegate && [_delegate respondsToSelector:@selector(prev:)])
        [_delegate performSelector:@selector(prev:) withObject:self];
}

- (IBAction)editSliderVolume:(id)sender
{
    if (sender && [sender isKindOfClass:[ANPopoverSlider class]])
    {
        ANPopoverSlider *temp = sender;
        float value = temp.value;
        [musicPlayer setVolume:[NSNumber numberWithFloat:(value/100)]];
    }
}

#pragma AWMusicPlayerDelegate
-(void)updateSliderValue:(NSNumber *)current_ forMax:(NSNumber *)max_
{
    //NSLog(@"updateSliderValue delegate Sub");
//    self.sliderPlayingMedia.maximumValue = [max_ floatValue];
//    
//    if (musicPlayer.isEditingPlayingOffset == NO)
//        self.sliderPlayingMedia.value = [current_ floatValue];
    
    int diff = [current_ intValue];
    int forHours = diff / 3600;
    int remainder = diff % 3600;
    int forMinutes = remainder / 60;
    int forSeconds = remainder % 60;
    
    if (forHours == 0)
    {
//        if (musicPlayer.isEditingPlayingOffset == NO)
//            self.sliderPlayingMedia.valueString = [NSString stringWithFormat:@"%02d:%02d", forMinutes, forSeconds];
        self.lbMusicTime.text = [NSString stringWithFormat:@"%02d:%02d", forMinutes, forSeconds];
    }
    else
    {
//        if (musicPlayer.isEditingPlayingOffset == NO)
//            self.sliderPlayingMedia.valueString = [NSString stringWithFormat:@"%d:%02d:%02d", forHours, forMinutes, forSeconds];
        
        self.lbMusicTime.text = [NSString stringWithFormat:@"%d:%02d:%02d", forHours, forMinutes, forSeconds];
    }
}

-(void)updateVolumeValue:(NSNumber *)current_
{
    [_sliderVolume setValue:([current_ floatValue]*100) animated:TRUE];
}

-(void)updateMediaInfo:(MPMediaItem *)item_
{
//    NSLog(@"updateMediaInfo delegate Sub");
    NSString *artist = [item_ valueForProperty:MPMediaItemPropertyArtist];
    NSString *albumArtist = [item_ valueForProperty:MPMediaItemPropertyAlbumArtist];
    NSString *title = [item_ valueForProperty:MPMediaItemPropertyTitle];
    NSString *albumTitle = [item_ valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    if (artist && title && albumTitle)
        [_lbMusicPlaying setText:[NSString stringWithFormat:@"%@ - %@ [%@]",
                                   title, artist, albumTitle]];
    else if (artist && title)
        [_lbMusicPlaying setText:[NSString stringWithFormat:@"%@ - %@",
                                   title, artist]];
    else if (albumArtist && title)
        [_lbMusicPlaying setText:[NSString stringWithFormat:@"%@ - %@",
                                   title, albumArtist]];
    else if (title)
        [_lbMusicPlaying setText:[NSString stringWithFormat:@"%@",
                                   title]];
    else
        [_lbMusicPlaying setText:@""];
    
    [self stopTimer];
    CGRect label = _lbMusicPlaying.frame;
    label.origin.x = 0;
    label.size = [_lbMusicPlaying.text sizeWithFont:FONTSIZE(17)];
    [_lbMusicPlaying setFrame:label];
    [self startTimer];
}

-(void) play:(id)sender
{
//    NSLog(@"Play delegate Sub");
    isPlaying = YES;
    [_playButton setSelected:YES];
//    [_playButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
//    [_playButton setBackgroundImage:[UIImage imageNamed:@"pause_pressed.png"] forState:UIControlStateHighlighted];
}

-(void) pause:(id)sender
{
//    NSLog(@"Pause delegate Sub");
    isPlaying = NO;
    [_playButton setSelected:NO];
//    [_playButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
//    [_playButton setBackgroundImage:[UIImage imageNamed:@"play_pressed.png"] forState:UIControlStateHighlighted];
}

-(void) stop:(id)sender
{
//    NSLog(@"Stop delegate Sub");
    isPlaying = NO;
}

@end
