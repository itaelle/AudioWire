//
//  LibraryViewController.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/3/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWMasterViewController.h"

@interface ConversationViewController : AWMasterViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{
    NSArray *tableData;
    CGRect savedEditViewFrame;
    CGRect savedListFrame;
    
    int savedNbLines_;
    CGSize savedSizeContent;
}

@property (weak, nonatomic) IBOutlet UIView *viewForMiniPlayer;
@property (weak, nonatomic) IBOutlet UIView *viewContainerList;
@property (weak, nonatomic) IBOutlet UITableView *tb_list_artist;
@property (weak, nonatomic) IBOutlet UIView *viewForEdition;
@property (weak, nonatomic) IBOutlet UITextView *textArea;

@property (weak, nonatomic) IBOutlet UIButton *btSend;

- (IBAction)clickSendButton:(id)sender;

@end
