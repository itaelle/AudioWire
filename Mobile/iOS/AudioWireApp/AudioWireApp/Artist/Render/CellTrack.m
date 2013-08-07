//
//  CellConversation.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/5/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "CellTrack.h"

@implementation CellTrack

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)myInit:(NSString *)contact details:(NSString *)detailContact
{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if (contact && [contact length] > 0)
        [_nameLabel setText:contact];
    
    if (contact && [detailContact length] > 0)
        [_detailLabel setText:detailContact];
    
    [_backgroundImage setImage:[UIImage imageNamed:@"music_note.png"]];
}

- (IBAction)clickBtInfo:(id)sender
{
    UIAlertView *temp = [[UIAlertView alloc]initWithTitle:@"Info" message:@"Information about the track => Add to playlist" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [temp show];
}

@end

