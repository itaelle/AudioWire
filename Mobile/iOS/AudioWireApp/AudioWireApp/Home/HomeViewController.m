#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIImage.h>
#import "PlaylistViewController.h"
#import "ContactViewController.h"
#import "LibraryViewController.h"
#import "PlayerViewController.h"
#import "HomeViewController.h"
#import "SubPlayer.h"
#import "OptionsViewController.h"
#import "AWImportViewController.h"
#import "UIView+UIView_Tool.h"
#import "AWUserManager.h"

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Home", @"");
        firstTime = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prepareNavBarForImport];
    [self prepareNavBarForRemote];
    
    self.skipAuth = YES;
    
    if (![[AWUserManager getInstance] isLogin])
    {
        [[AWUserManager getInstance] autologin:^(BOOL success, NSString *error)
         {
             if (success)
             {
                 [self setFlashMessage:NSLocalizedString(@"Connected !", @"") timeout:1];
             }
         }];
    }
    
    [self setUpViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!IS_OS_7_OR_LATER && firstTime)
    {
        CGRect rectLogo = self.headView.frame;
        rectLogo.origin.y -= 64;
        [self.headView setFrame:rectLogo];
        
        CGRect rectMiddleView = self.middleView.frame;
        rectMiddleView.origin.y -= 64;
        rectMiddleView.size.height += 50;
        [self.middleView setFrame:rectMiddleView];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    clickLogoCount = 0;
    [self firstWaveAnimation];
}

- (void)importAction:(id)sender
{
    AWImportViewController *importerVC = [[AWImportViewController alloc] initWithNibName:@"AWImportViewController" bundle:nil];
    
    UIAudioWireCustomNavigationController *nav = [[UIAudioWireCustomNavigationController alloc] initWithRootViewController:importerVC];
    
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
}

-(void)specialWaveAnimation
{
    [UIView transitionWithView:_libraryButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [_libraryButton setAlpha:0];
    } completion:^(BOOL finished) {
        if (finished)
        { }
    }];
    
    [UIView transitionWithView:_thirdButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [_thirdButton setAlpha:0];
    } completion:^(BOOL finished) {
        if (finished)
        { }
    }];
    
    
    [UIView transitionWithView:_chatButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [_chatButton setAlpha:0];
    } completion:^(BOOL finished) {
        if (finished)
        { }
    }];
    
    [UIView transitionWithView:_optionButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [_optionButton setAlpha:0];
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self.special_button setAlpha:1];
            [self.special_button bouingAppear:TRUE oncomplete:^{
                
            }];
        }
    }];
}

-(void)specialWaveAnimationBackToNormal
{
    [_libraryButton setAlpha:0];
    [_thirdButton setAlpha:0];
    [_chatButton setAlpha:0];
    [_optionButton setAlpha:0];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.special_button setAlpha:0];
    } completion:^(BOOL finished)
    {
        [UIView transitionWithView:_libraryButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [_libraryButton setAlpha:1];
        } completion:^(BOOL finished) {
            if (finished)
            { }
        }];
        
        [UIView transitionWithView:_thirdButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            [_thirdButton setAlpha:1];
        } completion:^(BOOL finished) {
            if (finished)
            { }
        }];
        
        [UIView transitionWithView:_chatButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            [_chatButton setAlpha:1];
        } completion:^(BOOL finished) {
            if (finished)
            { }
        }];
        
        [UIView transitionWithView:_optionButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            [_optionButton setAlpha:1];
        } completion:^(BOOL finished) {
            if (finished)
            { }
        }];
    }];
}

-(void)secondWaveAnimation
{
    CGRect libraryRect = _libraryButton.frame;
    CGRect optionRect = _optionButton.frame;
    CGRect thirdRect = _thirdButton.frame;
    CGRect chatRect = _chatButton.frame;
    
    [UIView animateWithDuration:0.4 animations:^{
        [_optionButton setFrame:libraryRect];
        [_libraryButton setFrame:optionRect];
        
        [_thirdButton setFrame:chatRect];
        [_chatButton setFrame:thirdRect];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)firstWaveAnimation
{
    if (firstTime)
    {
        [self.headView setAlpha:1];
        [self.headView bouingAppear:TRUE oncomplete:^{
            
        }];
    }
    
    [_optionButton setAlpha:1];
    [UIView transitionWithView:_optionButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
    } completion:^(BOOL finished)
     {
         [_thirdButton setAlpha:1];
         [UIView transitionWithView:_thirdButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
             
         } completion:^(BOOL finished)
          {
              [_chatButton setAlpha:1];
              [UIView transitionWithView:_chatButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                  
              } completion:^(BOOL finished)
               {
                   [_libraryButton setAlpha:1];
                   [UIView transitionWithView:_libraryButton duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                       
                   } completion:^(BOOL finished)
                   {
                       if (firstTime)
                           [self secondWaveAnimation];
                       firstTime = NO;
                   }];
               }];
          }];
     }];
}

