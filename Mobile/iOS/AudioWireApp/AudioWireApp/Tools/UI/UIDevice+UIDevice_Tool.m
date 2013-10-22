@implementation UIDevice (UIDevice_Tool)

+(BOOL)isIPAD
{
	NSString * model = [[UIDevice currentDevice] model];
	return [model isSubString:@"iPad"];
}

+(BOOL)isOrientationPortrait
{
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortraitUpsideDown)
        return YES;
    return NO;
}

+(CGRect)getScreenFrame
{
	return CGRectMake([UIScreen mainScreen].bounds.origin.x, [UIScreen mainScreen].bounds.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

+(BOOL) isIphone5
{
    return [UIDevice getScreenFrame].size.height == 568 ? YES : NO;
}

@end
