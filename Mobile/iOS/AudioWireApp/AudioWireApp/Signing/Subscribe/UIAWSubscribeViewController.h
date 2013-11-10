//
//  UINsSnSubscribeViewController.h
//  NsSn
//
//  Created by adelskott on 27/08/13.
//  Copyright (c) 2013 Adelskott. All rights reserved.
//

#import "MBProgressHUD.h"

@interface UIAWSubscribeViewController : UIViewController <UIAlertViewDelegate, UIWebViewDelegate>{
    UITextField *activeField;
    CGSize kbSize;
}

@property (weak, nonatomic) IBOutlet UIScrollView *sc_content;
@property (strong, nonatomic) IBOutlet UIView *v_placeholder;

@property (weak, nonatomic) IBOutlet UIWebView *v_web;

@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIButton *bt_subscribe;
@property (weak, nonatomic) IBOutlet UIButton *bt_login;
@property (weak, nonatomic) IBOutlet UILabel *lb_sex;
@property (weak, nonatomic) IBOutlet UILabel *lb_email;
@property (weak, nonatomic) IBOutlet UILabel *lb_password;
@property (weak, nonatomic) IBOutlet UILabel *lb_login;
@property (weak, nonatomic) IBOutlet UILabel *lb_firstname;
@property (weak, nonatomic) IBOutlet UILabel *lb_lastname;

@property (weak, nonatomic) IBOutlet UITextField *tf_email;
@property (weak, nonatomic) IBOutlet UITextField *tf_password;
@property (weak, nonatomic) IBOutlet UITextField *tf_login;
@property (weak, nonatomic) IBOutlet UITextField *tf_firstname;
@property (weak, nonatomic) IBOutlet UITextField *tf_lastname;

@property (nonatomic, weak) IBOutlet UIButton *sex_m;
@property (nonatomic, weak) IBOutlet UIButton *sex_w;
@property (nonatomic, weak) IBOutlet UILabel *lb_sex_m;
@property (nonatomic, weak) IBOutlet UILabel *lb_sex_w;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actLoadLogin;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actLoadEmail;

@property (weak, nonatomic) IBOutlet UIButton *bt_cgu;
@property (weak, nonatomic) IBOutlet UILabel *lb_cgu;
@property (weak, nonatomic) IBOutlet UIButton *bt_viewCGU;

@property (nonatomic, strong) UIAlertView *subscribed;
@property (nonatomic, strong) MBProgressHUD *HUD;

@property (weak, nonatomic) IBOutlet UIView *v_keyword_tools;
@property (weak, nonatomic) IBOutlet UIButton *bt_back;
@property (weak, nonatomic) IBOutlet UIButton *bt_next;
@property (weak, nonatomic) IBOutlet UIButton *bt_ok;

- (IBAction)click_ok:(id)sender;
- (IBAction)click_next:(id)sender;
- (IBAction)click_back:(id)sender;
- (IBAction)click_subscribe:(id)sender;
- (IBAction)click_login:(id)sender;
- (IBAction)clickCGUbt:(UIButton *)sender;
- (IBAction)click_cgu:(id)sender;
- (void)selectResponder;

@end
