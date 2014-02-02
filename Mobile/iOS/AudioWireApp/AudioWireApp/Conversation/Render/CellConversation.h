#import <UIKit/UIKit.h>

@interface CellConversation : UITableViewCell
{
    bool isLeft;
    NSDictionary *data_;
}
@property (weak, nonatomic) IBOutlet UIView *viewCell;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UIButton *bt_message;

-(void) myInit:(NSDictionary *)data;
- (IBAction)click_message:(id)sender;

@end
