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
#import "AWPlaylistManager.h"

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
    
    if (!firstTime)
        [self loadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    firstTime = YES;

    [self setUpNavLogo];
    [self prepareNavBarForEditing];
    
    [_viewForMiniPlayer addSubview:miniPlayer];
    
    [self setUpList];
    
// Remove loadData, called after reconnect
//    [self loadData];
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

-(void) loadData
{
    [self setUpLoadingView:_tb_list_artist];
    
    [AWPlaylistManager getAllPlaylists:^(NSArray *data, BOOL success, NSString *error)
    {
        [self cancelLoadingView:_tb_list_artist];
        
        if (success)
        {
            tableData = nil;
            tableData = [NSMutableArray arrayWithArray:data];
            [_tb_list_artist reloadData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:error delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)addPlaylist
{
    CreatePlaylistViewController *createPlaylist = [[CreatePlaylistViewController alloc] initWithNibName:@"CreatePlaylistViewController" bundle:nil];
    
    UIAudioWireCustomNavigationController *nav = [[UIAudioWireCustomNavigationController alloc] initWithRootViewController:createPlaylist];
    
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
        AWPlaylistModel *modelForAdding = [AWPlaylistModel new];
        [tableData insertObject:modelForAdding atIndex:0];
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
        
        if (playlistToDelete && [playlistToDelete count] > 0)
        {
            [self setUpLoadingView:_tb_list_artist];
            
            [AWPlaylistManager deletePlaylist:playlistToDelete cb_rep:^(BOOL success, NSString *details) {
                [self cancelLoadingView:_tb_list_artist];
                
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:details delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
                    [alert show];
            }];
        }
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
    if (indexPath && indexPath.row == 0)
        return UITableViewCellEditingStyleInsert;
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO Delete Playlist data

    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (tableData && [tableData count] > indexPath.row)
        {
            if (!playlistToDelete)
                playlistToDelete = [[NSMutableArray alloc] init];
            [playlistToDelete addObject:[tableData objectAtIndex:indexPath.row]];

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

    id selectedRowModel = [tableData objectAtIndex:indexPath.row];

    if (selectedRowModel && [selectedRowModel isKindOfClass:[AWPlaylistModel class]])
    {
        MusicsViewController *artist_controller = [[MusicsViewController alloc] initWithNibName:@"MusicsViewController" bundle:nil];
        artist_controller.playlist = selectedRowModel;
        artist_controller.isAlreadyInPlaylist = true;
        [self.navigationController pushViewController:artist_controller animated:true];
    }
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
    
    id selectedRowModel = [tableData objectAtIndex:indexPath.row];
    if (selectedRowModel && [selectedRowModel isKindOfClass:[AWPlaylistModel class]])
        cell.textLabel.text = ((AWPlaylistModel *)selectedRowModel).title;
    
    if ([tableView isEditing])
    {
        if (indexPath && indexPath.row == 0)
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

    for (AWPlaylistModel *playlist in tableData)
    {
        if (playlist && playlist.title && [playlist.title length] > 1)
        {
            NSString *temp = [playlist.title substringWithRange:NSMakeRange(0, 1)];
            
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
