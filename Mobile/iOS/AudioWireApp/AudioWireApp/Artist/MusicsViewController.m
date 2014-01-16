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
#import "AWTracksManager.h"

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
    self.skipAuth = YES;
    [self prepareNavBarForEditing];

    if (self.playlist)
        self.title = self.playlist.title;
    _isAlreadyInPlaylist = false;
    
    if (IS_OS_7_OR_LATER)
        self.tb_list_artist.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);

    [_viewForMiniPlayer addSubview:miniPlayer];
    [self setUpList];
}

-(void)editAction:(id)sender
{
    isEditingState = YES;
    [_tb_list_artist reloadSectionIndexTitles];
    [_tb_list_artist setEditing:TRUE animated:TRUE];
    [self prepareNavBarForCancel];
}

-(void)cancelAction:(id)sender
{
    [self deleteTracks];
    
    isEditingState = NO;
    [_tb_list_artist reloadSectionIndexTitles];
    [_tb_list_artist setEditing:FALSE animated:TRUE];
    [self prepareNavBarForEditing];
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

-(void)loadData
{
    // Loading View
    [super setUpLoadingView:_tb_list_artist];
    if (!self.playlist)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Playlist doesn't exist!", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];
        return ;
    }

    [AWPlaylistManager getTracksInPlaylist:self.playlist cb_rep:^(NSArray *data, BOOL success, NSString *error)
    {
        if (success)
        {
            [tableData removeAllObjects];
            tableData = nil;
            tableData = [data mutableCopy];
            [self.tb_list_artist reloadData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:error delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert show];
        }
    }];

    // Loading View
    [super cancelLoadingView:_tb_list_artist];
}

-(void)deleteTracks
{
    [self setUpLoadingView:self.tb_list_artist];
    
    if (tracksToDelete && [tracksToDelete count] > 0)
    {
        [self setUpLoadingView:_tb_list_artist];
        [AWPlaylistManager delTracksInPlaylist:self.playlist tracks:tracksToDelete cb_rep:^(BOOL success, NSString *error)
         {
             if (success)
             {
                 [self setFlashMessage:NSLocalizedString(@"Tracks deleted from playlist!", @"")];
                 [self loadData];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:error delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                 [alert show];
             }
             [tracksToDelete removeAllObjects];
             [self cancelLoadingView:_tb_list_artist];
         }];
    }
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
    if (tableData && [tableData count] > indexPath.row)
    {
        AWTrackModel *trackToDelete = [tableData objectAtIndex:indexPath.row];
        [tableData removeObjectAtIndex:indexPath.row];
        
        [_tb_list_artist deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        if (miniPlayer)
            [miniPlayer stopTrackInItsPlaying:trackToDelete];
        
        if (!tracksToDelete)
            tracksToDelete = [[NSMutableArray alloc] init];
        
        if (trackToDelete && [trackToDelete isKindOfClass:[AWTrackModel class]])
            [tracksToDelete addObject:trackToDelete];
        
        [[AWPlaylistManager getInstance] deleteItunesTrack:indexPath cb_rep:^(BOOL success, NSString *error)
        {
            if (!success && error)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:error delegate:Nil cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
                [alert show];
            }
        }];
        [_tb_list_artist reloadSectionIndexTitles];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    PlayerViewController *player = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
    
    // PROD
    if (tableData && [tableData count] > indexPath.row && [[tableData objectAtIndex:indexPath.row]isKindOfClass:[AWTrackModel class]])
    {
        [AWMusicPlayer getInstance].playlist = [AWPlaylistManager getInstance].itunesMedia;
        
        if (![[AWMusicPlayer getInstance] startAtIndex:indexPath.row])
            [self setFlashMessage:NSLocalizedString(@"Itunes Media failed !", @"")];
        else
            [self.navigationController pushViewController:player animated:true];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableData)
        return [tableData count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"musicCell";
    
    CellTrack *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CellTrack" owner:self options:nil] objectAtIndex:0];
    
    cell.displayIcon = NO;
    cell.parent = self;
    cell.myIndexPath = indexPath;
    [cell myInit:[tableData objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *alphabetical_indexes = [[NSMutableArray alloc] init];
    
    for (AWTrackModel *track in tableData)
    {
        if (track && track.title && [track.title length] >= 1)
        {
            NSString *temp = [track.title substringWithRange:NSMakeRange(0, 1)];
            
            if ([alphabetical_indexes containsObject:[temp capitalizedString]] == false)
                [alphabetical_indexes insertObject:[temp capitalizedString] atIndex:[alphabetical_indexes count]];
        }
    }
    
    if (isEditingState)
        return nil;
    else
        return alphabetical_indexes;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger newRow = [self indexForFirstChar:title inArray:tableData];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
    [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:TRUE];
    
    return index;
}

- (NSInteger)indexForFirstChar:(NSString *)character inArray:(NSArray *)array
{
    NSUInteger count = 0;
    for (AWTrackModel *track in array)
    {
        if (track && [track isKindOfClass:[AWTrackModel class]])
        {
            if ([track.title hasPrefix:character])
                return count;
        }
        count++;
    }
    return 0;
}

@end
