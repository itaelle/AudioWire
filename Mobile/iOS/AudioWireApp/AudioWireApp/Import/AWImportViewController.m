//
//  AWImportViewController.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/28/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWImportViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AWImportViewController ()

@end

@implementation AWImportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Import from iTunes", @"");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareNavBarForClose];
    
    [self getItunesMedia];
}

-(void)getItunesMedia
{
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    
    NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [everything items];
    for (MPMediaItem *song in itemsFromGenericQuery)
    {
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        NSLog (@"%@", songTitle);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
