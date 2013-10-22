//
//  UIView+UIView_Tool.h
//  Extends
//
//  Created by bigmac on 25/09/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIView_Tool)

-(void)bouingAppear:(BOOL)appear oncomplete:(void (^)(void))oncomplete;
-(void)visiteurView:(void(^)(UIView *elt))cbBefore cbAfter:(void(^)(UIView *elt))cbAfter;
-(void)highlight:(void (^)(void))oncomplete;
-(void) resignAllResponder;

@end

@interface UIImage (UIImage_Tool)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end