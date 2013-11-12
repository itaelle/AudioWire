 //
//  LibraryViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 8/3/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "MusicsViewController.h"
#import "SubPlayer.h"
#import "LibraryViewController.h"
#import "CellTrack.h"
#import "PlayerViewController.h"
#import "AWTrackModel.h"
#import "AWItunesImportManager.h"
#import "AWTracksManager.h"
#import "AWPlaylistManager.h"

@implementation LibraryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Library", @"");
        isEditingState = NO;
        isPickerDisplayed = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavLogo];
    [self prepareNavBarForEditing];
    [self setUpPicker];
    
    [self.viewForMiniPlayer addSubview:miniPlayer];
    selectedMusicIndexes = [NSMutableArray new];
    
    [self setUpList];
}

-(void) setUpPicker
{
    pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewForMiniPlayer.frame.size.width, self.viewForMiniPlayer.frame.size.height)];
    [pickerContainer setBackgroundColor:[UIColor clearColor]];
    
    CGRect rectForPicker = pickerContainer.frame;
    rectForPicker.size.width = 250;
    
    pickerPlaylist = [[UIPickerView alloc] initWithFrame:rectForPicker];
    pickerPlaylist.dataSource = self;
    pickerPlaylist.delegate = self;
    pickerPlaylist.showsSelectionIndicator = YES;

    if (IS_OS_7_OR_LATER)
        [pickerPlaylist setTintColor:[UIColor whiteColor]];
    
    CGRect rectForButton = pickerContainer.frame;
    rectForButton.size.height -= 10;
    rectForButton.size.width = 60;
    rectForButton.origin.x = 255;
    rectForButton.origin.y = 5;
    
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blackButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    pickerValidator = [[UIButton alloc] initWithFrame:rectForButton];
    [pickerValidator setBackgroundImage:buttonImageHighlight forState:UIControlStateNormal];
    [pickerValidator setTitle:NSLocalizedString(@"Add", @"") forState:UIControlStateNormal];
    [pickerValidator addTarget:self action:@selector(didSelectPlaylist:) forControlEvents:UIControlEventTouchUpInside];
    
    [pickerContainer addSubview:pickerPlaylist];
    [pickerContainer addSubview:pickerValidator];
    
    [pickerContainer setAlpha:0];
    [self.viewForMiniPlayer addSubview:pickerContainer];
}

-(void)setUpList
{
    _tb_list_artist.delegate = self;
    _tb_list_artist.dataSource = self;
    if (IS_OS_7_OR_LATER)
        _tb_list_artist.sectionIndexBackgroundColor = [UIColor clearColor];
    _tb_list_artist.sectionIndexMinimumDisplayRowCount = MIN_AMOUNT_ARTISTS_TO_DISPLAY_INDEX;
}

