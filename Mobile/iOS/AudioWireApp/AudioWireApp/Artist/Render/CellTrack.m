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
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)myInit:(AWTrackModel *)track
{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if (track && [track.title length] > 0)
        [_nameLabel setText:track.title];
    else
        [_detailLabel setText:@""];

    if (track && [track.album length] > 0)
        [_detailLabel setText:track.album];
    else
        [_detailLabel setText:@""];
    
    [_backgroundImage setImage:[UIImage imageNamed:@"music_note.png"]];

    if (_isAlreadySelected)
    {
        [_btInfo setBackgroundImage:[UIImage imageNamed:@"picto-check.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btInfo setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    }
    if (!_displayIcon)
        [_btInfo setHidden:true];
    
    [_nameLabel setFont:FONTBOLDSIZE(17)];
    [_detailLabel setFont:FONTSIZE(13)];
}

- (IBAction)clickBtInfo:(id)sender
{
    if (_isAlreadySelected)
    {
        _isAlreadySelected = NO;
        [self.btInfo setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        
        if (self.parent && [self.parent respondsToSelector:@selector(deleteMusicSelectionForPlaylist:)])
        {
            [self.parent performSelector:@selector(deleteMusicSelectionForPlaylist:) withObject:self.myIndexPath];
        }
    }
    else
    {
        _isAlreadySelected = YES;
        [self.btInfo setBackgroundImage:[UIImage imageNamed:@"picto-check.png"] forState:UIControlStateNormal];
        
        if (self.parent && [self.parent respondsToSelector:@selector(addMusicSelectionForPlaylist:)])
        {
            [self.parent performSelector:@selector(addMusicSelectionForPlaylist:) withObject:self.myIndexPath];
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing)
    {
        CGRect rectTitle = self.nameLabel.frame;
        rectTitle.size.width = 202;

        CGRect rectDetail = self.detailLabel.frame;
        rectDetail.size.width = 202;
        
        [UIView animateWithDuration:0.4 animations:^{

            self.nameLabel.frame = rectTitle;
            self.detailLabel.frame = rectDetail;

            [_btInfo setAlpha:1];
        }];
    }
    else
    {
        _isAlreadySelected = NO;
        
        CGRect rectTitle = self.nameLabel.frame;
        rectTitle.size.width = 265;
        
        CGRect rectDetail = self.detailLabel.frame;
        rectDetail.size.width = 265;
        
        
        [self.btInfo setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.4 animations:^{

            [_btInfo setAlpha:0];
            
        } completion:^(BOOL finished) {
            
            self.nameLabel.frame = rectTitle;
            self.detailLabel.frame = rectDetail;
        }];
    }
}

@end

