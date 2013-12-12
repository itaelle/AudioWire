//
//  LibraryViewController.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/3/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWMasterViewController.h"

@interface ContactViewController : AWMasterViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *tableData;
    
    UIBarButtonItem *savedBackButton;
    
    NSMutableArray *toDelete;
}

@property (weak, nonatomic) IBOutlet UIView *viewForMiniPlayer;
@property (weak, nonatomic) IBOutlet UITableView *tb_list_artist;

@end
