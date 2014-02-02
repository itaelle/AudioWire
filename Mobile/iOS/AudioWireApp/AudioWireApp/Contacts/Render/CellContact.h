#import <UIKit/UIKit.h>
#import "AWUserModel.h"

@interface CellContact : UITableViewCell
{
    bool isLeft;
}
@property (weak, nonatomic) IBOutlet UIView *viewCell;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *btInfo;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

- (void)myInit:(AWUserModel *)contact;
- (IBAction)clickBtInfo:(id)sender;

@end
