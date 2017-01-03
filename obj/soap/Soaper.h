//
//  WebserviceConnector.h
//  HelloThread
//
//  Created by 720QSJ on 15/1/21.
//  Copyright (c) 2015年 Master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"


@interface Soaper : NSObject


+ (void) setup:(NSString*) domain;
+ (void) connectUrl:(NSString*)url Method:(NSString*)method Param:(NSDictionary*)param Success:(void(^)(NSDictionary* rawDic, NSString *rawStr))success Error:(void(^)(NSString* errMsg, NSString* rawStr))error;
+ (void) connectTimeout:(int)timeout Url:(NSString*)url Method:(NSString*)method Param:(NSDictionary*)param Success:(void(^)(NSDictionary* rawDic, NSString *rawStr))success Error:(void(^)(NSString* errMsg, NSString* rawStr))error;

@end
