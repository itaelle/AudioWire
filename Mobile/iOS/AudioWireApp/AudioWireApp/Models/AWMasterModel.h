#import <Foundation/Foundation.h>

@interface AWMasterModel : NSObject

-(NSDictionary *)toDictionary;
+(AWMasterModel *) fromJSON:(NSDictionary*)data;
+(NSArray *) fromJSONArray:(NSArray*)data;

@end
