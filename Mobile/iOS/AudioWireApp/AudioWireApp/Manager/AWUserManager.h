#import "AWUserModel.h"

@interface AWUserManager : NSObject

@property (strong, nonatomic) NSString *connectedUserTokenAccess;
@property (strong, nonatomic) NSString *idUser;
@property (strong, nonatomic) AWUserModel *user;

+(AWUserManager*)getInstance;

-(BOOL)isLogin;

-(void)autologin:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)login:(AWUserModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)subscribe:(AWUserModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)updateUser:(AWUserModel *)user_ cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)logOut:(void (^)(BOOL success, NSString *error))cb_rep;

-(void)getAllUsers:(void (^)(NSArray *data, BOOL success, NSString *error))cb_rep;

-(void)getUserConnected:(void (^)(AWUserModel *data, BOOL success, NSString *error))cb_rep;

-(void)sendLostPasswordNotification:(NSString *)email cb_rep:(void (^)(BOOL success, NSString *error))cb_rep;

+(NSString *)pathOfileAutologin;

@end
