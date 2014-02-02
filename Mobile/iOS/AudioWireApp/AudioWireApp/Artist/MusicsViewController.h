#import "AWMasterViewController.h"
#import "SubPlayer.h"
#import "AWPlaylistManager.h"

@interface MusicsViewController : AWMasterViewController <UITableViewDelegate, UITableViewDataSource>
{
    BOOL isEditingState;
    NSMutableArray *tableData;
    
    NSMutableArray *tracksToDelete;
}
@property Boolean isAlreadyInPlaylist;
@property (strong, nonatomic) AWPlaylistModel *playlist;


@property (weak, nonatomic) IBOutlet UIView *viewForMiniPlayer;
@property (weak, nonatomic) IBOutlet UITableView *tb_list_artist;

@end
