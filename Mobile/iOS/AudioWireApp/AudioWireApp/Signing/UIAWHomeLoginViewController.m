//
//  UINsSnHomeLoginViewController.m
//  NsSn
//
//  Created by adelskott on 27/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIAWHomeLoginViewController.h"
#import "UIAWSubscribeViewController.h"
#import "UIAWLostPasswordViewController.h"
//#import "NsSnUserManager.h"
//#import "NsSnSignManager.h"
#import "AWUserManager.h"

#define TOPLOGO_TAG 10001

@implementation UIAWHomeLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        charAtTheEndOfNickname = 1;
        self.isSignedOut = NO;
    }
    return self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    UIImageView *topLogo= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-inter"]];
//    [topLogo setFrame:(CGRect){143,5,35,35}];
//    [topLogo setTag:TOPLOGO_TAG];
//    [self.navigationController.navigationBar addSubview:topLogo];
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    BOOL boolVal = [prefs boolForKey:@"show_tuto"];
//    if (!boolVal){
//        [self showTuto];
//    }

    [self.sc_scroll setContentSize:CGSizeMake(self.sc_scroll.frame.size.width, 568)];

    if (!IS_OS_7_OR_LATER)
    {
        [self.sc_scroll setContentInset:UIEdgeInsetsMake(-64, 0, 0, 0)];
        self.sc_scroll.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else
    {
        self.sc_scroll.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [FBAppEvents logEvent:@"Login"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSLocalizedString(@"Login", @"") uppercaseString];
        
//    [self configTextViewsForView:self.view];
    
    [self.lb_title setFont:FONTBOLDSIZE(18)];
    [self.lb_title setText:NSLocalizedString(@"Audio\nWire", @"")];
    self.lb_or.text = [NSLocalizedString(@"Or", @"") uppercaseString];
    
    self.lb_email.text = NSLocalizedString(@"Email", @"");
    [self.lb_email setFont:[UIFont fontWithName:@"Futura-Bold" size:12]];

    self.lb_password.text = NSLocalizedString(@"Password", @"");
    [self.lb_password setFont:[UIFont fontWithName:@"Futura-Bold" size:12]];
    
    [self.bt_lostPassword setTitle:NSLocalizedString(@"Lost password ?", @"") forState:(UIControlStateNormal)];
    [self.bt_lostPassword.titleLabel setFont:[UIFont fontWithName:@"Futura" size:10]];

    [self.bt_login setTitle:[NSLocalizedString(@"Go", @"") uppercaseString] forState:(UIControlStateNormal)];
    [self.bt_login.titleLabel setFont:[UIFont fontWithName:@"Futura-Bold" size:15]];

    [self.bt_subscribe setTitle:[NSLocalizedString(@"Subscribe", @"") uppercaseString] forState:(UIControlStateNormal)];
    [self.bt_subscribe.titleLabel setFont:[UIFont fontWithName:@"Futura-Bold" size:15]];
    
    [self.bt_help setTitle:NSLocalizedString(@"Unable to connect to your account", @"") forState:(UIControlStateNormal)];

    // Facebook Connect
/*    theLoginView = [[FBLoginView alloc] initWithReadPermissions:@[@"email"]];
    [self.v_buttonFacebook addSubview:theLoginView];
    [self.v_buttonFacebook setHidden:NO];
    theLoginView.delegate = self;*/
//    [self setWordingToFacebookButton:theLoginView];
}
/*
////////////////////////////////////////////////////////////////////////////////
/// Facebook
////////////////////////////////////////////////////////////////////////////////
-(void)uploadAvatarFromFB
{
    imageViewAvatarDL = [[UIImageViewJA alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];

    [imageViewAvatarDL loadImageFromURL:urlAvatarFacebook ttl:60*60 endblock:^(UIImageViewJA *image)
    {
        [[NsSnUserManager getInstance] uploadAvatar:image.image cb_send:^(long long total, long long current) {
             
         } cb_rep:^(NSDictionary *rep, NsSnUserErrorValue error) {
             
             [[NSLEUserManager getInstance] updateUser:^(NSLEUserModel *user, NSLEUserErrorValue error, BOOL cache) {
                 
                 if (user)
                 {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"updateInfosUserChanged" object:nil userInfo:@{@"user":user}];
                 }
             }];
         }];
    }];
}

-(void)tryToLogin:(NsSnSignModel *)userModel uploadAvatar:(BOOL)uploadAvatar_
{
    [[NsSnUserManager getInstance] login:userModel.email passe:userModel.password cb_rep:^(BOOL ok)
     {
         if (ok)
         {
             if (uploadAvatar_)
                 [self uploadAvatarFromFB];
             [self.navigationController dismissViewControllerAnimated:NO completion:^{}];
         }
         else
         {
             [self manageLogin:userModel];
         }
     }];
}

-(void)manageLogin:(NsSnSignModel *)userModel
{
    NSString *login_ = userModel.login;
    
    [self checkAvailableLogin:login_ cb_rep:^(BOOL available)
     {
         if (available)
         {
             [self tryToSubscribe:userModel];
         }
         else
         {
             userModel.login = [login_ stringByAppendingString:[NSString stringWithFormat:@"%d", charAtTheEndOfNickname]];
             charAtTheEndOfNickname++;
             [self manageLogin:userModel];
         }
     }];
}

-(void)tryToSubscribe:(NsSnSignModel *)signModel
{
    [[NsSnSignManager getInstance] subscribe:signModel cb_rep:^(BOOL inscription_ok, NSDictionary *rep, NsSnUserErrorValue error)
     {
         if (inscription_ok)
         {
             [self tryToLogin:signModel uploadAvatar:TRUE];
         }
         else
         {
             switch (error)
             {
                 case NsSnUserErrorValueLoginExist:
                 {
                     UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Nickname exists", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
                     [a show];
                 }
                     break;
                     
                 case NsSnUserErrorValueEmailExist:
                 {
                     UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Email exists", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
                     [a show];
                 }
                     break;
                     
                 case NsSnUserErrorValueEmailError:
                 {
                     UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Email error", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
                     [a show];
                 }
                     break;
                     
                 default:
                 {
                     UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Please Fill all fileds", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
                     [a show];
                 }
                     break;
             }
         }
     }];
}

-(void)checkAvailableLogin:(NSString *)login cb_rep:(void (^)(BOOL available))cb_rep
{
    NsSnSignModel *user = [NsSnSignModel new];
    user.login = login;
    
    [[NsSnSignManager getInstance] loginAvailable:user cb_rep:^(BOOL available)
    {
        cb_rep(available);
    }];
}


-(void)setWordingToFacebookButton:(FBLoginView*)fbView_
{
    for (id obj in fbView_.subviews)
    {
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel *lb_login_fb =  obj;
            lb_login_fb.text = NSLocalizedString(@"Connect with Facebook", @"");
        }
    }
}
*/
#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"UIConnexionCanalView : loginViewShowingLoggedInUser");
    //[self setWordingToFacebookButton:loginView];
    
    [self.act_facebook setHidden:NO];
    [self.act_facebook startAnimating];
    [self.v_buttonFacebook setHidden:YES];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"UIConnexionCanalView : loginViewFetchedUserInfo => %@", [user description]);
    //[self setWordingToFacebookButton:loginView];
    
    [self.act_facebook setHidden:NO];
    [self.act_facebook startAnimating];
    [self.v_buttonFacebook setHidden:YES];
    
    
    urlAvatarFacebook = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=%d&height=%d", [user id], 300, 300];
    
    NSString *mail_user = nil;
    NSString *id_user = nil;
    
    if (user.id)
        id_user = [user.id sha1];
    
    if ([user objectForKey:@"email"])
        mail_user = [NSString stringWithFormat:@"%@%@", PREFIX_MAIL_FB, [user objectForKey:@"email"]];
    
    AWUserModel *userAWModel = [AWUserModel new];
    userAWModel.email = mail_user;
    userAWModel.password = id_user;
    
    [[AWUserManager getInstance] login:userAWModel cb_rep:^(BOOL success, NSString *error)
     {
         [self.HUD hide:YES];
         self.HUD = nil;
         self.bt_login.hidden = NO;
         
         if (success)
         {
             [self.navigationController dismissViewControllerAnimated:true completion:^{
             }];
         }
         else
         {
             [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:error delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil] show];
         }
     }];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"UIConnexionCanalView : loginViewShowingLoggedOutUser");
    //[self setWordingToFacebookButton:loginView];
    [self.act_facebook stopAnimating];
    [self.v_buttonFacebook setHidden:NO];
    
    self.isSignedOut = NO;
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error
{
    NSLog(@"UIConnexionCanalView : handleAuthError => %@", error);
    //[self setWordingToFacebookButton:loginView];
    [self.act_facebook stopAnimating];
    [self.act_facebook setHidden:YES];
    [self.v_buttonFacebook setHidden:NO];
    
    NSString *alertMessage, *alertTitle;

    if (error.fberrorShouldNotifyUser)
    {
        // If the SDK has a message for the user, surface it.
        alertTitle = @"Something Went Wrong";
        alertMessage = error.fberrorUserMessage;
        NSLog(@"fberrorShouldNotifyUser : %@", alertMessage);
    }
    else if (error.fberrorCategory == FBErrorCategoryUserCancelled)
    {
        // The user has cancelled a login. You can inspect the error
        // for more context. For this sample, we will simply ignore it.
        NSLog(@"user cancelled login");
        return;
    }
    else
    {
        // For simplicity, this sample treats other errors blindly.
        alertTitle  = @"Unknown Error";
        alertMessage = @"Error. Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Football App ne parvient pas à vous authentifier sur Facebook. Merci de bien vouloir effacer le compte Facebook enregistré dans les réglages de votre iPhone, puis retentez de vous connecter depuis cet onglet.", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alert show];
}
////////////////////////////////////////////////////////////////////////

