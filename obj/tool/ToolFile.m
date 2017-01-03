//
//  ToolFile.m
//  DialProject
//
//  Created by 班车陌路 on 2016/12/31.
//  Copyright © 2016年 jcd. All rights reserved.
//

#import "ToolFile.h"

@implementation ToolFile

#pragma mark 判断是否保存本机号码
+ (void) judgeSaveTellIsShow:(BOOL) ret block:(void(^)(BOOL ret))block{
    NSString *tell = [KSUSERDEFAULT objectForKey:SAVE_SELF_TELL];
    if (!tell||[tell isEqualToString:@""]) block(false);
    else block(true);
}

@end
