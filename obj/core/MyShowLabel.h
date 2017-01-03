//
//  MyShowLabel.h
//  YiJingTong
//
//  Created by 中科创奇 on 15/4/3.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  黑色背景  白色文字的 提醒视图
 */
@interface MyShowLabel : UILabel

+ (MyShowLabel *)shareShowLabel;

/**
 *  提示的文字
 *
 *  @param text     文字
 *  @param position 如果是1 在屏幕中间显示 如果是0 在屏幕下方显示
 */
- (void)setText:(NSString *)text position:(int)position;

/**
 *  计时器 该视图在 1秒后 消失
 */
@property (nonatomic,strong)NSTimer * timer;
@end
