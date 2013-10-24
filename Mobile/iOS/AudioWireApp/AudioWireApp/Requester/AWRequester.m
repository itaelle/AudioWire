//
//  AWRequester.m
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/22/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import "AWRequester.h"

@implementation AWRequester

+(void)customRequestAudiowireAPI:(NSString *)url_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_
{
    AFHTTPRequestOperationManager *afNetworkingManager = [AFHTTPRequestOperationManager manager];
    
    NSURL* urlToRequester = [NSURL URLWithString:url_];
    NSLog(@"URL => %@", urlToRequester);
    
    NSMutableURLRequest * pocRequest = [[NSMutableURLRequest alloc] initWithURL:urlToRequester];
    [pocRequest setTimeoutInterval:60];
    [pocRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [pocRequest setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *afNetworkingOperation = [afNetworkingManager HTTPRequestOperationWithRequest:pocRequest success:^(AFHTTPRequestOperation *operation, id responseObject)
                                                     {
                                                         NSLog(@"RESPONSE => %@", responseObject);
                                                         cb_rep_(responseObject, true);
                                                         
                                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                                     {
                                                         NSLog(@"ERROR => %@", error);
                                                         NSLog(@"ERROR OBJECT => %@", [operation.responseObject description]);
                                                         
                                                         if (operation.responseObject)
                                                             cb_rep_(operation.responseObject, true);
                                                         else
                                                             cb_rep_([error userInfo], false);

                                                     }];
    [afNetworkingManager.operationQueue addOperation:afNetworkingOperation];
}

+(void)requestAudiowireAPIGET:(NSString *)url_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_
{
    AFHTTPRequestOperationManager *afNetworkingManager = [AFHTTPRequestOperationManager manager];
    
    NSURL* urlToRequester = [NSURL URLWithString:url_];
    NSLog(@"URL => %@", urlToRequester);
    
    
    [afNetworkingManager GET:url_ parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"RESPONSE => %@", responseObject);
        cb_rep_(responseObject, true);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"ERROR => %@", error);
        NSLog(@"ERROR OBJECT => %@", [operation.responseObject description]);
        
        if (operation.responseObject)
            cb_rep_(operation.responseObject, true);
        else
            cb_rep_([error userInfo], false);
    }];
}

+(void)requestAudiowireAPIPOST:(NSString *)url_ param:(NSDictionary *)parameters_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_
{
    AFHTTPRequestOperationManager *afNetworkingManager = [AFHTTPRequestOperationManager manager];
    
    NSURL* urlToRequester = [NSURL URLWithString:url_];
    NSLog(@"URL => %@", urlToRequester);
    
    [afNetworkingManager POST:url_ parameters:parameters_ success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"RESPONSE => %@", responseObject);
        cb_rep_(responseObject, true);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {

        NSLog(@"ERROR => %@", error);
        NSLog(@"ERROR OBJECT => %@", [operation.responseObject description]);

        if (operation.responseObject)
            cb_rep_(operation.responseObject, true);
        else
            cb_rep_([error userInfo], false);
    }];
}

+(void)requestAudiowireAPIDELETE:(NSString *)url_ param:(NSDictionary *)parameters_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_
{
    AFHTTPRequestOperationManager *afNetworkingManager = [AFHTTPRequestOperationManager manager];
    
    NSURL* urlToRequester = [NSURL URLWithString:url_];
    NSLog(@"URL => %@", urlToRequester);
    
    [afNetworkingManager DELETE:url_ parameters:parameters_ success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"RESPONSE => %@", responseObject);
         cb_rep_(responseObject, true);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR => %@", error);
        NSLog(@"ERROR OBJECT => %@", [operation.responseObject description]);
         
         if (operation.responseObject)
             cb_rep_(operation.responseObject, true);
         else
             cb_rep_([error userInfo], false);
     }];
}

+(void)requestAudiowireAPIPUT:(NSString *)url_ param:(NSDictionary *)parameters_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_
{
    AFHTTPRequestOperationManager *afNetworkingManager = [AFHTTPRequestOperationManager manager];
    
    NSURL* urlToRequester = [NSURL URLWithString:url_];
    NSLog(@"URL => %@", urlToRequester);
    
    [afNetworkingManager PUT:url_ parameters:parameters_ success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"RESPONSE => %@", responseObject);
         cb_rep_(responseObject, true);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"ERROR => %@", error);
        NSLog(@"ERROR OBJECT => %@", [operation.responseObject description]);
         
         if (operation.responseObject)
             cb_rep_(operation.responseObject, true);
         else
             cb_rep_([error userInfo], false);
     }];
}


@end
