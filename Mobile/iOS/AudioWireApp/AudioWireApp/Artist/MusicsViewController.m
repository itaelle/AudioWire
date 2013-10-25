//
//  LibraryViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/3/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellTrack.h"
#import "PlayerViewController.h"
#import "SubPlayer.h"
#import "MusicsViewController.h"

@implementation MusicsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        self.title = NSLocalizedString(@"Tracks", @"");

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareNavBarForEditing];

    [_viewForMiniPlayer addSubview:miniPlayer];

    [self setUpList];
    [self loadData];
}

-(void)setUpList
{
    _tb_list_artist.delegate = self;
    _tb_list_artist.dataSource = self;
    _tb_list_artist.sectionIndexColor = [UIColor whiteColor];
    _tb_list_artist.sectionIndexBackgroundColor = [UIColor clearColor];
    _tb_list_artist.sectionIndexMinimumDisplayRowCount = MIN_AMOUNT_ARTISTS_TO_DISPLAY_INDEX;
}

-(void)loadData
{
    // Loading View
    [super setUpLoadingView:_tb_list_artist];
    
    _isAlreadyInPlaylist = false;
    tableData = [NSMutableArray arrayWithArray:@[@"War of mushrooms",
                                                 @"Saxon",
                                                 @"Insane - Electro Dance Party Electro Dance Party",
                                                 @"Track 5",
                                                 @"Electro Panic"]];
    
    // Loading View
    [super cancelLoadingView:_tb_list_artist];
}

-(void)editAction:(id)sender
{
    [_tb_list_artist setEditing:TRUE animated:TRUE];
    [self prepareNavBarForCancel];
}

-(void)cancelAction:(id)sender
{
    [_tb_list_artist setEditing:FALSE animated:TRUE];
    [self prepareNavBarForEditing];
}


- (void)didReceiveMemoryWarningxz
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
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO Delete Music data

    if (tableData && [tableData count] > indexPath.row)
    {
        [tableData removeObjectAtIndex:indexPath.row];
        [_tb_list_artist deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [_tb_list_artist reloadSectionIndexTitles];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];

    // Go To PLAYER Controller
    PlayerViewController *player = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
    [self.navigationController pushViewController:player animated:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    CellTrack *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CellTrack" owner:self options:nil] objectAtIndex:0];

    cell.displayIcon = NO;
    [cell myInit:[tableData objectAtIndex:indexPath.row] details:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Listed in :", @""), self.playlistName]];

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
    
    // NSLog(@"Index to scroll to : %u", newRow);
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
    [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    return index;
}

- (NSInteger)indexForFirstChar:(NSString *)character inArray:(NSArray *)array
{
    NSUInteger count = 0;
    for (NSString *str in array)
    {
        if ([str hasPrefix:character])
            return count;
        count++;
    }
    return 0;
}

@end
