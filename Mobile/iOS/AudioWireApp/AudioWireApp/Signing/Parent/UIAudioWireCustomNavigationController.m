#import "UIAudioWireCustomNavigationController.h"

@implementation UIAudioWireCustomNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            UITextAttributeTextColor: [UIColor whiteColor],
                                                            UITextAttributeFont: FONTBOLDSIZE(18)
                                                            }];
    
    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, 1) forBarMetrics:UIBarMetricsDefault];
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    if (IS_OS_7_OR_LATER)
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    UIFont *fontTest = FONTSIZE(10);
    if ([fontTest.familyName isEqualToString:@"Futura"])
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -2) forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{UITextAttributeTextColor:[UIColor whiteColor],
       UITextAttributeFont:FONTSIZE(13)
       } forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goBack
{
    [self popViewControllerAnimated:TRUE];
}

-(void)goClose
{
	if ([NSThread isMainThread])
            [[[OLGhostAlertView alloc] initWithTitle:@"Go Close !"] show];
    else
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[[OLGhostAlertView alloc] initWithTitle:@"Go Close !"] show];
        });
}

-(UIBarButtonItem*)getCloseButton
{
    UIButton *b = [UIButton buttonWithType:(UIButtonTypeCustom)];
    b.frame = CGRectMake(0, 0, 70, 44);
    [b setTitle:NSLocalizedString(@"Close", @"") forState:(UIControlStateNormal)];
    [b.titleLabel setFont:FONTSIZE(12)];
    
    [b setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [b addTarget:self action:@selector(goClose) forControlEvents:(UIControlEventTouchUpInside)];
    return [[UIBarButtonItem alloc] initWithCustomView:b];
}

-(UIBarButtonItem*)getBackButton
{
    UIButton *b = [UIButton buttonWithType:(UIButtonTypeCustom)];
    b.frame = CGRectMake(0, 0, 30, 44);
    //    [b setTitle:@"<" forState:(UIControlStateNormal)];
    [b setImage:[UIImage imageNamed:@"nav_go_back.png"] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [b addTarget:self action:@selector(goBack) forControlEvents:(UIControlEventTouchUpInside)];
    return [[UIBarButtonItem alloc] initWithCustomView:b];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController.viewControllers count] > 1)
    {
        viewController.navigationItem.leftBarButtonItem = [self getBackButton];
        // viewController.navigationItem.rightBarButtonItem = [self getBackCancel];
    }
    else
    {
        //viewController.navigationItem.rightBarButtonItem = [self getBackCancel];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([navigationController.viewControllers count] > 1)
    {
        viewController.navigationItem.leftBarButtonItem = [self getBackButton];
         //viewController.navigationItem.rightBarButtonItem = [self getCloseButton];
    }
    else
    {
        //viewController.navigationItem.rightBarButtonItem = [self getCloseButton];
    }
}

@end
