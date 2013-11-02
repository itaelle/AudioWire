//
//  LibraryViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/3/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellContact.h"
#import "SubPlayer.h"
#import "ContactViewController.h"
#import "ConversationViewController.h"
#import "AddContactViewController.h"
#import "NSObject+NSObject_Tool.h"

@implementation ContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        self.title = NSLocalizedString(@"Contacts", @"Contacts");
    
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadData];
    [_tb_list_artist reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavLogo];
    [self prepareNavBarForEditing];
    
    [_viewForMiniPlayer addSubview:miniPlayer];
    
    [self setUpList];
    [self loadData];
}

-(void)loadData
{
    // Show Loading
    [self setUpLoadingView:_tb_list_artist];
    
    // Data Loading
    tableData = [[NSMutableArray alloc]initWithObjects:@"Adrien",
                 @"Eli",
                 @"Flavien",
                 @"Gaston",
                 @"Irène",
                 @"Jack",
                 @"Justine",
                 @"Karim",
                 @"Lorie",
                 @"Manu",
                 @"Nunuk",
                 @"Patrick",
                 @"Rayan",
                 @"Sergio",
                 @"Tirone",
                 @"Viktor",
                 nil];
    
    // Stop Loading
    [self cancelLoadingView:_tb_list_artist];
}

- (void)addContact
{
    AddContactViewController *addContactVC = [[AddContactViewController alloc] initWithNibName:@"AddContactViewController" bundle:nil];
    
    UIAudioWireCustomNavigationController *nav = [[UIAudioWireCustomNavigationController alloc] initWithRootViewController:addContactVC];
    
    if (IS_OS_7_OR_LATER)
    {
        nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        nav.navigationBar.translucent = YES;
    }
    else
    {
        nav.navigationBar.barStyle = UIBarStyleBlack;
        nav.navigationBar.translucent = NO;
    }
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:nav animated:TRUE completion:^{}];
    [self cancelAction:self];
}

-(void)editAction:(id)sender
{
    [_tb_list_artist setEditing:TRUE animated:TRUE];
    [self prepareNavBarForCancel];
    
    if (tableData)
    {
        [tableData insertObject:@"" atIndex:0];
        [_tb_list_artist reloadData];
    }
}

-(void)cancelAction:(id)sender
{
    [_tb_list_artist setEditing:FALSE animated:TRUE];
    [self prepareNavBarForEditing];
    
    if (tableData)
    {
        [tableData removeObjectAtIndex:0];
        [_tb_list_artist reloadData];
    }
}

-(void)setUpList
{
    _tb_list_artist.delegate = self;
    _tb_list_artist.dataSource = self;
    
    _tb_list_artist.sectionIndexColor = [UIColor whiteColor];
    if (IS_OS_7_OR_LATER)
        _tb_list_artist.sectionIndexBackgroundColor = [UIColor clearColor];
    _tb_list_artist.sectionIndexMinimumDisplayRowCount = MIN_AMOUNT_ARTISTS_TO_DISPLAY_INDEX;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableData && [tableData count] > indexPath.row)
    {
        NSString *stringAtIndex = [NSObject getVerifiedString:[tableData objectAtIndex:indexPath.row]];
        if ([stringAtIndex isEqualToString:@""])
            return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO Delete Contact data
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (tableData && [tableData count] > indexPath.row)
        {
            [tableData removeObjectAtIndex:indexPath.row];
            [_tb_list_artist deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [_tb_list_artist reloadSectionIndexTitles];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        [self addContact];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    // TODO Go to Conversation with contact id
    ConversationViewController *conv = [[ConversationViewController alloc] initWithNibName:@"ConversationViewController" bundle:nil];
    
    [self.navigationController pushViewController:conv animated:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    CellContact *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CellContact" owner:self options:nil] objectAtIndex:0];
        
    }
    if ([[tableData objectAtIndex:indexPath.row] isEqualToString:@""])
    {
        if ([tableView isEditing])
            [cell myInit:[tableData objectAtIndex:indexPath.row] details:NSLocalizedString(@"New contact", @"") ];
        else
            cell.detailTextLabel.text = @"";
    }
    else
        [cell myInit:[tableData objectAtIndex:indexPath.row] details:@"Last message example"];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *alphabetical_indexes = [[NSMutableArray alloc] init];
    
    for (NSString *str in tableData)
    {
        if (str && [str length] > 1)
        {
            NSString *temp = [str substringWithRange:NSMakeRange(0, 1)];
            
            if ([alphabetical_indexes containsObject:temp] == false)
                [alphabetical_indexes insertObject:temp atIndex:[alphabetical_indexes count]];
        }
    }
    return alphabetical_indexes;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger newRow = [self indexForFirstChar:title inArray:tableData];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
    [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    return index;
}

- (NSInteger)indexForFirstChar:(NSString *)character inArray:(NSArray *)array
{
    NSUInteger count = 0;
    for (NSString *str in array)
    {
        if ([str hasPrefix:character])
        {
            return count;
        }
        count++;
    }
    return 0;
}
@end
