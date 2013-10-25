//
//  HomeViewController.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/2/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "SubPlayer.h"
#import "AWMasterViewController.h"

#define DEFINE_TIMES_TO_CLICK_LOGO 5

@interface HomeViewController : AWMasterViewController
{
    int clickLogoCount;
    BOOL firstTime;
}
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *btLogo;


@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIButton *optionButton;
@property (weak, nonatomic) IBOutlet UIButton *special_button;

@property (weak, nonatomic) IBOutlet UIView *playingView;
- (IBAction)clickBtLibrary:(id)sender;
- (IBAction)clickBtThird:(id)sender;
- (IBAction)clickBtContact:(id)sender;
- (IBAction)clickBtOption:(id)sender;
- (IBAction)clickLogoTop:(id)sender;
- (IBAction)clickSpecialButtonBack:(id)sender;

@end
