//
//  UINsSnSubscribeViewController.m
//  NsSn
//
//  Created by adelskott on 27/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "UIAWSubscribeViewController.h"
//#import "NsSnSignManager.h"
//#import "NsSnSignModel.h"
#import "UISiteViewController.h"
//#import "NsSnUserManager.h"
#import "AWUserPostModel.h"
#import "AWUserManager.h"
#import <FacebookSDK/FacebookSDK.h>

@interface UIAWSubscribeViewController ()
- (IBAction)bt_sex_click:(id)sender;
@end

@implementation UIAWSubscribeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = [NSLocalizedString(@"Subscribe", @"") uppercaseString];
    
    [self.lb_title setFont:FONTBOLDSIZE(20)];
    [self.lb_title setText:NSLocalizedString(@"AudioWire", @"")];

    [self.sc_content addSubview:self.v_placeholder];
    self.sc_content.contentSize = self.v_placeholder.frame.size;
    //    [self.v_keyword_tools  renderRelativeSubviewsSetMyContentScrollWithoutParent:NO paddings:nil];
    [self registerForKeyboardNotifications];
    
    self.lb_email.text = NSLocalizedString(@"Email", @"");
    self.lb_firstname.text = NSLocalizedString(@"First name", @"");
    self.lb_lastname.text = NSLocalizedString(@"Last name", @"");
    self.lb_login.text = NSLocalizedString(@"Nickname", @"");
    self.lb_password.text = NSLocalizedString(@"Password", @"");
    self.lb_sex.text = NSLocalizedString(@"Gender", @"");
    
    [self.lb_email setFont:[UIFont fontWithName:@"Futura-Bold" size:12]];
    [self.lb_firstname setFont:[UIFont fontWithName:@"Futura-Bold" size:12]];
    [self.lb_lastname setFont:[UIFont fontWithName:@"Futura-Bold" size:12]];
    [self.lb_login setFont:[UIFont fontWithName:@"Futura-Bold" size:12]];
    [self.lb_password setFont:[UIFont fontWithName:@"Futura-Bold" size:12]];
    [self.lb_sex setFont:[UIFont fontWithName:@"Futura-Bold" size:12]];
    
    [self.lb_cgu setFont:[UIFont fontWithName:@"Futura-Bold" size:12]];
    [self.lb_cgu setText:NSLocalizedString(@"Terms & Conditions", @"")];

    [self.bt_viewCGU.titleLabel setFont:FONTBOLDSIZE(12)];
    [self.bt_viewCGU setTitle:NSLocalizedString(@"Read", @"") forState:UIControlStateNormal];
    
    //    self.tf_password.placeholder = self.lb_password.text;
    //    self.tf_login.placeholder = self.lb_login.text;
    //    self.tf_email.placeholder = self.lb_email.text;
    //    self.tf_lastname.placeholder = self.lb_lastname.text;
    //    self.tf_firstname.placeholder = self.lb_firstname.text;
    
    [self.lb_sex_m setFont:[UIFont fontWithName:@"Futura" size:11]];
    [self.lb_sex_w setFont:[UIFont fontWithName:@"Futura" size:11]];
    
    self.lb_sex_m.text = NSLocalizedString(@"Male", @"");
    self.lb_sex_w.text = NSLocalizedString(@"Female", @"");
    [self.sex_m setSelected:YES];
    [self.sex_w setSelected:NO];
    
    [self.sex_m setBackgroundImage:[UIImage imageNamed:@"non-cocher.png"] forState:UIControlStateNormal];
    [self.sex_m setBackgroundImage:[UIImage imageNamed:@"cocher.png"] forState:UIControlStateSelected];
    [self.sex_w setBackgroundImage:[UIImage imageNamed:@"non-cocher.png"] forState:UIControlStateNormal];
    [self.sex_w setBackgroundImage:[UIImage imageNamed:@"cocher.png"] forState:UIControlStateSelected];

    [self.bt_back setTitle:NSLocalizedString(@"Prev", @"") forState:(UIControlStateNormal)];
    [self.bt_next setTitle:NSLocalizedString(@"Next", @"") forState:(UIControlStateNormal)];
    [self.bt_ok setTitle:NSLocalizedString(@"OK", @"") forState:(UIControlStateNormal)];
    
    [self.bt_login setTitle:NSLocalizedString(@"Login", @"") forState:(UIControlStateNormal)];
    [self.bt_subscribe setTitle:NSLocalizedString(@"Subscribe", @"") forState:(UIControlStateNormal)];
    //[self selectResponder];
    self.v_keyword_tools.alpha = 0.0f;
    
    [self.bt_login setBackgroundImage:[UIImage imageNamed:@"bt-connexion.png"] forState:UIControlStateNormal];
    [self.bt_login setTitle:[NSLocalizedString(@"Connexion", @"") uppercaseString] forState:UIControlStateNormal];
    [self.bt_login.titleLabel setFont:[UIFont fontWithName:@"Futura" size:11]];
    [self.bt_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.bt_subscribe setBackgroundImage:[UIImage imageNamed:@"bt-go.png"] forState:UIControlStateNormal];
    [self.bt_subscribe setTitle:[NSLocalizedString(@"Subscribe", @"") uppercaseString] forState:UIControlStateNormal];
    [self.bt_subscribe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bt_subscribe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.HUD hide:YES];
}

