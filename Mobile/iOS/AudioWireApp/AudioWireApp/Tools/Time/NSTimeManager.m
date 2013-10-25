#import "NSTimeManager.h"

@implementation NSTimeManager

+(NSString*)stringFromTime:(int)time withformat:(NSString*)format{
	NSDate *da = [NSDate dateWithTimeIntervalSince1970:time];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:format];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];

// Retrieve Language from iOS
    NSString *language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0] substringToIndex:2];
    if ([language isEqualToString:@"fr"])
    {
        enUSPOSIXLocale = nil;
        enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR_POSIX"];
    }
    [df setLocale:enUSPOSIXLocale];
	NSString *ret = [df stringFromDate:da];
	return ret;
}

+(NSString*)timeAgoInWordsLite:(int)timestamp{
	if (!timestamp){
		return @"";
	}
	NSTimeInterval tinow = [[NSDate date] timeIntervalSince1970];
	NSTimeInterval diff = tinow - timestamp;
	if (diff < 0)
		diff = 0;
	if (diff < 24*60*60){
		NSTimeInterval s = diff / 60;
		if (s >= 1){
			NSTimeInterval m = diff/60;
			if (m > 60){
				NSTimeInterval h = diff/60/60;
				return [NSString stringWithFormat:@"%d%@",(int)h, NSLocalizedString(@"h", @"")];
			}else{
				return [NSString stringWithFormat:@"%d%@",(int)m, NSLocalizedString(@"m", @"")];
			}
		}else
			return [NSString stringWithFormat:@"%d%@",(int)diff, NSLocalizedString(@"s", @"")];
	}
//    else if (diff < 24*60*60*365)
//		return [NSTimeManager stringFromTime:timestamp withformat:@"dd MMM"];
//    else
		return [NSTimeManager stringFromTime:timestamp withformat:@"dd/MM/yy"];
}

+(NSString*)timestampToStrDate:(NSString *)timeStampString _format:(NSString *)format;{
    NSTimeInterval _interval = [timeStampString doubleValue];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    // Retrieve Language from iOS
    NSString *language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0] substringToIndex:2];
    if ([language isEqualToString:@"fr"])
    {
        enUSPOSIXLocale = nil;
        enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR_POSIX"];
    }
    [_formatter setLocale:enUSPOSIXLocale];
    [_formatter setDateFormat:format];
    return [_formatter stringFromDate:date];
}

@end
