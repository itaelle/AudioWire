//
//  LibraryViewController.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/3/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWMasterViewController.h"
#import "SubPlayer.h"
#import "AWPlaylistManager.h"

@interface MusicsViewController : AWMasterViewController <UITableViewDelegate, UITableViewDataSource>
{
    BOOL isEditingState;
    NSMutableArray *tableData;
}
@property Boolean isAlreadyInPlaylist;
@property (strong, nonatomic) AWPlaylistModel *playlist;


@property (weak, nonatomic) IBOutlet UIView *viewForMiniPlayer;
@property (weak, nonatomic) IBOutlet UITableView *tb_list_artist;

@end
