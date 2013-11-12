//
//  SubPlayer.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWMusicPlayer.h"
#import "ANPopoverSlider.h"

@protocol SubPlayerDelegate <NSObject>

@optional
-(void) didSelectPlayer:(id)sender;
-(void) play:(id)sender;
-(void) pause:(id)sender;
-(void) prev:(id)sender;
-(void) next:(id)sender;

@end


@interface SubPlayer : UIView<AWMusicPlayerDelegate>
{
    __weak AWMusicPlayer *musicPlayer;
    
    bool isSoundOpen;
    bool isPlaying;
}
@property (weak, nonatomic) id<SubPlayerDelegate> delegate;

@property (strong, nonatomic) NSTimer *timer;
@property BOOL isSliderVolumeOpened;

@property (weak, nonatomic) IBOutlet UIButton *soundButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;

@property (weak, nonatomic) IBOutlet UIView *viewSlider;
@property (weak, nonatomic) IBOutlet UIView *vw_labels;
@property (weak, nonatomic) IBOutlet UILabel *lbMusicPlaying;
@property (weak, nonatomic) IBOutlet UILabel *lbMusicTime;
@property (weak, nonatomic) IBOutlet ANPopoverSlider *sliderVolume;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlayer;

-(void) myInit;
-(void) updatePlayerStatus;
-(void) endPlayerHandling;

@end
