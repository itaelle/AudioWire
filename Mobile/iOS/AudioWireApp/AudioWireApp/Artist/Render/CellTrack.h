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

-(void)myInit:(NSString *)track details:(NSString *)detailContact;
- (IBAction)clickBtInfo:(id)sender;

@end
