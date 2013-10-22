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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super setUpNavLogo];
    [self prepareNavBarForCreatingPlaylist];
    
    // Loading View
    [super setUpLoadingView:_tb_list_artist];

    tableData = [[NSMutableArray alloc]initWithObjects:@"First playlist rock",
                 @"Playlist 2",
                 @"Minimal",
                 @"Electro",
                 @"Psychedelic Trance (Infected Mushroom)",
                 nil];
    
    _tb_list_artist.delegate = self;
    _tb_list_artist.dataSource = self;
    
    _tb_list_artist.sectionIndexBackgroundColor = [UIColor clearColor];
    _tb_list_artist.sectionIndexMinimumDisplayRowCount = MIN_AMOUNT_ARTISTS_TO_DISPLAY_INDEX;
    
    SubPlayer *miniPlayer = [[[NSBundle mainBundle] loadNibNamed:@"SubPlayer" owner:self options:nil] objectAtIndex:0];
    miniPlayer.delegate = self;
    [_viewForMiniPlayer addSubview:miniPlayer];
    [miniPlayer myInit];
    
    // Loading View
    [super cancelLoadingView:_tb_list_artist];
}

- (void)createPlaylist:(id)sender
{
//    [super createPlaylist:sender];
    
    CreatePlaylistViewController *createPlaylist = [[CreatePlaylistViewController alloc] initWithNibName:@"CreatePlaylistViewController" bundle:nil];
    
    UIAudioWireCustomNavigationController *nav = [[UIAudioWireCustomNavigationController alloc] initWithRootViewController:createPlaylist];
    
    nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    nav.navigationBar.translucent = YES;

    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:nav animated:TRUE completion:^{}];
}

-(void)cancelAction:(id)sender
{
    [super cancelAction:sender];
    [self prepareNavBarForCreatingPlaylist];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];

    // Go To Artiste Controller
    MusicsViewController *artist_controller = [[MusicsViewController alloc] initWithNibName:@"MusicsViewController" bundle:nil];
    [self.navigationController pushViewController:artist_controller animated:true];

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
    cell.detailTextLabel.text = @"10 tracks";
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *alphabetical_indexes = [[NSMutableArray alloc] init];

    for (NSString *str in tableData)
    {
        NSString *temp = [str substringWithRange:NSMakeRange(0, 1)];

        if ([alphabetical_indexes containsObject:temp] == false)
            [alphabetical_indexes insertObject:temp atIndex:[alphabetical_indexes count]];
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
