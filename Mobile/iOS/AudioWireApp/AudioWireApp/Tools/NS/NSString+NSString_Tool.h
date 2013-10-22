#import <Foundation/Foundation.h>

@interface NSString (NSString_Tool)


-(NSString *) md5;
-(NSString *) sha1;

-(BOOL) isSubString:(NSString*) search;
-(NSInteger) indexOfSubString:(NSString*) search;
-(NSString*) strReplace:(NSString*)r to:(NSString*)t;

-(NSString*) trim;
-(NSArray*) explode:(NSString*)sep;

+(BOOL)validateEmail:(NSString *)candidate;

@end
