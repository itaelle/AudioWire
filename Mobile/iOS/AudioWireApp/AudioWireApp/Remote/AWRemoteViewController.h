//
//  AWRemoteViewController.h
//  AudioWireApp
//
//  Created by Guilaume Derivery on 08/12/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWMasterViewController.h"

@interface AWRemoteViewController : AWMasterViewController
{
    BOOL isPlaying;
}
@property BOOL isSliderVolumeOpened;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *viewSlider;

@property (weak, nonatomic) IBOutlet UILabel *lb_titleMusic;
@property (weak, nonatomic) IBOutlet ANPopoverSlider *slider_volume;
@property (weak, nonatomic) IBOutlet ANPopoverSlider *slider_musicOffset;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act_loader;

@property (weak, nonatomic) IBOutlet UIImageView *img_logo;
@property (weak, nonatomic) IBOutlet UIImageView *img_audiowire;

@property (weak, nonatomic) IBOutlet UIButton *bt_playPause;
@property (weak, nonatomic) IBOutlet UIButton *bt_prev;
@property (weak, nonatomic) IBOutlet UIButton *bt_next;
@property (weak, nonatomic) IBOutlet UIButton *bt_repeat;
@property (weak, nonatomic) IBOutlet UIButton *bt_shuffle;

- (IBAction)click_playPause:(id)sender;
- (IBAction)click_prev:(id)sender;
- (IBAction)click_next:(id)sender;
- (IBAction)clicK_repeat:(id)sender;
- (IBAction)click_shuffle:(id)sender;

- (IBAction)modifyVolume:(id)sender;
- (IBAction)modifyMusicOffset:(id)sender;

@end