//-(void)showTuto{
//    self.title = [NSLocalizedString(@"Welcome", @"") uppercaseString];
//    
//    self.tutoMasterView = [[PLGTutoViewController alloc] initWithNibName:@"PLGTutoViewController" bundle:nil];
//    self.tutoMasterView.delegate = self;
//    [self.view addSubviewToBonce:self.tutoMasterView.view autoSizing:YES];
//    [self.tutoMasterView loadDatas];
//}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    for (UIView *sv in self.navigationController.navigationBar.subviews)
    {
        if ([sv tag]==TOPLOGO_TAG)
            [sv removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectResponder{
    if ([[self.tf_email.text trim] length] == 0)
        [self.tf_email becomeFirstResponder];
    else
        [self.tf_password becomeFirstResponder];
}

- (IBAction)startEditing:(UITextField *)sender
{
    int height_view = [UIDevice getScreenFrame].size.height;
    if (!IS_OS_7_OR_LATER)
        height_view = [UIDevice getScreenFrame].size.height - 44;
    
    [self.sc_scroll setFrame:CGRectMake(self.sc_scroll.frame.origin.x, self.sc_scroll.frame.origin.y, self.sc_scroll.frame.size.width, height_view - KEYBOARD_WIDTH)];

    CGPoint pt;
    if (IS_OS_7_OR_LATER)
        pt = CGPointMake(0.0, sender.superview.frame.origin.y - ((20 + 44)*2));
    else
        pt = CGPointMake(0.0, sender.superview.frame.origin.y - 20 - 44);
    
    [self.sc_scroll setContentOffset:pt animated:NO];
}

- (IBAction)endEditing:(id)sender
{
    int height_view = [UIDevice getScreenFrame].size.height;
    if (!IS_OS_7_OR_LATER)
        height_view = [UIDevice getScreenFrame].size.height - 44;
    
    [self.sc_scroll setFrame:CGRectMake(self.sc_scroll.frame.origin.x, self.sc_scroll.frame.origin.y, self.sc_scroll.frame.size.width, height_view)];
}

-(BOOL)validate
{
    NSString *p = [self.tf_password.text trim];
    NSString *e = [self.tf_email.text trim];
    return [e length] >= 4 && [p length] >= 4 && [e length] <= 255 && [p length] <= 255;
}

- (IBAction)click_subscribe:(id)sender
{
//    [self.sc_scroll setFrame:CGRectMake(self.sc_scroll.frame.origin.x, self.sc_scroll.frame.origin.y, self.sc_scroll.frame.size.width, [UIDevice isIphone5] ? 469 : 469 - 20 /*Status*/ - 44 /*NavBar*/)];
    [self endEditing:self.tf_email];
    
    if ([self.tf_email isFirstResponder])
        [self.tf_email resignFirstResponder];

    if ([self.tf_password isFirstResponder])
        [self.tf_password resignFirstResponder];

    UIAWSubscribeViewController *vc = [[UIAWSubscribeViewController alloc] initWithNibName:@"UIAWSubscribeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)click_login:(id)sender
{
 //   [self.sc_scroll setFrame:CGRectMake(self.sc_scroll.frame.origin.x, self.sc_scroll.frame.origin.y, self.sc_scroll.frame.size.width, [UIDevice isIphone5] ? 469 : 469 - 20 /*Status*/ - 44 /*NavBar*/)];
    [self.view resignAllResponder];
    
    NSString *email = [self.tf_email.text trim];
    if (![NSString validateEmail:email])
    {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Please check your e-mail", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
        [a show];
        [self.tf_email becomeFirstResponder];
        return ;
    }
    
    if ([self validate])
    {
        self.bt_login.hidden = YES;
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.HUD setMode:(MBProgressHUDModeIndeterminate)];
        [self.HUD show:YES];
        NSString *p = [self.tf_password.text trim];
        NSString *e = [self.tf_email.text trim];
        
        AWUserModel *user = [AWUserModel new];
        user.email = e;
        user.password = p;
        
        [[AWUserManager getInstance] login:user cb_rep:^(BOOL success, NSString *error)
        {
            [self.HUD hide:YES];
            self.HUD = nil;
            self.bt_login.hidden = NO;
            
           if (success)
           {
               [self.navigationController dismissViewControllerAnimated:true completion:^{
               }];
           }
            else
            {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:error delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil] show];
            }
        }];
    }
    else
    {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Please fill all fileds correctly !", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
        [a show];
        [self selectResponder];
    }
}

- (IBAction)click_lostPassword:(id)sender
{
    UIAWLostPasswordViewController *vc = [[UIAWLostPasswordViewController alloc] initWithNibName:@"UIAWLostPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
