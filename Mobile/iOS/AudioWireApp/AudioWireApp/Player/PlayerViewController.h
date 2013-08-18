//
//  PlayerViewController.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#define DELAY_BEFORE_SLIDING_TITLE 3

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>
#import "MasterViewController.h"
#import "ANPopoverSlider.h"
#import "AppDelegate.h"

@interface PlayerViewController : MasterViewController<AVAudioPlayerDelegate, UIPickerViewDelegate>
{
    bool isPlaying;
    bool isFlipped;
    
   // MPMusicPlayerController *musicPlayer;
    AppDelegate *applicatioNDelegate;
}
// Properties
@property BOOL isSliderVolumeOpened;
@property (strong, nonatomic) NSTimer *timer;
//@property (strong, nonatomic) MPMusicPlayerController *musicPlayer;

//Sliders
@property (weak, nonatomic) IBOutlet ANPopoverSlider *sliderPlayingMedia;
@property (weak, nonatomic) IBOutlet ANPopoverSlider *sliderVolume;

// Label
@property (weak, nonatomic) IBOutlet UILabel *labelMinutesPlayed;
@property (weak, nonatomic) IBOutlet UILabel *labelTopPlaying;


// Buttons
@property (weak, nonatomic) IBOutlet UIButton *VolumeButton;
@property (weak, nonatomic) IBOutlet UIButton *shuffleButton;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

// Views
@property (weak, nonatomic) IBOutlet UIView *dynamicTopView;
@property (weak, nonatomic) IBOutlet UIView *viewSlider;
@property (weak, nonatomic) IBOutlet UIView *jacketView;
@property (weak, nonatomic) IBOutlet UIImageView *jacketImg;

// Event handlers
- (IBAction)clickSoundIcon:(id)sender;

- (IBAction)clickPlayerButton:(id)sender;
- (IBAction)clickNextButton:(id)sender;
- (IBAction)clickPreviousButton:(id)sender;

- (IBAction)clickRepeatButton:(id)sender;
- (IBAction)clickShuffleButton:(id)sender;

- (IBAction)dragMusicPlayingOffset:(id)sender;
- (IBAction)dragVolume:(id)sender;

-(IBAction) timerFinish:(id) sender;


@end
