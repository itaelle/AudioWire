//
//  CreatePlaylistViewController.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/20/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWMasterViewController.h"

@interface CreatePlaylistViewController : AWMasterViewController
{
    BOOL isEditing;
}
@property (weak, nonatomic) IBOutlet UIScrollView *sc_container;
@property (weak, nonatomic) IBOutlet UIView *vw_edition;
@property (weak, nonatomic) IBOutlet UILabel *lb_category;
@property (weak, nonatomic) IBOutlet UITextField *tf_playlist;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act_creating;

@property (weak, nonatomic) IBOutlet UIButton *bt_create;

- (IBAction)click_textField:(id)sender;
- (IBAction)editDidEnd:(id)sender;
@end
