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
#import "ArtistViewController.h"

@implementation ArtistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        self.title = NSLocalizedString(@"Tracks", @"Tracks");

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Loading View
    [super setUpLoadingView:_tb_list_artist];

    tableData = [NSArray arrayWithObjects:@"AC/DC",
                 @"Edith Piaf",
                 @"Electro Dance Party Electro Dance Party",
                 @"Gipsy KingElectro Dan",
                 @"Infected Mushroom",
                 @"Jacques Prévert",
                 @"Justin Bieber",
                 @"Kamini",
                 @"Lorie",
                 @"Manau",
                 @"Song 1",
                 @"Song 2"
                 @"Nostradamus",
                 @"NTM",
                 @"Ozone",
                 @"PitBull",
                 @"Piwies",
                 @"Rolling Stones",
                 @"System of a down",
                 @"Taylor Swift",
                 @"U",
                 @"V",
                 nil];
    
    _tb_list_artist.delegate = self;
    _tb_list_artist.dataSource = self;

    SubPlayer *miniPlayer = [[[NSBundle mainBundle] loadNibNamed:@"SubPlayer" owner:self options:nil] objectAtIndex:0];
    [_viewForMiniPlayer addSubview:miniPlayer];
    [miniPlayer myInit];
    
    // Loading View
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
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CellTrack" owner:self options:nil] objectAtIndex:0];
        
    }

    [cell myInit:[tableData objectAtIndex:indexPath.row] details:@"Listed in : Playlist Rock"];
    
    return cell;
    return cell;
}

@end
