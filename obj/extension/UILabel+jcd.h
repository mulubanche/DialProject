//
//  UILabel+jcd.h
//  Quhuanbei_IOS
//
//  Created by 开发者1 on 16/9/21.
//  Copyright © 2016年 Master. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (jcd)

#pragma mark 文本置顶
- (void)alignTop;
- (void)alignBottom;

#pragma mark 添加行间距
- (void) addLabelSpasing:(CGFloat)spa;
#pragma mark 修改字体大小
- (void) changeLabelfont:(CGFloat)fontSize range:(NSRange)range;
#pragma mark 修改字体颜色
- (void) changeLabelcolor:(UIColor *)color range:(NSRange)range;
- (void) changeLabelcolor:(UIColor *)color font:(CGFloat)fontSize range:(NSRange)range;
- (void) changeLabelAddLinecolor:(UIColor *)color range:(NSRange)range;
#pragma mark 添加删除线
- (void) addDeleteLineColor:(UIColor *)color range:(NSRange)range;
- (void) changeLabelcolor:(UIColor *)color font:(CGFloat)fontSize delColor:(UIColor *)del range:(NSRange)range;
@end
