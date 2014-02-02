#import "CellContact.h"

@implementation CellContact

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

-(void)myInit:(AWUserModel *)contact
{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if (contact && contact.username)
        [_nameLabel setText:contact.username];
    
    if (contact && contact.lastName && contact.firstName)
        [_detailLabel setText:[NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName]];
    
    [_backgroundImage setImage:[UIImage imageNamed:@"avatar.png"]];

    [_nameLabel setFont:FONTBOLDSIZE(17)];
    [_detailLabel setFont:FONTSIZE(13)];
}

- (IBAction)clickBtInfo:(id)sender
{
    UIAlertView *temp = [[UIAlertView alloc]initWithTitle:@"Info" message:@"Information of the contact/friend" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [temp show];
}

@end

