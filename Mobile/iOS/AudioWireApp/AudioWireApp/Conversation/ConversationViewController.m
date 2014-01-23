//
//  LibraryViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/3/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "AWXMPPManager.h"
#import "CellConversation.h"
#import "SubPlayer.h"
#import "ConversationViewController.h"
#import "AWUserManager.h"

@implementation ConversationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Conversation", @"");
        self.closeOption = NO;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (IS_OS_7_OR_LATER)
        self.tb_list_artist.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    if (self.closeOption)
        [self prepareNavBarForClose];
    
// #warning DEBUG DEV
//    self.usernameSelectedFriend = @"friend";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [AWXMPPManager getInstance].delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavLogo];
    [self setUpViews];
}

-(void)setUpViews
{
    _tb_list_artist.delegate = self;
    _tb_list_artist.dataSource = self;
    
    [_viewForEdition setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    _textArea.layer.cornerRadius = 10;
    _textArea.layer.borderColor = [[UIColor blackColor]CGColor];
    _textArea.layer.borderWidth = 1;
    _textArea.delegate = self;
    
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blackButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    [_btSend setBackgroundImage:buttonImageHighlight forState:UIControlStateNormal];
    [_btSend setTitle:NSLocalizedString(@"Send", @"") forState:UIControlStateNormal];
    
    [_viewForMiniPlayer addSubview:miniPlayer];
    
    CGSize sizeContent = _textArea.contentSize;
    savedSizeContent = sizeContent;
}

-(void)loadData
{
    [self setUpLoadingView:_tb_list_artist];
    _tb_list_artist.delegate = self;
    _tb_list_artist.dataSource = self;
    
    [AWXMPPManager getInstance].delegate = self;
    
    NSManagedObjectContext *moc = [[AWXMPPManager getInstance] managedObjectContext_messages];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                              inManagedObjectContext:moc];
    
    NSString *chatWithUserJID = [NSString stringWithFormat:@"%@%@", self.usernameSelectedFriend, JABBER_DOMAIN];
    
    NSString *predicateFrmt = @"bareJidStr like %@ ";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt, chatWithUserJID];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    fetchRequest.predicate = predicate;
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *messages_arc = [moc executeFetchRequest:fetchRequest error:&error];
    
    NSFetchedResultsController *fetchedResults = [self fetchedResultsController];
    
//    XMPPUserCoreDataStorageObject *user = [fetchedResults objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    for (XMPPMessageArchiving_Message_CoreDataObject *message in messages_arc)
    {
        
        NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:message.messageStr error:nil];
        NSLog(@"to param is %@",[element attributeStringValueForName:@"to"]);
        
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
        [m setObject:message.body forKey:@"msg"];
        
        if ([[element attributeStringValueForName:@"sender"] isEqualToString:chatWithUserJID])
            [m setObject:self.usernameSelectedFriend forKey:@"sender"];
        else
        {
            if ([[element attributeStringValueForName:@"to"] isSubString:[AWUserManager getInstance].user.username])
                [m setObject:self.usernameSelectedFriend forKey:@"sender"];
            else
                [m setObject:[AWUserManager getInstance].user.username forKey:@"sender"];
        }

        [m setObject:[NSNumber numberWithBool:[message.outgoing intValue]] forKey:@"outgoing"];

        if (!tableData)
            tableData = [[NSMutableArray alloc] init];

        [tableData addObject:m];

        NSLog(@"bareJid param is %@",message.bareJid);
        NSLog(@"bareJidStr param is %@",message.bareJidStr);
        NSLog(@"body param is %@",message.body);
        NSLog(@"timestamp param is %@",message.timestamp);
        NSLog(@"outgoing param is %d",[message.outgoing intValue]);
        NSLog(@"***************************************************");
    }
    [self cancelLoadingView:self.tb_list_artist];
    [self.tb_list_artist reloadData];
    
    if (!tableData)
        tableData = [[NSMutableArray alloc] init];
    if ([tableData count] > 1)
        [self.tb_list_artist scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([tableData count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:TRUE];
}

#pragma  AWXMPPManagerDelegate
-(void)messageRender:(NSDictionary *)infoMsg
{
    if (infoMsg)
    {
        if ([[infoMsg objectForKey:@"sender"] isSubString:self.usernameSelectedFriend])
        {
            
            NSMutableDictionary *mutableInfoMsg = [NSMutableDictionary dictionaryWithDictionary:infoMsg];
            [mutableInfoMsg setObject:self.usernameSelectedFriend forKey:@"sender"];

            if (!tableData)
                tableData = [[NSMutableArray alloc] init];
            [tableData addObject:mutableInfoMsg];

#warning REPLACE WITH INSERT ANIMATION
        [self.tb_list_artist reloadData];
        
        // Animation scroll to bottom of the list
        [self.tb_list_artist scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([tableData count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:TRUE];
        }
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
	if (fetchedResultsController == nil)
	{
		NSManagedObjectContext *moc = [[AWXMPPManager getInstance] managedObjectContext_roster];
        
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
		                                          inManagedObjectContext:moc];
		
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
        
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
        
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
		
		fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
		                                                               managedObjectContext:moc
		                                                                 sectionNameKeyPath:@"sectionNum"
		                                                                          cacheName:nil];
		[fetchedResultsController setDelegate:self];
        
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error])
		{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:[error.userInfo description] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
            [alert show];
		}
	}
	return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	[self.tb_list_artist reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
















////////////////////////////////////////////////
// Send message
////////////////////////////////////////////////
#pragma UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView)
    {
        CGSize sizeContent = textView.contentSize;
        
        savedNbLines_ = textView.contentSize.height/textView.font.lineHeight;

        if (savedNbLines_ > 1 && savedSizeContent.height < sizeContent.height)
        {
            CGRect viewEditionFrame = _viewForEdition.frame;
            viewEditionFrame.origin.y -= sizeContent.height - savedSizeContent.height;
            viewEditionFrame.size.height += sizeContent.height - savedSizeContent.height;
            
            if (viewEditionFrame.size.height > 100)
                return ;
            
            CGRect listFrame = _viewContainerList.frame;
            listFrame.size.height -= sizeContent.height - savedSizeContent.height;

            [_viewContainerList setFrame:listFrame];
            [_tb_list_artist scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[tableData count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];
            [_viewForEdition setFrame:viewEditionFrame];
            
        }

        savedSizeContent = sizeContent;
    }
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableData)
        return [tableData count];
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictInfo = [tableData objectAtIndex:indexPath.row];
    
    if (dictInfo)
    {
        NSString *text = [dictInfo objectForKey:@"msg"];
        if (!text)
            return 0.f;
        
    CGSize sizeFullLabel = [text sizeWithFont:FONTSIZE(15)];
    
    int widthLabel = 239;
    int widthContent = sizeFullLabel.width;
    
    int numberLines = 0;
    int heightContent = 0;
    if (widthContent > widthLabel)
    {
        if ((widthContent % widthLabel) == 0)
            numberLines = (widthContent/widthLabel);
        else
            numberLines = (widthContent/widthLabel) + 1;
    }
    if (numberLines == 0)
        numberLines = 1;
    
    heightContent = (numberLines * 18) + 45;
    return heightContent;
    }
    else
        return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    CellConversation *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CellConversation" owner:self options:nil] objectAtIndex:0];
    }
    [cell myInit:[tableData objectAtIndex:indexPath.row]];
    return cell;
}

