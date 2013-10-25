//
//  CellConversation.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/5/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "CellConversation.h"

@implementation CellConversation

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

-(void) myInit:(bool)isLeft_
{
    isLeft = isLeft_;
    
    if (isLeft)
    {
        _senderLabel.textAlignment = NSTextAlignmentLeft;
        [_senderLabel setText:NSLocalizedString(@"Jack", @"Jack")];
        [_backgroundImage setImage:[[UIImage imageNamed:@"bubbleSomeone.png"]stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    }
    else
    {
        _senderLabel.textAlignment = NSTextAlignmentRight;
        [_senderLabel setText:NSLocalizedString(@"Me", @"Me")];
        [_backgroundImage setImage:[[UIImage imageNamed:@"bubbleMe.png"]stretchableImageWithLeftCapWidth:21 topCapHeight:14]];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void) setTextAndAdjustView:(NSString *) content
{
    int margin_on_sides = 10;
    int limit_width = self.frame.size.width - 100;
    
    int additional_margins_image = 25;
    
    if (content)
    {
        [self.contentLabel setText:content];
        CGSize sizeFullLabel = [content sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14]}];
        int widthLabel = limit_width;
        int widthContent = sizeFullLabel.width;
        
        int numberLines = 0;
        if (widthContent > widthLabel)
        {
            if ((widthContent % widthLabel) == 0)
                numberLines = (widthContent/widthLabel);
            else
                numberLines = (widthContent/widthLabel) + 1;
        }
        if (numberLines == 0)
            numberLines = 1;
        else if (numberLines >= 1 && numberLines <= 10)
            numberLines += 1;
        
        int heightContent = (numberLines * 19);
        [self.contentLabel setNumberOfLines:0];
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        int WidthToDisplayContent = 0;
        CGRect viewCellRect = _viewCell.frame;
        CGRect backgroundImgRect = _backgroundImage.frame;
        if (numberLines == 1)
        {
            WidthToDisplayContent = sizeFullLabel.width;
            if (WidthToDisplayContent <= 70)
                WidthToDisplayContent = 70;

            viewCellRect.size.height = heightContent + _senderLabel.frame.size.height;
            viewCellRect.size.width = WidthToDisplayContent;
            backgroundImgRect.size.width = WidthToDisplayContent + additional_margins_image;
            backgroundImgRect.size.height = heightContent + (_senderLabel.frame.size.height*2) - 2;
            
        }
        else
        {
            WidthToDisplayContent = widthLabel;
            viewCellRect.size.width = widthLabel;
            viewCellRect.size.height = heightContent;
            backgroundImgRect.size.height = heightContent + _senderLabel.frame.size.height - 2;
            backgroundImgRect.size.width = widthLabel + additional_margins_image;
        }
        if (isLeft == false)
        {
            viewCellRect.origin.x = self.frame.size.width - backgroundImgRect.size.width - margin_on_sides + 10;
            backgroundImgRect.origin.x = self.frame.size.width - backgroundImgRect.size.width - margin_on_sides;
        }
        else
        {
            backgroundImgRect.origin.x = margin_on_sides;
            viewCellRect.origin.x = margin_on_sides + 15;
        }
        [_backgroundImage setFrame:backgroundImgRect];
        [_viewCell setFrame:viewCellRect];
    }
}

- (IBAction)click_message:(id)sender
{
    
}

@end

