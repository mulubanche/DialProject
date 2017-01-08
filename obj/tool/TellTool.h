//
//  TellTool.h
//  DialProject
//
//  Created by 班车陌路 on 2017/1/7.
//  Copyright © 2017年 jcd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>

@interface TellTool : NSObject

+ (TellTool *) shareTool;
-(void)detectCall;

@end