- (IBAction)bt_sex_click:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        int TAG = [(UIButton *)sender tag];
        switch (TAG)
        {
            case 0:
                self.sex_m.selected = YES;
                self.sex_w.selected = NO;
                break;
            case 1:
                self.sex_m.selected = NO;
                self.sex_w.selected = YES;
            default:
                break;
        }
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // [self selectResponder];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    [FBAppEvents logEvent:@"Subscribe"];
}

-(void)removeResponder{
    [self.view resignAllResponder];
    activeField = nil;
    
}
-(void)selectResponder{
    __block BOOL found = NO;
    [self.v_placeholder visiteurView:^(UIView *elt) {
        if ([elt isKindOfClass:[UITextField class]] && !found){
            UITextField *tf = (UITextField *)elt;
            if ([[tf.text trim] length] == 0){
                [elt becomeFirstResponder];
                activeField = tf;
                found = YES;
            }
        }
    } cbAfter:^(UIView *elt) {
        
    } ];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)validate
{
//    NSString *login = [[self.tf_login.text trim] lowercaseString];
    NSString *email = [self.tf_email.text trim];
    NSString *password = [self.tf_password.text trim];
    
    return  /*[login length] >= 4 &&
            [login length] <= 255 &&*/
            [email length] >= 4 &&
            [email length] <= 255 &&
            [password length] >= 4 &&
            [password length] <= 255;
}

- (IBAction)click_subscribe:(id)sender
{
    if (![self validate])
    {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Please Fill all fileds", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
        [a show];
        return ;
    }

    if (!self.bt_cgu.selected)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"You must accept CGU", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:NSLocalizedString(@"Read CGU", @""), nil];
        [alert show];
        return;
    }
    
    [self removeResponder];

    self.bt_subscribe.hidden = YES;
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.HUD setMode:(MBProgressHUDModeIndeterminate)];
    [self.HUD show:YES];
    
    AWUserPostModel *user = [AWUserPostModel new];
    user.email = [self.tf_email.text trim];
    user.password = [self.tf_password.text trim];
    user.password_confirmation = [self.tf_password.text trim];
    
    [[AWUserManager getInstance] subscribe:user cb_rep:^(BOOL success, NSString *error)
    {
        [self.HUD hide:YES];
        self.bt_subscribe.hidden = NO;
        self.HUD = nil;

        if (success)
        {
            self.subscribed = nil;
            self.subscribed = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Congratulations!", @"") message:NSLocalizedString(@"You've created your account within the AudioWire. Now pick up news songs and add it in the player !", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];

            [self.subscribed show];
        }
        else
        {
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:error delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
            [a show];

        }
    }];
    
//    [[NsSnSignManager getInstance] subscribe:s cb_rep:^(BOOL inscription_ok, NSDictionary *rep, NsSnUserErrorValue error)
//    {
//        if (inscription_ok)
//        {
//            NSString *email_user = [self.tf_email.text trim];
//            NSString *password_user = [self.tf_password.text trim];
//            
//            [[NsSnUserManager getInstance] login:email_user passe:password_user cb_rep:^(BOOL ok)
//            {
//                [self.HUD hide:YES];
//                self.bt_subscribe.hidden = NO;
//                self.HUD = nil;
//                
//                if (ok)
//                {
//                    if (!self.subscribed)
//                    {
//                        self.subscribed = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Congratulations!", @"") message:NSLocalizedString(@"You've created your account. Now pick a game and enjoy !", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
//                    }
//                    [self.subscribed show];
//                }
//            }];
//        }
//        else{
//            switch (error)
//            {
//                case NsSnUserErrorValueLoginExist:
//                {
//                    UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Nickname exists", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
//                    [a show];
//                }
//                    break;
//                    
//                case NsSnUserErrorValueEmailExist:
//                {
//                    UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Email exists", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
//                    [a show];
//                }
//                    break;
//
//                case NsSnUserErrorValueEmailError:
//                {
//                    UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Email error", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
//                    [a show];
//                }
//                    break;
//
//                default:
//                {
//                    UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Please Fill all fileds", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
//                    [a show];
//                }
//                break;
//            }
//        }
//    }];
}