- (void) setUpViews
{
    [self.headView setAlpha:0];
    [self setUpMiddleView];
    
    [_playingView addSubview:miniPlayer];
}

-(void) setUpMiddleView
{
    [_special_button setBackgroundImage:[UIImage imageNamed:@"funny_monkey.jpg"] forState:UIControlStateNormal];

    if (!IS_OS_7_OR_LATER)
    {
        CGRect rectSpecialButton = self.special_button.frame;
        rectSpecialButton.size.width -= 100;
        rectSpecialButton.origin.x += 50;
        [self.special_button setFrame:rectSpecialButton];
    }
    
    [_libraryButton setTitle:NSLocalizedString(@"Library", @"Library") forState:UIControlStateNormal];
    [_chatButton setTitle:NSLocalizedString(@"Friends", @"Friends") forState:UIControlStateNormal];
    [_thirdButton setTitle:NSLocalizedString(@"Playlists", @"Playlists") forState:UIControlStateNormal];
    [_optionButton setTitle:NSLocalizedString(@"Options", @"Options") forState:UIControlStateNormal];
    
    [_libraryButton.titleLabel setFont:FONTBOLDSIZE(14)];
    [_chatButton.titleLabel setFont:FONTBOLDSIZE(14)];
    [_thirdButton.titleLabel setFont:FONTBOLDSIZE(14)];
    [_optionButton.titleLabel setFont:FONTBOLDSIZE(14)];
    
    UIImage * tempLibrary = [UIImage imageWithColor:[UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1]];
    UIImage * tempChat = [UIImage imageWithColor:[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1]];
    UIImage * tempThird = [UIImage imageWithColor:[UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1]];
    UIImage * tempOption = [UIImage imageWithColor:[UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1]];
    
    [_libraryButton setBackgroundImage:tempLibrary forState:UIControlStateNormal];
    [_chatButton setBackgroundImage:tempChat forState:UIControlStateNormal];
    [_thirdButton setBackgroundImage:tempThird forState:UIControlStateNormal];
    [_optionButton setBackgroundImage:tempOption forState:UIControlStateNormal];

    [_special_button setAlpha:0];
    [_libraryButton setAlpha:0];
    [_chatButton setAlpha:0];
    [_thirdButton setAlpha:0];
    [_optionButton setAlpha:0];
    
    CGRect libraryRect = _libraryButton.frame;
    CGRect optionRect = _optionButton.frame;
    CGRect thirdRect = _thirdButton.frame;
    CGRect chatRect = _chatButton.frame;
    
    [_optionButton setFrame:libraryRect];
    [_libraryButton setFrame:optionRect];
    
    [_thirdButton setFrame:chatRect];
    [_chatButton setFrame:thirdRect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)clickBtLibrary:(id)sender
{
    LibraryViewController *library = [[LibraryViewController alloc] initWithNibName:@"LibraryViewController" bundle:nil];
    [self.navigationController pushViewController:library animated:true];
}

- (IBAction)clickBtThird:(id)sender
{
    PlaylistViewController *playlist =  [[PlaylistViewController alloc] initWithNibName:@"PlaylistViewController" bundle:nil];
    [self.navigationController pushViewController:playlist animated:true];
}

- (IBAction)clickBtContact:(id)sender
{
    ContactViewController *contact = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
    [self.navigationController pushViewController:contact animated:true];
}

- (IBAction)clickBtOption:(id)sender
{
    OptionsViewController *temp = [[OptionsViewController alloc] initWithNibName:@"OptionsViewController" bundle:nil];
    [self.navigationController pushViewController:temp animated:true];
}

- (IBAction)clickLogoTop:(id)sender
{
    clickLogoCount += 1;
    if (clickLogoCount == DEFINE_TIMES_TO_CLICK_LOGO)
    {
        clickLogoCount = 0;
        
        [self.btLogo highlight:^{
            
        }];
        [self specialWaveAnimation];
        return ;
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hell Yeah !"
                                                    message:@"You found that trick :)"
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        [message show];
    }
}

- (IBAction)clickSpecialButtonBack:(id)sender
{
    [self specialWaveAnimationBackToNormal];
}

@end
