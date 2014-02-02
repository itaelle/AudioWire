#import "AWMasterModel.h"

@interface AWUserModel : AWMasterModel

@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *friend_id;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;

-(NSDictionary *)toDictionaryLogin;
+(AWUserModel *)fromJSON:(NSDictionary *)data;
+(NSArray *)arrayOfEmail:(NSArray *)friendsModels;

@end
