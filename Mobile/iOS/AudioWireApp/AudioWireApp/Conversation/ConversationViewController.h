#import <CoreData/CoreData.h>
#import "AWMasterViewController.h"
#import "AWXMPPManager.h"

@interface ConversationViewController : AWMasterViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, NSFetchedResultsControllerDelegate, AWXMPPManagerDelegate>
{
    NSMutableArray *tableData;
    CGRect savedEditViewFrame;
    CGRect savedListFrame;
    
    int savedNbLines_;
    CGSize savedSizeContent;
    
    NSFetchedResultsController *fetchedResultsController;
}

@property (strong, nonatomic) NSString *usernameSelectedFriend;
@property (assign) BOOL closeOption;

@property (weak, nonatomic) IBOutlet UIView *viewForMiniPlayer;
@property (weak, nonatomic) IBOutlet UIView *viewContainerList;
@property (weak, nonatomic) IBOutlet UITableView *tb_list_artist;
@property (weak, nonatomic) IBOutlet UIView *viewForEdition;
@property (weak, nonatomic) IBOutlet UITextView *textArea;

@property (weak, nonatomic) IBOutlet UIButton *btSend;

- (IBAction)clickSendButton:(id)sender;

@end
