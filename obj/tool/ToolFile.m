//
//  ToolFile.m
//  DialProject
//
//  Created by 班车陌路 on 2016/12/31.
//  Copyright © 2016年 jcd. All rights reserved.
//

#import "ToolFile.h"
#import "FDAlertView.h"
#import "InputTellView.h"

@implementation ToolFile

#pragma mark 判断是否保存本机号码
+ (void) judgeSaveTellIsShow:(BOOL) ret block:(void(^)())block{
    NSString *tell = [KSUSERDEFAULT objectForKey:SAVE_SELF_TELL];
    if (tell&&![tell isEqualToString:@""]) {
        block();
    }
    else {
        if (ret) {
            InputTellView *contentView = [[NSBundle mainBundle] loadNibNamed:@"InputTellView" owner:nil options:nil].lastObject;
            FDAlertView *alert = [[FDAlertView alloc] init];
            alert.contentView = contentView;
            [alert show];
            
            contentView.width = KSCREENW-80;
            contentView.x = 40;
            contentView.selector = ^(BOOL ret, NSString * tell){
                if (ret) {
                    [KSUSERDEFAULT setObject:tell forKey:SAVE_SELF_TELL];
                    [KSUSERDEFAULT synchronize];
                    block();
                }
            };
        }
    }
}

@end
