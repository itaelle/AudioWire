#import "UISiteViewController.h"

@implementation UISiteViewController

@synthesize HUD;
@synthesize theTitle;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode =  MBProgressHUDModeIndeterminate;
    
    [self getSite];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

-(void) getSite{
    if (self.url){
        self.webView.delegate = self;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        if ([_delegate respondsToSelector:@selector(webViewDidBeginLoad)])
            [_delegate performSelector:@selector(webViewDidBeginLoad) withObject:nil];
    }
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)_webview shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                  target:self
                                                selector:@selector(checkNavigationStatus)
                                                userInfo:nil
                                                 repeats:YES];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [HUD show:YES];
    if ([_delegate respondsToSelector:@selector(webViewDidStartLoad:)])
        [_delegate performSelector:@selector(webViewDidStartLoad:) withObject:webView];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [HUD hide:YES];
    if ([_delegate respondsToSelector:@selector(webViewDidEndLoad:)])
        [_delegate performSelector:@selector(webViewDidEndLoad:) withObject:webView];
}

-(void)checkNavigationStatus{
    if ([_delegate respondsToSelector:@selector(gestionOfButtons)])
        [_delegate performSelector:@selector(gestionOfButtons)];
}

- (void)goBack{
    
}

- (void)goForward{
    
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
    [self.webView stopLoading];
    [self.webView setDelegate:nil];
}



@end
