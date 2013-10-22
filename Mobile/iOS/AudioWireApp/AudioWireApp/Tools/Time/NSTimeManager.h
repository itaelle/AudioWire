//
//  NSTimeManager.h
//  Tfcv3
//
//  Created by bigmac on 08/10/12.
//  Copyright (c) 2012 Jean Alexandre Iragne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimeManager : NSObject

+(NSString*)stringFromTime:(int)time withformat:(NSString*)format;

+(NSString*)timeAgoInWordsLite:(int)timestamp;
+(NSString*)timestampToStrDate:(NSString *)timeStampString _format:(NSString *)format;

@end
