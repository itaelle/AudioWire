#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AWRequester : NSObject

+(void)customRequestAudiowireAPI:(NSString *)url_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_;

+(void)requestAudiowireAPIGET:(NSString *)url_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_;

+(void)requestAudiowireAPIPOST:(NSString *)url_ param:(NSDictionary *)parameters_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_;

+(void)requestAudiowireAPIDELETE:(NSString *)url_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_;

+(void)requestAudiowireAPIPUT:(NSString *)url_ param:(NSDictionary *)parameters_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_;

@end
