//
//  ToolFile.h
//  DialProject
//
//  Created by 班车陌路 on 2016/12/31.
//  Copyright © 2016年 jcd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolFile : NSObject

#pragma mark 判断是否保存本机号码
+ (void) judgeSaveTellIsShow:(BOOL) ret block:(void(^)(BOOL ret))block;

@end