#pragma UIAlertViewDelegate to dismiss this controller
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == self.subscribed)
        [self.navigationController dismissViewControllerAnimated:NO completion:^{
        }];
}

- (IBAction)click_login:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickCGUbt:(UIButton *)sender {
    if (sender.tag == 0){
        self.bt_cgu.tag = 1;
        [self.bt_cgu setSelected:YES];
    }
    else{
        self.bt_cgu.tag = 0;
        [self.bt_cgu setSelected:NO];
    }
}

- (IBAction)click_cgu:(id)sender
{
    [self removeResponder];

    self.title = [NSLocalizedString(@"CGU", @"") uppercaseString];

    NSString *url = nil;

    NSString *language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0] substringToIndex:2];

    if ([language isEqualToString:@"fr"])
        url = @"http://www.thefanclub.com/data_externe_iphone/pepsi/cgu_fr.html";
    else
        url = @"http://www.thefanclub.com/data_externe_iphone/pepsi/cgu.html";

    [self.v_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    self.navigationItem.rightBarButtonItem = [self getCloseCGU];
    
    // TODO go to CGU
    [UIView animateWithDuration:0.5 animations:^{
        [self.v_web setAlpha:1.0];
    }];
}

-(void)closeCGU
{
    self.title = [NSLocalizedString(@"Subscribe", @"") uppercaseString];

    self.navigationItem.rightBarButtonItem = nil;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.v_web setAlpha:0.0];
    }];
}

- (IBAction)click_ok:(id)sender {
    [self removeResponder];
    
}

- (IBAction)click_next:(id)sender {
    if (activeField){
        self.bt_next.enabled = YES;
        self.bt_back.enabled = YES;
        __block BOOL found = NO;
        __block BOOL stop = NO;
        [self.v_placeholder visiteurView:^(UIView *elt) {
            if ([elt isKindOfClass:[UITextField class]])
            {
                if (!found)
                {
                    found = (activeField == elt);
                    if (found &&   (activeField == self.tf_password))
                    {
                        [self removeResponder];
                    }
                }
                else
                {
                    if(!stop)
                    {
                        if (activeField == self.tf_login)
                        {
                            [self checkAvailableLogin];
                        }
                        else if (activeField == self.tf_email)
                        {
                            [self checkAvailableEmail];
                        }
                        activeField = (UITextField*)elt;
                        [activeField becomeFirstResponder];
                        [self keyboardWasShown:nil];
                    }
                    stop = YES;
                }
            }
        } cbAfter:^(UIView *elt) {
            
        }];
        if(!stop)
        {
//            self.bt_next.enabled = NO;
        }
    }
}

- (IBAction)click_back:(id)sender {
    if (activeField){
        __block BOOL found = NO;
        __block UITextField *old = nil;
        self.bt_next.enabled = YES;
        self.bt_back.enabled = YES;
        
        [self.v_placeholder visiteurView:^(UIView *elt)
        {
            if ([elt isKindOfClass:[UITextField class]])
            {
                if (!found)
                {
                    found = (activeField == elt);
                    if (found && old)
                    {
                        activeField = (UITextField*)old;
                        [activeField becomeFirstResponder];
                        [self keyboardWasShown:nil];
                    }
                    else if (found && !old)
                    {
                        self.bt_back.enabled = NO;
                    }
                }
                old = (UITextField*)elt;
            }
        } cbAfter:^(UIView *elt) {
            
        }];
    }
}

-(void)checkAvailableLogin
{
//    [self.imAvailableLogin setHidden:YES];
//    
//    NSString *strLogin = [self.tf_login.text trim];
//    if ([strLogin isEqualToString:@""]){
//        [self.imAvailableLogin setHidden:NO];
//        [self.imAvailableLogin setHighlighted:YES];
//        return;
//    }
//    NsSnSignModel *user = [NsSnSignModel new];
//    user.login = strLogin;
//    
//    [self.actLoadLogin startAnimating];
//    UINsSnSubscribeViewController *__weak self_weak = self;
//    [[NsSnSignManager getInstance] loginAvailable:user cb_rep:^(BOOL available) {
//        [self_weak.actLoadLogin stopAnimating];
//        [self_weak.imAvailableLogin setHidden:NO];
//        
//        if (available){
//            [self_weak.imAvailableLogin setHighlighted:NO];
//        }
//        else {
//            [self_weak.imAvailableLogin setHighlighted:YES];
//        }
//    }];
}

