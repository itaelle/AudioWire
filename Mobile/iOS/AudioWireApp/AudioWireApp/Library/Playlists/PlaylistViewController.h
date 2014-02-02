#import "AWMasterViewController.h"
#import "SubPlayer.h"

@interface PlaylistViewController : AWMasterViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *tableData;
    NSMutableArray *playlistToDelete;
    
    BOOL firstTime;
    BOOL showOffLineMessageFunctionning;
}

@property (assign) BOOL isSynchronizing;
@property (weak, nonatomic) IBOutlet UIView *viewForMiniPlayer;
@property (weak, nonatomic) IBOutlet UITableView *tb_list_artist;

@end
