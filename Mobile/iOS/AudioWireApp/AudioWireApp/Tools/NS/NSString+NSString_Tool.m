#import "NSString+NSString_Tool.h"
#import <CommonCrypto/CommonDigest.h>
#import <zlib.h>

@implementation NSString (NSString_Tool)

-(NSString *) md5
{
	const char *cStr = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString
			
			stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			
			result[0], result[1],
			
			result[2], result[3],
			
			result[4], result[5],
			
			result[6], result[7],
			
			result[8], result[9],
			
			result[10], result[11],
			
			result[12], result[13],
			
			result[14], result[15]
			
			];
	
}

-(NSString*) sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;
}

-(BOOL) isSubString:(NSString*) search{
	if (!search)
		return  FALSE;
	NSRange r = [self rangeOfString:search];
	return r.length>0;
}
-(NSInteger) indexOfSubString:(NSString*) search{
	if (!search)
		return -1;
	NSRange r = [self rangeOfString:search];
	return r.location;
}

- (NSString*)strReplace:(NSString*)r to:(NSString*)t{
	NSMutableString *str = [NSMutableString stringWithString:self];
	[ str replaceOccurrencesOfString:r
						  withString:t
							 options:0
							   range:NSMakeRange(0, [str length])
	 ];
	return str;
}

-(NSString*)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSArray*)explode:(NSString*)sep{
	NSArray *words = [self componentsSeparatedByString:sep];
	return words;
}

+(BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

@end

