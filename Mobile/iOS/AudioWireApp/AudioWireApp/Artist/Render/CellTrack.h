#import <UIKit/UIKit.h>
#import "AWTrackModel.h"

@interface CellTrack : UITableViewCell
{
}

@property (assign) BOOL isAlreadySelected;
@property (assign) BOOL displayIcon;
@property (strong, nonatomic) UIViewController *parent;
@property (strong, nonatomic) NSIndexPath *myIndexPath;

@property (weak, nonatomic) IBOutlet UIView *viewCell;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *btInfo;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

- (void) myInit:(AWTrackModel *)track;
- (IBAction) clickBtInfo:(id)sender;
- (void)unCheck;

@end
