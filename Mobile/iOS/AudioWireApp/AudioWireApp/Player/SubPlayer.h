//
//  SubPlayer.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPopoverSlider.h"

@protocol SubPlayerDelegate <NSObject>

@optional
-(void) didSelectPlayer;
-(void) play;
-(void) pause;
-(void) prev;
-(void) next;

@end


@interface SubPlayer : UIView
{
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
@property (weak, nonatomic) IBOutlet UILabel *lbMusicPlaying;
@property (weak, nonatomic) IBOutlet UILabel *lbMusicTime;
@property (weak, nonatomic) IBOutlet ANPopoverSlider *sliderVolume;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlayer;

-(void) myInit;
- (IBAction)clickTitleGoToPlayer:(id)sender;

@end
