//
//  CellConversation.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/5/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellTrack : UITableViewCell
{
    bool isLeft;
}
@property (weak, nonatomic) IBOutlet UIView *viewCell;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *btInfo;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

-(void)myInit:(NSString *)contact details:(NSString *)detailContact;
- (IBAction)clickBtInfo:(id)sender;

@end
