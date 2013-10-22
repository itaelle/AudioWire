#import "UIAWLostPasswordViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface UIAWLostPasswordViewController ()
@property (nonatomic, weak) IBOutlet UITextField *tf_email;
@end

@implementation UIAWLostPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self configTextViewsForView:self.view];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