-(void)loadData
{
    // Loading View
    [self setUpLoadingView:_tb_list_artist];
    
    [AWTracksManager getAllTracks:^(NSArray *data, BOOL success, NSString *error) {
        if (success)
        {
            tableData = [data mutableCopy];
            [self.tb_list_artist reloadData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:error delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
            [alert show];
        }
        [self cancelLoadingView:_tb_list_artist];
    }];
    
//    tableData = [NSMutableArray arrayWithArray:@[@"AC/DC - Back in black",
//                                                 @"Edith Piaf - Non rien de rien",
//                                                 @"Electro Dance Party Mix",
//                                                 @"Gipsy King - Flamenco",
//                                                 @"Infected Mushroom - War",
//                                                 @"Jacques Prévert - Chansonnette",
//                                                 @"Justin Bieber - Track 1",
//                                                 @"Kamini - Kamini",
//                                                 @"Lorie - Avoir 20 ans",
//                                                 @"Manau - Dans la vallée",
//                                                 @"Nostradamus",
//                                                 @"NTM",
//                                                 @"Ozone",
//                                                 @"PitBull",
//                                                 @"Piwies",
//                                                 @"Rolling Stones",
//                                                 @"System of a down",
//                                                 @"Taylor Swift",
//                                                 @"U",
//                                                 @"V"]];
    
    pickerData = @[@"Playlist rock soft",
                   @"My Dubstep",
                   @"Minimal",
                   @"Electro commercial",
                   @"At work",
                   @"Psychedelic Trance"];
    
    if (pickerData && [pickerData count] > 1)
        [pickerPlaylist selectRow:([pickerData count]-2) inComponent:0 animated:YES];
}

-(void)didSelectPlaylist:(id)sender
{
    [self setUpLoadingView:self.tb_list_artist];
    int rowSelected = [pickerPlaylist selectedRowInComponent:0];
    AWPlaylistModel *playlistSelected = nil;
    
    if ([pickerData count] > rowSelected)
        playlistSelected = [pickerData objectAtIndex:rowSelected];

    if (!selectedMusicIndexes || [selectedMusicIndexes count] <= 0)
        return ;
    
    NSString *tracksNames = @"";
    NSMutableArray *tracksToAdd = [[NSMutableArray alloc]initWithCapacity:selectedMusicIndexes.count];
    for (id object in selectedMusicIndexes)
    {
        if (object && [object isKindOfClass:[NSIndexPath class]])
        {
            AWTrackModel *trackModel = [tableData objectAtIndex:((NSIndexPath *)object).row];
            if (trackModel && [trackModel isKindOfClass:[AWTrackModel class]])
            {
                tracksNames = [tracksNames stringByAppendingString:trackModel.title];
                tracksNames = [tracksNames stringByAppendingString:@", "];
                [tracksToAdd addObject:trackModel];
            }
        }
    }
    if (playlistSelected && [playlistSelected isKindOfClass:[AWPlaylistModel class]] && tracksToAdd && [tracksToAdd count] > 0)
    {
        [AWPlaylistManager addTracksInPlaylist:playlistSelected tracks:tracksToAdd cb_rep:^(BOOL success, NSString *error)
        {
            if (success)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert setTitle:NSLocalizedString(@"Information", @"")];
                [alert setMessage:[NSString stringWithFormat:@"%@ %@ %@", tracksNames, [selectedMusicIndexes count] == 1 ? NSLocalizedString(@"added in the playlist", @"") : NSLocalizedString(@"added in the playlist", @""), playlistSelected]];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:error delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                [alert show];
            }
            [self cancelLoadingView:self.tb_list_artist];
        }];
    }
    else
    {
        [self cancelLoadingView:self.tb_list_artist];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert setTitle:NSLocalizedString(@"Oops !", @"")];
        [alert setMessage:NSLocalizedString(@"Something went wrong while trying to select one of your playlist", @"")];
        [alert show];
    }
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
    isEditingState = NO;
    [_tb_list_artist reloadSectionIndexTitles];
    [_tb_list_artist setEditing:FALSE animated:TRUE];
    
    [self prepareNavBarForEditing];
    
    if (isPickerDisplayed)
    {
        [selectedMusicIndexes removeAllObjects];
        [self hidePicker];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)addMusicSelectionForPlaylist:(NSIndexPath *)indexPathinListData
{
    if (selectedMusicIndexes)
        [selectedMusicIndexes addObject:indexPathinListData];
    else
        return ;
    
    if (!isPickerDisplayed)
        [self showPicker];
}

-(void)deleteMusicSelectionForPlaylist:(NSIndexPath *)indexPathinListData
{
    if (selectedMusicIndexes && [selectedMusicIndexes containsObject:indexPathinListData])
    {
        [selectedMusicIndexes removeObject:indexPathinListData];
        
        if ([selectedMusicIndexes count] == 0 && isPickerDisplayed)
            [self hidePicker];
    }
}

