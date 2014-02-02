#import "AWMasterViewController.h"

@interface AWImportViewController : AWMasterViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *data;
}
@property (weak, nonatomic) IBOutlet UIButton *bt_import;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act_import;
@property (weak, nonatomic) IBOutlet UITableView *tb_content_import;


- (IBAction)click_import:(id)sender;

@end
