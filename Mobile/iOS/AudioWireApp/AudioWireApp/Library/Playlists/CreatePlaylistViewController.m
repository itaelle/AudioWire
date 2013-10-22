//
//  CreatePlaylistViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/20/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "CreatePlaylistViewController.h"

@implementation CreatePlaylistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Playlist Edition", @"");
        isEditing = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    int height_view = [UIDevice getScreenFrame].size.height - 20 /*Status*/ - 44 /*NavBar*/;
    [self.sc_container setFrame:CGRectMake(self.sc_container.frame.origin.x, self.sc_container.frame.origin.y, self.sc_container.frame.size.width, height_view)];
    
    [self.sc_container setContentSize:CGSizeMake(self.sc_container.frame.size.width, height_view)];
    
    CGRect btCreateRect = self.bt_create.frame;
    btCreateRect.origin.y  = self.sc_container.frame.size.height - self.bt_create.frame.size.height - 20;
    [self.bt_create setFrame:btCreateRect];
    CGRect actCreateRect = self.act_creating.frame;
    actCreateRect.origin.y  = self.sc_container.frame.size.height - self.bt_create.frame.size.height - 20;
    [self.act_creating setFrame:btCreateRect];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareNavBarForClose];
    [self setUpViews];
}

-(void)cancelAction:(id)sender
{
    [self.tf_playlist resignFirstResponder];
}

-(void)closeAction:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:true completion:^{
        
    }];
}

-(void)setUpViews
{
    [self.lb_category setFont:FONTBOLDSIZE(12)];
    [self.lb_category setText:NSLocalizedString(@"Name of the playist :", @"")];
    [self.bt_create setTitle:NSLocalizedString(@"Create playlist", @"") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)click_create:(id)sender
{
    [self.act_creating setAlpha:1];
    [self.act_creating startAnimating];
    [self.bt_create setAlpha:0];
    
    // Create the playlist
    
    // Finish creating
    [self.act_creating setAlpha:0];
    [self.act_creating stopAnimating];
    [self.bt_create setAlpha:1];
    [self closeAction:nil];
}

- (IBAction)click_textField:(UITextField *)sender
{
    [self prepareNavBarForCancel];
    isEditing = YES;
    
    int height_view = [UIDevice getScreenFrame].size.height - 20 /*Status*/ - 44 /*NavBar*/;
    [self.sc_container setFrame:CGRectMake(self.sc_container.frame.origin.x, self.sc_container.frame.origin.y, self.sc_container.frame.size.width, height_view - KEYBOARD_WIDTH)];


    CGRect btCreateRect = self.bt_create.frame;
    btCreateRect.origin.y  = self.vw_edition.frame.origin.y + self.vw_edition.frame.size.height + 20;
    [self.bt_create setFrame:btCreateRect];
    
    CGRect actCreateRect = self.act_creating.frame;
    actCreateRect.origin.y  = self.vw_edition.frame.origin.y + self.vw_edition.frame.size.height + 20;
    [self.act_creating setFrame:btCreateRect];
    
    
    if (![UIDevice isIphone5])
    {
        [self.sc_container setContentOffset:CGPointMake(0, sender.superview.frame.origin.y - 35) animated:NO];
    }
    else
    {
        [self.sc_container setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

- (IBAction)editDidEnd:(UITextField *)sender
{
    [self prepareNavBarForClose];
    isEditing = NO;
    
    int height_view = [UIDevice getScreenFrame].size.height - 20 /*Status*/ - 44 /*NavBar*/;
    [self.sc_container setFrame:CGRectMake(self.sc_container.frame.origin.x, self.sc_container.frame.origin.y, self.sc_container.frame.size.width, height_view)];

    [self.sc_container setContentSize:CGSizeMake(self.sc_container.frame.size.width, height_view)];

    CGRect btCreateRect = self.bt_create.frame;
    btCreateRect.origin.y  = self.sc_container.frame.size.height - self.bt_create.frame.size.height - 20;
    [self.bt_create setFrame:btCreateRect];
    CGRect actCreateRect = self.act_creating.frame;
    actCreateRect.origin.y  = self.sc_container.frame.size.height - self.bt_create.frame.size.height - 20;
    [self.act_creating setFrame:btCreateRect];
}


@end
