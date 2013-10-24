//
//  AWRequester.h
//  AudioWireApp
//
//  Created by Derivery Guillaume on 10/22/13.
//  Copyright (c) 2013 Derivery Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AWRequester : NSObject

+(void)customRequestAudiowireAPI:(NSString *)url_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_;

+(void)requestAudiowireAPIGET:(NSString *)url_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_;

+(void)requestAudiowireAPIPOST:(NSString *)url_ param:(NSDictionary *)parameters_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_;

+(void)requestAudiowireAPIDELETE:(NSString *)url_ param:(NSDictionary *)parameters_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_;

+(void)requestAudiowireAPIPUT:(NSString *)url_ param:(NSDictionary *)parameters_ cb_rep:(void(^)(NSDictionary *rep, BOOL success))cb_rep_;

@end
