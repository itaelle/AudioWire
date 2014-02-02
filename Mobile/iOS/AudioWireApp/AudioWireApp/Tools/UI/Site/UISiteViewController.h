#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@protocol UISiteViewDelegate <NSObject>

@optional

- (void) webViewDidEndLoad:(UIWebView *)webView;
- (void) webViewDidStartLoad:(UIWebView *)webView;
- (void) webViewDidBeginLoad:(UIWebView *)webView;

-(void)gestionOfButtons;

@end


@interface UISiteViewController : UIViewController <UIWebViewDelegate>{
    NSTimer *_timer;
}

@property (strong, nonatomic) NSString *url;
@property (nonatomic, strong) NSString *theTitle;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (weak, nonatomic) id<UISiteViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIWebView *webView;


-(void) getSite;

@end
