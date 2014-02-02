#import "AWMasterViewController.h"

@interface LibraryViewController : AWMasterViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL firstTime;
    
    // Data
    NSMutableArray *tracksToDelete;
    
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

-(void)addMusicSelectionForPlaylist:(NSIndexPath *)indexPathinListData sender:(id)sender_;
-(void)deleteMusicSelectionForPlaylist:(NSIndexPath *)indexPathinListData sender:(id)sender_;

@end
