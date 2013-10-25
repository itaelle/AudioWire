//
//  LibraryViewController.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/3/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWMasterViewController.h"

@interface LibraryViewController : AWMasterViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>
{
    // Data
    NSMutableArray *tableData;
    NSArray *pickerData;
    
    // Edition
    BOOL isEditingState;
    BOOL isPickerDisplayed;
    NSMutableArray  *selectedMusicIndexes;
    
    // Picker
    UIView *pickerContainer;
    UIPickerView *pickerPlaylist;
    UIButton *pickerValidator;
}

@property (weak, nonatomic) IBOutlet UIView *viewForMiniPlayer;
@property (weak, nonatomic) IBOutlet UITableView *tb_list_artist;

-(void)addMusicSelectionForPlaylist:(NSIndexPath *)indexPathinListData;
-(void)deleteMusicSelectionForPlaylist:(NSIndexPath *)indexPathinListData;

@end
