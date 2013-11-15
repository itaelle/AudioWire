//
//  AWImportViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/28/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWImportViewController.h"
#import "AWItunesImportManager.h"

@implementation AWImportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"iTunes import", @"");
        needASubPlayer = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareNavBarForClose];
    [self prepareNavBarForEditing:YES];

    [self.bt_import setTitle:NSLocalizedString(@"Start import", @"") forState:UIControlStateNormal];
    [self.bt_import.titleLabel setFont:FONTBOLDSIZE(15)];
    
    if (IS_OS_7_OR_LATER)
        self.tb_content_import.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    [self setUpList];
    [self getItunesMedia];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)editAction:(id)sender
{
    [self.tb_content_import setEditing:TRUE animated:TRUE];
    [self.tb_content_import reloadSectionIndexTitles];
    [self prepareNavBarForCancel:TRUE];
}

-(void)cancelAction:(id)sender
{
    [self.tb_content_import setEditing:FALSE animated:TRUE];
    [self.tb_content_import reloadSectionIndexTitles];
    [self prepareNavBarForEditing:TRUE];
}

-(void)setUpList
{
    [self.tb_content_import setDelegate:self];
    [self.tb_content_import setDataSource:self];
    self.tb_content_import.sectionIndexColor = [UIColor whiteColor];
    if (IS_OS_7_OR_LATER)
        self.tb_content_import.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tb_content_import.sectionIndexMinimumDisplayRowCount = MIN_AMOUNT_ARTISTS_TO_DISPLAY_INDEX;
}

-(void)getItunesMedia
{
    [self setUpLoadingView:self.tb_content_import];
    data = [[[AWItunesImportManager getInstance] getItunesMediaAndIgnoreAlreadyImportedOnes] mutableCopy];
    [self.tb_content_import reloadData];
    [self cancelLoadingView:self.tb_content_import];
    
    if (data && [data count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"It seems that you didn't add new file into your iTunes library since the last time you made an import. To get new tracks inside your AudioWire library, please synchronise your iTunes first :)", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)click_import:(id)sender
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.act_import startAnimating];
        [self.act_import setAlpha:1];
        [self.bt_import setAlpha:0];
    }];
    
    [[AWItunesImportManager getInstance] integrateMediaInAWLibrary:data cb_rep:^(bool success, NSString *error)
    {
        if (success)
        {
            [self setFlashMessage:NSLocalizedString(@"All your iTunes Music has been imported in AudioWire !", @"") timeout:1];
            [self performSelector:@selector(closeAction:) withObject:self afterDelay:0.5];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:error delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
            [alert show];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.act_import stopAnimating];
            [self.act_import setAlpha:0];
            [self.bt_import setAlpha:1];
        }];
    }];
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
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (data && [data count] > indexPath.row)
        {
            [data removeObjectAtIndex:indexPath.row];
            [self.tb_content_import deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
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
    
    id selectedRowModel = [data objectAtIndex:indexPath.row];
    
    if (selectedRowModel && [selectedRowModel isKindOfClass:[MPMediaItem class]])
    {
        cell.textLabel.text = [((MPMediaItem *)selectedRowModel) valueForProperty:MPMediaItemPropertyTitle];
        
        NSString *artist = [((MPMediaItem *)selectedRowModel) valueForProperty:MPMediaItemPropertyArtist];
        
        NSString *albumArtist = [((MPMediaItem *)selectedRowModel) valueForProperty:MPMediaItemPropertyAlbumArtist];
        
        NSString *albumTitle = [((MPMediaItem *)selectedRowModel) valueForProperty:MPMediaItemPropertyAlbumTitle];
        
        if ((artist && ![artist isEqualToString:@"(null)"]) &&
            (albumTitle && ![albumTitle isEqualToString:@"(null)"]))
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", artist, albumTitle];
        else if ((albumArtist && ![albumArtist isEqualToString:@"(null)"]) &&
            (albumTitle && ![albumTitle isEqualToString:@"(null)"]))
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", albumArtist, albumTitle];
        else if (albumTitle && ![albumArtist isEqualToString:@"(null)"])
            cell.detailTextLabel.text = albumTitle;
        else
            cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *alphabetical_indexes = [[NSMutableArray alloc] init];
    
    for (MPMediaItem *mediaItem in data)
    {
        NSString *title = [mediaItem valueForProperty:MPMediaItemPropertyTitle];
        if (mediaItem &&  title && [title length] > 0)
        {
            NSString *temp = [title substringWithRange:NSMakeRange(0, 1)];
            
            if ([alphabetical_indexes containsObject:temp] == false)
                [alphabetical_indexes insertObject:temp atIndex:[alphabetical_indexes count]];
        }
    }
    if (tableView.isEditing)
        return nil;
    return alphabetical_indexes;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger newRow = [self indexForFirstChar:title inArray:data];
    
    // NSLog(@"Index to scroll to : %u", newRow);
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
    [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    return index;
}

- (NSInteger)indexForFirstChar:(NSString *)character inArray:(NSArray *)array
{
    NSUInteger count = 0;
    for (MPMediaItem *mediaItem in array)
    {
        if (mediaItem && [mediaItem isKindOfClass:[MPMediaItem class]])
        {
            if ([[mediaItem valueForProperty:MPMediaItemPropertyTitle] hasPrefix:character])
                return count;
        }
        count++;
    }
    return 0;
}

@end
