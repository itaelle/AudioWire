#import "MusicsViewController.h"
#import "SubPlayer.h"
#import "PlaylistViewController.h"
#import "CreatePlaylistViewController.h"
#import "NSObject+NSObject_Tool.h"
#import "AWPlaylistManager.h"
#import "AWPlaylistSynchronizer.h"
#import "AWUserManager.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.requireLogin = NO;
    self.isSynchronizing = NO;
    showOffLineMessageFunctionning = NO;
    firstTime = YES;
    
    [self setUpNavLogo];
    [self prepareNavBarForEditing];
    
    if (IS_OS_7_OR_LATER)
        self.tb_list_artist.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    [_viewForMiniPlayer addSubview:miniPlayer];
    
    [self setUpList];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.skipAuth = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedIn) name:@"loggedIn" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closedLogin) name:@"closedLogin" object:nil];
    
    if ([[AWUserManager getInstance] isLogin] && !self.isSynchronizing)
        [self loggedIn];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (showOffLineMessageFunctionning)
    {
        NSString *msg = NSLocalizedString(@"You choose to manage your playlists offline, all the changes will be synchornized later!", @"");

        [self setFlashMessage:msg];
        showOffLineMessageFunctionning = NO;
    }
}

#pragma NOTIFICATION from Signing

-(void)closedLogin
{
    showOffLineMessageFunctionning = YES;
}

-(void)loggedIn
{
    if ([AWPlaylistSynchronizer isThereSomethingToSynchronize])
    {
        self.isSynchronizing = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"You have some playlists that need to be synchronized. Do you want to launch it now ?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Yes", @"") otherButtonTitles:NSLocalizedString(@"No", @""), nil];
        alert.tag = 4242;
        [alert show];
    }
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.tag != 4242)
        return ;

    if (buttonIndex == alertView.cancelButtonIndex)
    {
        [self setFlashMessage:NSLocalizedString(@"Syncing ...", @"")];
        [self setUpLoadingView:self.tb_list_artist];
        
        __weak PlaylistViewController *weak_self = self;
        
        [AWPlaylistSynchronizer runPlaylistSync:^(BOOL success, NSString *error)
        {
            weak_self.isSynchronizing = NO;
            if (success)
            {
                [weak_self setFlashMessage:NSLocalizedString(@"Syncing is done!", @"")];
                [weak_self loadData];
            }
            else
            {
                [weak_self setFlashMessage:error];
                [weak_self cancelLoadingView:self.tb_list_artist];
            }
        }];
    }
    else
        self.isSynchronizing = NO;
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

-(void) loadData // LoadData appelé que quand je me suis connecté || quand le skipAuth = YES
{
    if (self.isSynchronizing)
        return ;
    
    [self setUpLoadingView:_tb_list_artist];
    NSLog(@"LoadData playlist");
    
    [AWPlaylistManager getAllPlaylists:^(NSArray *data, BOOL success, NSString *error)
    {
        if (tableData)
            [tableData removeAllObjects];
        tableData = nil;
        tableData = [NSMutableArray arrayWithArray:data];

        if (tableData && [tableData count] == 0)
            [self prepareNavBarForAdding];
        else
            [self prepareNavBarForEditing];
            
        if (success)
        {
            [_tb_list_artist reloadData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:error delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
            [alert show];
        }
        [self cancelLoadingView:_tb_list_artist];
    }];
}

- (void)addPlaylist
{
    [self deleteSelectedPlaylist];

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
    
    if (tableData && [tableData count] > 0)
        [self cancelAction:self];
}

-(void)editAction:(id)sender
{
    if (tableData)
    {
        AWPlaylistModel *modelForAdding = [AWPlaylistModel new];
        [tableData insertObject:modelForAdding atIndex:0];
        //        [_tb_list_artist reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        [_tb_list_artist reloadData];
    }
    [_tb_list_artist setEditing:TRUE animated:TRUE];
    [_tb_list_artist reloadSectionIndexTitles];
    [self prepareNavBarForCancel];
}

- (void)addAction:(id)sender
{
    [self addPlaylist];
}

-(void)cancelAction:(id)sender
{
    [_tb_list_artist setEditing:FALSE animated:TRUE];
    [self prepareNavBarForEditing];

    if (tableData)
    {
        [tableData removeObjectAtIndex:0];
        [_tb_list_artist reloadData];
        [self deleteSelectedPlaylist];
    }
}

-(void)deleteSelectedPlaylist
{
    if (playlistToDelete && [playlistToDelete count] > 0)
    {
        [self setUpLoadingView:_tb_list_artist];
        
        [AWPlaylistManager deletePlaylists:playlistToDelete cb_rep:^(BOOL success, NSString *details)
         {
             [self cancelLoadingView:_tb_list_artist];
             [playlistToDelete removeAllObjects];
             
             if (success)
             {
                 [self setFlashMessage:NSLocalizedString(@"Playlist has been deleted!", @"") timeout:1];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:details delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
                 [alert show];
             }
             
             if (tableData && [tableData count] == 0)
                 [self prepareNavBarForAdding];
         }];
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
        
        [cell.textLabel setFont:FONTBOLDSIZE(17)];
        [cell.detailTextLabel setFont:FONTSIZE(13)];
    }
    
    id selectedRowModel = [tableData objectAtIndex:indexPath.row];
    if (selectedRowModel && [selectedRowModel isKindOfClass:[AWPlaylistModel class]])
    {
        cell.textLabel.text = ((AWPlaylistModel *)selectedRowModel).title;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", ((AWPlaylistModel *)selectedRowModel).nb_tracks];
    }
    
    if ([tableView isEditing])
    {
        if (indexPath && indexPath.row == 0)
        {
            cell.textLabel.text = NSLocalizedString(@"New playlist", @"");
            cell.detailTextLabel.text = @"";
        }
    }
    
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
            
            if ([alphabetical_indexes containsObject:[temp capitalizedString]] == false)
                [alphabetical_indexes insertObject:[temp capitalizedString] atIndex:[alphabetical_indexes count]];
        }
    }
    if (tableView.isEditing)
        return nil;
    else
        return alphabetical_indexes;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger newRow = [self indexForFirstChar:title inArray:tableData];

   // NSLog(@"Index to scroll to : %u", newRow);

    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
    [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:TRUE];

    return index;
}

- (NSInteger)indexForFirstChar:(NSString *)character inArray:(NSArray *)array
{
    NSUInteger count = 0;
    for (AWPlaylistModel *playlist in array)
    {
        if (playlist && [playlist isKindOfClass:[AWPlaylistModel class]])
        {
            if ([playlist.title hasPrefix:character])
                return count;
        }
        count++;
    }
    return 0;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
