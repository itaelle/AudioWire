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

@implementation ContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        self.title = NSLocalizedString(@"Contacts", @"Contacts");

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super setUpNavLogo];
    
    // Show Loading
    [super setUpLoadingView:_tb_list_artist];
    
    // Data Loading
    tableData = [NSArray arrayWithObjects:@"Adrien",
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
    
    
    _tb_list_artist.delegate = self;
    _tb_list_artist.dataSource = self;
    
    _tb_list_artist.sectionIndexBackgroundColor = [UIColor clearColor];
    _tb_list_artist.sectionIndexMinimumDisplayRowCount = MIN_AMOUNT_ARTISTS_TO_DISPLAY_INDEX;
    
    SubPlayer *miniPlayer = [[[NSBundle mainBundle] loadNibNamed:@"SubPlayer" owner:self options:nil] objectAtIndex:0];
    miniPlayer.delegate = self;
    [_viewForMiniPlayer addSubview:miniPlayer];
    [miniPlayer myInit];
    
    // Stop Loading
    [super cancelLoadingView:_tb_list_artist];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];

    // Go to Conversation
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
    [cell myInit:[tableData objectAtIndex:indexPath.row] details:@"Last message example"];

    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *alphabetical_indexes = [[NSMutableArray alloc] init];
    
    for (NSString *str in tableData)
    {
        NSString *temp = [str substringWithRange:NSMakeRange(0, 1)];
        
        if ([alphabetical_indexes containsObject:temp] == false)
        {
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
