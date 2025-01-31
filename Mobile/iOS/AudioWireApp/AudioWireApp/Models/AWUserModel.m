#import "AWUserModel.h"
#import "NSObject+NSObject_Tool.h"

@implementation AWUserModel

-(NSDictionary *)toDictionary
{
    return @{@"email" : self.email,
             @"password" : self.password,
             @"username" : self.username,
             @"first_name" : self.firstName,
             @"last_name" : self.lastName,
             };
}

+(NSArray *)arrayOfEmail:(NSArray *)friendsModels
{
    NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[friendsModels count]];
    for (id object in friendsModels)
    {
        if (object && [object isKindOfClass:[AWUserModel class]])
            [ret addObject:((AWUserModel *)object).email];
    }
    return ret;
}

-(NSDictionary *)toDictionaryLogin
{
    return @{@"email" : self.email,
             @"password" : self.password};
}

+(AWUserModel *) fromJSON:(NSDictionary*)data
{
    AWUserModel *userModel = [AWUserModel new];
    
    if (data && [data isKindOfClass:[NSDictionary class]])
    {
        userModel.password = [NSObject getVerifiedString:[data objectForKey:@"password"]];
        userModel.username = [NSObject getVerifiedString:[data objectForKey:@"username"]];
        userModel.lastName = [NSObject getVerifiedString:[data objectForKey:@"last_name"]];
        userModel.firstName = [NSObject getVerifiedString:[data objectForKey:@"first_name"]];
        userModel.email = [NSObject getVerifiedString:[data objectForKey:@"email"]];
        userModel._id = [NSObject getVerifiedString:[data objectForKey:@"id"]];
        
        if ([data objectForKey:@"friend_id"] != nil)
        {
            userModel.friend_id = [NSObject getVerifiedString:[data objectForKey:@"id"]];
        }
    }
    return userModel;
}

+(NSArray *) fromJSONArray:(NSArray*)data
{
    NSArray *a = [NSObject getVerifiedArray:data];
    
    __block NSMutableArray *ret = [[NSMutableArray alloc] initWithCapacity:[a count]];
    for (id object in a)
    {
        [ret addObject:[AWUserModel fromJSON:object]];
    }
    return ret;
}

@end
