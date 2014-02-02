#import "AWMasterViewController.h"

@interface OptionsViewController : AWMasterViewController
{
    BOOL firstTime;
}

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIButton *bt_signout;
@property (weak, nonatomic) IBOutlet UIButton *bt_userInfo;
@property (weak, nonatomic) IBOutlet UIButton *bt_reset;

@end
