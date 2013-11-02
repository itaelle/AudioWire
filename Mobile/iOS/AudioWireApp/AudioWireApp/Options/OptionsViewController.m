//
//  OptionsViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/5/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OptionsViewController.h"

@implementation OptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Options", @"Options");
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!IS_OS_7_OR_LATER)
    {
        CGRect rectTopView = self.topView.frame;
        rectTopView.origin.y = 31;
        rectTopView.size.height += 31;
        
        [self.topView setFrame:rectTopView];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpOptionViews];
}

-(void)setUpOptionViews
{
    [_topView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    [_bottomView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    
    _topView.layer.cornerRadius = 10;
    _bottomView.layer.cornerRadius = 10;
    
    _topView.layer.borderColor = [[UIColor blackColor]CGColor];
    _bottomView.layer.borderColor = [[UIColor blackColor]CGColor];
    
    _topView.layer.borderWidth = 1;
    _bottomView.layer.borderWidth = 1;
    
    [_firstOption setText:NSLocalizedString(@"Turn on button :", @"Turn on button :")];
    [_secondOption setText:NSLocalizedString(@"Ajust a value :", @"Ajust a value :")];
    [_thirdOption setText:NSLocalizedString(@"Selection :", @"Selection :")];
    
    NSString *format = [NSString stringWithFormat:@"%@\nMade for the EIP 2013\nv1.0\n08/05/2013", NSLocalizedString(@"AudioWire", @"AudioWire")];
    
    [_bottomLabel setText:format];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
