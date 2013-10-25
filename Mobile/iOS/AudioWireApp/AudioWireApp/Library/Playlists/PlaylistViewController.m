//
//  LibraryViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/3/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "MusicsViewController.h"
#import "SubPlayer.h"
#import "PlaylistViewController.h"
#import "CreatePlaylistViewController.h"
#import "NSObject+NSObject_Tool.h"

@implementation PlaylistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Playlist", @"Playlist");
    }
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

-(void)setUpList
{
    _tb_list_artist.delegate = self;
    _tb_list_artist.dataSource = self;
    _tb_list_artist.sectionIndexColor = [UIColor whiteColor];
    _tb_list_artist.sectionIndexBackgroundColor = [UIColor clearColor];
    _tb_list_artist.sectionIndexMinimumDisplayRowCount = MIN_AMOUNT_ARTISTS_TO_DISPLAY_INDEX;
}

-(void) loadData
{
    // Loading View
    [self setUpLoadingView:_tb_list_artist];
    
    tableData = [[NSMutableArray alloc]initWithObjects:@"First playlist rock",
                 @"Playlist 2",
                 @"Minimal",
                 @"Electro",
                 @"Psychedelic Trance (Infected Mushroom)",
                 nil];
    
    // Loading View
    [self cancelLoadingView:_tb_list_artist];
}

- (void)addPlaylist
{
    CreatePlaylistViewController *createPlaylist = [[CreatePlaylistViewController alloc] initWithNibName:@"CreatePlaylistViewController" bundle:nil];
    
    UIAudioWireCustomNavigationController *nav = [[UIAudioWireCustomNavigationController alloc] initWithRootViewController:createPlaylist];
    
    nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    nav.navigationBar.translucent = YES;

    
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
//        [_tb_list_artist reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
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
//        [_tb_list_artist reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[tableData count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    }
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
    // TODO Delete Playlist data

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
        [self addPlaylist];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];

    NSString *playlistNameClicked = [NSObject getVerifiedString:[tableData objectAtIndex:indexPath.row]];
    
    // TODO  Music Controller with ID
    MusicsViewController *artist_controller = [[MusicsViewController alloc] initWithNibName:@"MusicsViewController" bundle:nil];
    [self.navigationController pushViewController:artist_controller animated:true];

    artist_controller.playlistName = playlistNameClicked;
    artist_controller.isAlreadyInPlaylist = true;
    [artist_controller setTitle:[tableData objectAtIndex:indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    if ([[tableData objectAtIndex:indexPath.row] isEqualToString:@""])
    {
        if ([tableView isEditing])
            cell.detailTextLabel.text = NSLocalizedString(@"New playlist", @"");
        else
            cell.detailTextLabel.text = @"";
    }
    else
        cell.detailTextLabel.text = @"10 tracks";

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
