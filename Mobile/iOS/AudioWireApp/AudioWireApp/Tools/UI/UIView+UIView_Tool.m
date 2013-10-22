#import "UIView+UIView_Tool.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (UIView_Tool)

-(void)bouingAppear:(BOOL)appear oncomplete:(void (^)(void))oncomplete{
	if (!appear){
		self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1.0);
		CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
		bounceAnimation.values = [NSArray arrayWithObjects:
								  [NSNumber numberWithFloat:1.0],
								  [NSNumber numberWithFloat:0.8],
								  [NSNumber numberWithFloat:1.1],
								  [NSNumber numberWithFloat:0.3], nil];
		bounceAnimation.duration = 0.5;
		bounceAnimation.removedOnCompletion = NO;
		[self.layer addAnimation:bounceAnimation forKey:@"bounce"];
		self.layer.transform = CATransform3DIdentity;
		
		[UIView animateWithDuration:0.6 animations:^{
			self.alpha = 0.0;
		} completion:^(BOOL finished) {
            if (oncomplete){
                oncomplete();
            }
		}];
		return;
	}
	self.alpha = 0;
	[UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
        if (oncomplete){
            oncomplete();
        }
    }];
	self.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	bounceAnimation.values = [NSArray arrayWithObjects:
							  [NSNumber numberWithFloat:0.3],
							  [NSNumber numberWithFloat:1.1],
							  [NSNumber numberWithFloat:0.8],
							  [NSNumber numberWithFloat:1.0], nil];
	bounceAnimation.duration = 0.5;
	bounceAnimation.removedOnCompletion = NO;
	[self.layer addAnimation:bounceAnimation forKey:@"bounce"];
	self.layer.transform = CATransform3DIdentity;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0ul);
    dispatch_async(queue, ^{
        usleep(bounceAnimation.duration *1000);
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (oncomplete){
                oncomplete();
            }
        });
    });
    
}

-(void)highlight:(void (^)(void))oncomplete
{
 	self.alpha = 0;
    
	[UIView animateWithDuration:0.7 animations:^{
		self.alpha = 1;
	} completion:^(BOOL finished) {
		if (!finished) return ;
		[UIView animateWithDuration:0.7 animations:^{
			self.alpha = 0.2;
		} completion:^(BOOL finished) {
			if (!finished) return ;
			[UIView animateWithDuration:0.7 animations:^{
				self.alpha = 1;
			} completion:^(BOOL finished) {
				if (!finished) return ;
				[UIView animateWithDuration:0.7 animations:^{
					self.alpha = 0.5;
				} completion:^(BOOL finished) {
					if (!finished) return ;
					[UIView animateWithDuration:0.7 animations:^{
						self.alpha = 1;
					} completion:^(BOOL finished) {
						if (!finished) return ;
						oncomplete();
					}];
				}];
			}];
		}];
	}];
}

-(void)visiteurView:(void(^)(UIView *elt))cbBefore cbAfter:(void(^)(UIView *elt))cbAfter
{
    if(!cbAfter && !cbBefore)
        return;
    if (cbBefore)
        cbBefore(self);
    
    for (id elt in [self subviews])
        [elt visiteurView:cbBefore cbAfter:cbAfter];
    
    if (cbAfter)
        cbAfter(self);
}

-(void) resignAllResponder
{
    [self visiteurView:^(UIView *elt)
    {
        if ([elt isFirstResponder])
            [elt resignFirstResponder];
    } cbAfter:^(UIView *elt)
    {
        
    }];
}

@end

@implementation UIImage (JTColor)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end