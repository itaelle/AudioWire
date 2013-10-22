//
//  OLGhostAlertView.h
//
//  Originally created by Radu Dutzan.
//  (c) 2012 Onda.
//

#import <UIKit/UIKit.h>

@interface OLGhostAlertView : UIView

- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title timeout:(NSTimeInterval)timeout;
- (id)initWithTitle:(NSString *)title message:(NSString *)message;
- (id)initWithTitle:(NSString *)title message:(NSString *)message timeout:(NSTimeInterval)timeout dismissible:(BOOL)dismissible;
- (id)initWithTitle:(NSString *)title message:(NSString *)message timeout:(NSTimeInterval)timeout dismissible:(BOOL)dismissible rect:(CGRect)rect;
- (void)show;
- (void)showWithMargin:(CGFloat)theMargin fromBottom:(BOOL)fromBottom;
- (void)hide;
@end
