#import "UIAWSubscribeViewController.h"
#import "UISiteViewController.h"
#import "AWUserModel.h"
#import "AWUserManager.h"
#import <FacebookSDK/FacebookSDK.h>

@interface UIAWSubscribeViewController ()
- (IBAction)bt_sex_click:(id)sender;
@end

@implementation UIAWSubscribeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"Subscribe", @"");
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!IS_OS_7_OR_LATER)
    {
        [self.sc_content setContentInset:UIEdgeInsetsMake(-64, 0, 0, 0)];
    }
    else
    {
        self.sc_content.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.sc_content addSubview:self.v_placeholder];
    self.sc_content.contentSize = self.v_placeholder.frame.size;

    [self registerForKeyboardNotifications];
    
    self.lb_title.text = NSLocalizedString(@"AudioWire", @"");
    self.lb_email.text = NSLocalizedString(@"Email", @"");
    self.lb_firstname.text = NSLocalizedString(@"First name", @"");
    self.lb_lastname.text = NSLocalizedString(@"Last name", @"");
    self.lb_login.text = NSLocalizedString(@"Nickname", @"");
    self.lb_password.text = NSLocalizedString(@"Password", @"");
    self.lb_sex.text = NSLocalizedString(@"Gender", @"");
    self.lb_sex_m.text = NSLocalizedString(@"Male", @"");
    self.lb_sex_w.text = NSLocalizedString(@"Female", @"");
    self.lb_cgu.text = NSLocalizedString(@"Terms & Conditions", @"");
    
    [self.bt_viewCGU setTitle:NSLocalizedString(@"Read", @"") forState:UIControlStateNormal];
    [self.bt_back setTitle:NSLocalizedString(@"Prev", @"") forState:(UIControlStateNormal)];
    [self.bt_next setTitle:NSLocalizedString(@"Next", @"") forState:(UIControlStateNormal)];
    [self.bt_ok setTitle:NSLocalizedString(@"OK", @"") forState:(UIControlStateNormal)];
    [self.bt_login setTitle:NSLocalizedString(@"Login", @"") forState:(UIControlStateNormal)];
    [self.bt_subscribe setTitle:NSLocalizedString(@"Subscribe", @"") forState:(UIControlStateNormal)];
    [self.bt_login setTitle:[NSLocalizedString(@"Connexion", @"") uppercaseString] forState:UIControlStateNormal];
    [self.bt_subscribe setTitle:[NSLocalizedString(@"Subscribe", @"") uppercaseString] forState:UIControlStateNormal];
    
    [self.lb_email setFont:FONTBOLDSIZE(12)];
    [self.lb_firstname setFont:FONTBOLDSIZE(12)];
    [self.lb_lastname setFont:FONTBOLDSIZE(12)];
    [self.lb_login setFont:FONTBOLDSIZE(12)];
    [self.lb_password setFont:FONTBOLDSIZE(12)];
    [self.lb_sex setFont:FONTBOLDSIZE(12)];
    [self.lb_cgu setFont:FONTBOLDSIZE(12)];
    [self.lb_title setFont:FONTBOLDSIZE(20)];
    [self.bt_login.titleLabel setFont:FONTSIZE(11)];
    [self.bt_viewCGU.titleLabel setFont:FONTBOLDSIZE(12)];

    [self.lb_sex_m setFont:FONTSIZE(11)];
    [self.lb_sex_w setFont:FONTSIZE(11)];
    [self.sex_m setSelected:YES];
    [self.sex_w setSelected:NO];
    
    [self.sex_m setBackgroundImage:[UIImage imageNamed:@"non-cocher.png"] forState:UIControlStateNormal];
    [self.sex_m setBackgroundImage:[UIImage imageNamed:@"cocher.png"] forState:UIControlStateSelected];
    [self.sex_w setBackgroundImage:[UIImage imageNamed:@"non-cocher.png"] forState:UIControlStateNormal];
    [self.sex_w setBackgroundImage:[UIImage imageNamed:@"cocher.png"] forState:UIControlStateSelected];
    [self.bt_login setBackgroundImage:[UIImage imageNamed:@"bt-connexion.png"] forState:UIControlStateNormal];
    [self.bt_subscribe setBackgroundImage:[UIImage imageNamed:@"bt-go.png"] forState:UIControlStateNormal];
    
    self.v_keyword_tools.alpha = 0.0f;
    
    [self.bt_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bt_subscribe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bt_subscribe setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.HUD hide:YES];
    
    if (self.requireLogin == NO)
        [self prepareNavBarForClose];
}

