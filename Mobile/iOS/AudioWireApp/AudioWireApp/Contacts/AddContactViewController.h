#import "AWMasterViewController.h"

@interface AddContactViewController : AWMasterViewController
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
