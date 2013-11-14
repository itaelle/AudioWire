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
#import "CellConversation.h"
#import "SubPlayer.h"
#import "ConversationViewController.h"

@implementation ConversationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        self.title = NSLocalizedString(@"Conversation", @"");
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_tb_list_artist setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super setUpNavLogo];

    // Loading View
    [super setUpLoadingView:_tb_list_artist];
    
    tableData = [NSArray arrayWithObjects:@"<Hey, What's up ? I found a new dj ! Man, he's awesome. He creates a sound like you never heard before. Just tell me when you are connected, I will let you try it through AudioWire. It's a great apps by the way I like it. One more thing, remember to ask Jennifer for saturday. See you then, Bye dude !Adrien a besoin de rien alors qu'André est un vrai flémard. Paragraphe brain stormed, en francais-anglais. C'est ignoble. De rien, de rien.>",
                 @"Eli",
                 @"Flavien",
                 @"<Adrien a besoin de rien alors qu'André est un vrai flémard. Paragraphe brain stormed, en francais-anglais. C'est ignoble. de rien de rien>",
                 @"Irène",
                 @"Jack",
                 @"Adrien a besoin de rien alors qu'André est un vrai ",
                 @"Karim",
                 @"<dré est un vrai flémard. Paragraphe brain stormed, en francais-anglais. C'est ignoble. de rien de rienAdrien a besoin de rien alors qu'André est un vrai flémard. Paragraphe brain stormed, en francais-anglais. C'est never heard before. Just tell me when you are conHey, What's up ? I found a new dj ! Man, he's awesome. He creates a sound like you never heard before. Just tell me when you are connected, I will let you try it through AudioWire. It's a great apps by the way I like it. One more thing, remember to ask Jennifer for saturday>",
                 @"Manu",
                 @"<heard before. Just tell me when you are conHey, What's up ? I found a new dj ! Man, he's awesome. He creates>",
                 @"<heard before. Just tell me when you are conHey, What's up ? I found a new dj ! Man, he's awesome. He creates are conHey, What's up ? I found a new dj ! Man, he's awesome. He creates >",
                 @"Hey, What's up ? I found a new dj ! Man, he's awesome. He creates such great tracks. Just tell me when you are around here, I'll show you his stuff",
                 @"Hi Bro' I am looking forward to listening at this music.",
                 @"Man, you're on AudioWire, I'am sending it to you right here, right now !",
                 @"No way ! You can't",
                                  @"Look at this ;)",
                 nil];
    
    _tb_list_artist.delegate = self;
    _tb_list_artist.dataSource = self;
    //[_tb_list_artist scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[tableData count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:false];
    
    //Edition Area
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
    
    // Mini Player
    [_viewForMiniPlayer addSubview:miniPlayer];

    // Loading View
    [super cancelLoadingView:_tb_list_artist];
    
    CGSize sizeContent = _textArea.contentSize;
    savedSizeContent = sizeContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
//qs- (void)textViewDidBeginEditing:(UITextView *)textView
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
    CGSize sizeFullLabel = [[tableData objectAtIndex:indexPath.row] sizeWithFont:FONTSIZE(15)];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    CellConversation *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CellConversation" owner:self options:nil] objectAtIndex:0];
        
    }
    if (indexPath.row % 2 == 0)
        [cell myInit:true];
    else
        [cell myInit:false];
    
    [cell setTextAndAdjustView:[tableData objectAtIndex:indexPath.row]];
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Chat", @"") message:NSLocalizedString(@"Please type a text !", @"Please type a text before sending")  delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
        
        [alert show];
        return ;
    }
    
    [self cancelAction:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Chat", @"") message:[NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"Message send", @""), msgToSend] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
    
    [alert show];
}

@end
