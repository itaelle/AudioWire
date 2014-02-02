#import <Foundation/Foundation.h>

@interface NSObject (NSObject_Tool)

+ (int) getVerifiedInteger:(id)data;
+ (NSString *) getVerifiedString:(id)data;
+ (BOOL) getVerifiedBool:(id)data;
+ (NSDictionary *) getVerifiedDictionary:(id)data;
+ (NSArray *) getVerifiedArray:(id)data;

@end