-(void)showPicker
{
    isPickerDisplayed = YES;
    
    if (pickerData && [pickerData count] > 1)
        [pickerPlaylist selectRow:([pickerData count]-2) inComponent:0 animated:YES];

    [pickerContainer setAlpha:1];
    [UIView transitionFromView:miniPlayer toView:pickerContainer duration:0.6 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished)
     {
     }];
}

-(void)hidePicker
{
    isPickerDisplayed = NO;

    [pickerContainer setAlpha:0];
    
    [UIView transitionFromView:pickerContainer toView:miniPlayer duration:0.6 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished)
     {
     }];
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        [self cancelAction:self];
    }
}

#pragma UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerData && [pickerData count] > 0)
        return [pickerData count];
    else
        return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil)
    {
        CGRect frame = CGRectMake(0.0, 0.0, pickerLabel.frame.size.width, 32);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
        if (IS_OS_7_OR_LATER)
            [pickerLabel setTextColor:[UIColor whiteColor]];
        else
            [pickerLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    if (pickerData && [pickerData count] > row)
        [pickerLabel setText:[pickerData objectAtIndex:row]];
    else
        [pickerLabel setText:@""];
    
    return pickerLabel;
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

        if (selectedMusicIndexes && [selectedMusicIndexes containsObject:indexPath])
        {
            [selectedMusicIndexes removeObject:indexPath];
            
            if ([selectedMusicIndexes count] == 0 && isPickerDisplayed)
                [self hidePicker];
        }
        
        for (int index = 0; index < [selectedMusicIndexes count]; index++)
        {
            NSIndexPath *indexPathOfCellSelected = [selectedMusicIndexes objectAtIndex:index];
            
            if (indexPathOfCellSelected.row > indexPath.row)
            {
                NSIndexPath *updatedIndexPath = [NSIndexPath indexPathForRow:indexPathOfCellSelected.row-1 inSection:0];
                
                [selectedMusicIndexes removeObjectAtIndex:index];
                [selectedMusicIndexes insertObject:updatedIndexPath atIndex:index];
            }
        }

        [_tb_list_artist deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [_tb_list_artist reloadSectionIndexTitles];
        
        // Delete Track data on API
        if (trackToDelete && [trackToDelete isKindOfClass:[AWTrackModel class]])
        {
            [super setUpLoadingView:_tb_list_artist];
            [AWTracksManager deleteTrack:trackToDelete cb_rep:^(BOOL success, NSString *error) {
                if (success)
                {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Track deleted !", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
//                    [alert show];
                    if (miniPlayer)
                        [miniPlayer stopTrackInItsPlaying:trackToDelete];
                    [self setFlashMessage:NSLocalizedString(@"Track deleted !", @"")];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:error delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
                    [alert show];
                }
                [super cancelLoadingView:_tb_list_artist];
            }];
        }
        
        // Gore mais c'est pour mettre à jour les indexPath dans les cellules
        [_tb_list_artist reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    PlayerViewController *player = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
    
    // PROD
    if (tableData && [tableData count] > indexPath.row && [[tableData objectAtIndex:indexPath.row]isKindOfClass:[AWTrackModel class]])
    {
        AWTrackModel *track = [tableData objectAtIndex:indexPath.row];
        [AWMusicPlayer getInstance].track = track.iTunesItem;
    }
    // TEST
    else if (tableData && [tableData count] > indexPath.row)
    {
        // List of tracks
        [AWMusicPlayer getInstance].playlist = [[AWItunesImportManager getInstance]getAllItunesMedia];
    }
    
    if (![[AWMusicPlayer getInstance] start])
        [self setFlashMessage:NSLocalizedString(@"Itunes Media failed", @"")];
    else
        [self.navigationController pushViewController:player animated:true];
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
    
    if (selectedMusicIndexes &&[selectedMusicIndexes containsObject:indexPath])
        cell.isAlreadySelected = YES;
    
    cell.displayIcon = YES;
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
            
            if ([alphabetical_indexes containsObject:temp] == false)
                [alphabetical_indexes insertObject:temp atIndex:[alphabetical_indexes count]];
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
    [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];

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