// TEST KEYBOARD
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    savedEditViewFrame = _viewForEdition.frame;
    CGRect new = savedEditViewFrame;
    new.origin.y = self.view.frame.size.height - kbSize.height - new.size.height;
    
    // set frame viewEdition
    savedListFrame = _viewContainerList.frame;
    CGRect tempFrame = savedListFrame;
    tempFrame.size.height = self.view.frame.size.height - kbSize.height - new.size.height - self.navigationController.navigationBar.frame.size.height;
    
    // Set frame tb_list
    [UIView animateWithDuration:0.2 animations:^{
        
        [_viewForEdition setFrame:new];
        [_viewContainerList setFrame:tempFrame];
        if (isLoading)
            [self updatePositionLoader:tempFrame];

        
    } completion:^(BOOL finished) {
        if (finished)
        {
            
        }
    }];
    
    if ([tableData count] > 1)
        [_tb_list_artist scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[tableData count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:FALSE];
    
    [self prepareNavBarForCancel];
}

-(void)cancelAction:(id)sender
{
//    if (sender && [sender isKindOfClass:[UIBarButtonItem class]])
    {
        [UIView animateWithDuration:0.2 animations:^{
            [_viewContainerList setFrame:savedListFrame];
            if (isLoading)
                [self updatePositionLoader:savedListFrame];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{

            [_textArea resignFirstResponder];
            [_viewForEdition setFrame:savedEditViewFrame];

        } completion:^(BOOL finished) {
            if (finished)
            {
//                _textArea.text = @"";
                [self desactivateButtonBar:true right:true];
            }
        }];
    }
}

- (IBAction)clickSendButton:(id)sender
{
    NSString *msgToSend = _textArea.text;
    
    if ([msgToSend length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Please type a text !", @"Please type a text before sending")  delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
        
        [alert show];
        return ;
    }
    
    [self cancelAction:nil];
    
    
    
    NSMutableDictionary *mutableInfoMsg = [[NSMutableDictionary alloc] init];
    [mutableInfoMsg setObject:[AWUserManager getInstance].user.username forKey:@"sender"];
    [mutableInfoMsg setObject:msgToSend forKey:@"msg"];
    [mutableInfoMsg setObject:[NSNumber numberWithBool:YES] forKey:@"outgoing"];
    
    if (!tableData)
        tableData = [[NSMutableArray alloc] init];
    [tableData addObject:mutableInfoMsg];

    
    
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:([tableData count]-1) inSection:0];

    [self.tb_list_artist beginUpdates];
    [self.tb_list_artist insertRowsAtIndexPaths:@[rowToReload] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tb_list_artist endUpdates];

    [_tb_list_artist scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[tableData count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:true];

    self.textArea.text = @"";
    
    [[AWXMPPManager getInstance] sendMessage:msgToSend toUserJID:[NSString stringWithFormat:@"%@%@", self.usernameSelectedFriend, JABBER_DOMAIN]];
}

@end