-(void)closeAction:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:true completion:^{
        
    }];
}

-(void) prepareNavBarForClose
{
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];
    
    if (IS_OS_7_OR_LATER)
        closeButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = closeButton;
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
    NSString *login = [self.tf_login.text trim];
    NSString *email = [self.tf_email.text trim];
    NSString *password = [self.tf_password.text trim];
    
    return  [login length] >= 4 &&
            [login length] <= 255 &&
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
    
    AWUserModel *user = [AWUserModel new];
    user.email = [self.tf_email.text trim];
    user.password = [[self.tf_password.text trim] md5];
    user.username = [self.tf_login.text trim];
    user.firstName = [self.tf_firstname.text trim];
    user.lastName = [self.tf_lastname.text trim];
    
    [[AWUserManager getInstance] subscribe:user cb_rep:^(BOOL success, NSString *error)
    {
        [self.HUD hide:YES];
        self.bt_subscribe.hidden = NO;
        self.HUD = nil;

        if (success)
        {
            self.subscribed = nil;
            self.subscribed = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Congratulations!", @"") message:NSLocalizedString(@"You've created your account within the AudioWire. Now enjoy the features of our brain new music player !", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];

            [self.subscribed show];
        }
        else
        {
            UIAlertView *a = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:error delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles: nil];
            [a show];

        }
    }];
}

#pragma UIAlertViewDelegate to dismiss this controller
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == self.subscribed)
        [self.navigationController dismissViewControllerAnimated:TRUE completion:^{
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
        if (IS_OS_7_OR_LATER)
        {
            bkgndRect.size.height = self.view.frame.size.height - kbSize.height - self.v_keyword_tools.frame.size.height /*- 44 - 20*/;
            bkgndRect.origin.y = 0 /*20 + 44*/;
        }
        else
        {
            bkgndRect.size.height = self.view.frame.size.height - kbSize.height - self.v_keyword_tools.frame.size.height;
            bkgndRect.origin.y = 0;
        }
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
        CGPoint scrollPoint;
        
        if (IS_OS_7_OR_LATER)
            scrollPoint = CGPointMake(0.0, activeField.superview.frame.origin.y - ((20 + 44)*2));
        else
            scrollPoint = CGPointMake(0.0, activeField.superview.frame.origin.y - 20 - 44);
        
        NSLog(@"Offset Y => %f", scrollPoint.y);
        
        [self.sc_content setContentOffset:scrollPoint animated:YES];
    }

    self.v_keyword_tools.alpha = 1.f;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    self.sc_content.contentInset = contentInsets;
//    self.sc_content.scrollIndicatorInsets = contentInsets;
    self.v_keyword_tools.hidden = YES;
    
    CGRect rectScreen = self.view.frame;
    
    if (IS_OS_7_OR_LATER)
    {
        rectScreen.size.height = rectScreen.size.height /*- 20 - 44*/;
        rectScreen.origin.y = 0/*20 + 44*/;
    }
    else
    {
        rectScreen.size.height = rectScreen.size.height;
        rectScreen.origin.y = 0;
    }
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

-(UIBarButtonItem*)getCloseCGU
{
    UIButton *b = [UIButton buttonWithType:(UIButtonTypeCustom)];
    b.frame = CGRectMake(0, 0, 70, 44);
    [b setTitle:NSLocalizedString(@"Close", @"") forState:(UIControlStateNormal)];
    [b.titleLabel setFont:FONTSIZE(13)];
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
