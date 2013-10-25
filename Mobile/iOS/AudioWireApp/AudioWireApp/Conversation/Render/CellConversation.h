//
//  CellConversation.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/5/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellConversation : UITableViewCell
{
    bool isLeft;
}
@property (weak, nonatomic) IBOutlet UIView *viewCell;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UIButton *bt_message;

-(void) myInit:(bool)isLeft;
-(void) setTextAndAdjustView:(NSString *) content;

- (IBAction)click_message:(id)sender;

@end