-(void)checkAvailableEmail
{
//    [self.imAvailableEmail setHidden:YES];
//    
//    NSString *strEmail = [self.tf_email.text trim];
//    if ([strEmail isEqualToString:@""] || ![NSString validateEmail:strEmail])
//    {
//        [self.imAvailableEmail setHidden:NO];
//        [self.imAvailableEmail setHighlighted:YES];
//        return;
//    }
//    
//    [self.actLoadEmail startAnimating];
//    
//    NsSnSignModel *user = [NsSnSignModel new];
//    user.email = strEmail;
//    
//    UINsSnSubscribeViewController *__weak self_weak = self;
//    [[NsSnSignManager getInstance] emailAvailable:user cb_rep:^(BOOL available) {
//        [self_weak.actLoadEmail stopAnimating];
//        [self_weak.imAvailableEmail setHidden:NO];
//        
//        if (available){
//            [self_weak.imAvailableEmail setHighlighted:NO];
//        }
//        else {
//            [self_weak.imAvailableEmail setHighlighted:YES];
//        }
//    }];
}


#pragma -
- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (aNotification)
    {
        NSDictionary* info = [aNotification userInfo];
        kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        CGRect bkgndRect = self.sc_content.frame;
        bkgndRect.size.height = self.view.frame.size.height - kbSize.height - self.v_keyword_tools.frame.size.height - 44 - 20;
        bkgndRect.origin.y = 20 + 44;
        [self.sc_content setFrame:bkgndRect];
    }

   // UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + self.v_keyword_tools.frame.size.height, 0.0);
//    self.sc_content.contentInset = contentInsets;
//    self.sc_content.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= (kbSize.height - self.v_keyword_tools.frame.size.height);
    
    CGRect r = self.v_keyword_tools.frame;
    r.origin.y = self.view.frame.size.height - kbSize.height - r.size.height;
    self.v_keyword_tools.frame = r;
    self.v_keyword_tools.hidden = NO;
    
    CGPoint ptField = CGPointMake(activeField.superview.frame.origin.x, activeField.superview.frame.origin.y + activeField.superview.frame.size.height + activeField.frame.origin.y + kbSize.height);
    
    if (!CGRectContainsRect(aRect, activeField.superview.frame) || !CGRectContainsPoint(aRect, ptField))
    {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.superview.frame.origin.y);
        NSLog(@"Offset Y => %f", scrollPoint.y);
        
        [self.sc_content setContentOffset:scrollPoint animated:YES];
    }

    self.v_keyword_tools.alpha = 1.f;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.sc_content.contentInset = contentInsets;
    self.sc_content.scrollIndicatorInsets = contentInsets;
    self.v_keyword_tools.hidden = YES;
    
    CGRect rectScreen = self.view.frame;
    rectScreen.size.height = rectScreen.size.height - 20 - 44;
    rectScreen.origin.y = 20 + 44;
    [self.sc_content setFrame:rectScreen];
}

- (IBAction)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)textField{
    activeField = nil;
}

- (IBAction)textFieldTouchOutside:(UITextField *)textField {
    if (textField == self.tf_login){
        [self checkAvailableLogin];
    }
    else if (textField == self.tf_email){
        [self checkAvailableEmail];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *strBt = [alertView buttonTitleAtIndex:buttonIndex];
    if ([strBt isEqualToString:NSLocalizedString(@"Read CGU", @"")]){
        [self click_cgu:nil];
    }
}

-(UIBarButtonItem*)getCloseCGU{
    UIButton *b = [UIButton buttonWithType:(UIButtonTypeCustom)];
    b.frame = CGRectMake(0, 0, 70, 44);
    [b setTitle:NSLocalizedString(@"Close", @"") forState:(UIControlStateNormal)];
    [b.titleLabel setFont:[UIFont fontWithName:@"Futura" size:12]];
    
    [b setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [b addTarget:self action:@selector(closeCGU) forControlEvents:(UIControlEventTouchUpInside)];
    return [[UIBarButtonItem alloc] initWithCustomView:b];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.HUD setMode:(MBProgressHUDModeIndeterminate)];
    [self.HUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.HUD hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
}


@end
