//
//  UILabel+jcd.m
//  Quhuanbei_IOS
//
//  Created by 开发者1 on 16/9/21.
//  Copyright © 2016年 Master. All rights reserved.
//

#import "UILabel+jcd.h"

@implementation UILabel (jcd)

- (void)alignTop {
    if ([self.text isKindOfClass:[NSNull class]])
        return;
    CGSize size = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)];
    int num = size.height/self.font.lineHeight;
    if (num < self.numberOfLines) {
        NSString *str = self.text;
        for (int i=0; i<self.numberOfLines-num; i++) {
            str = [str stringByAppendingString:@"\n "];
        }
        self.text = str;
    }
}

- (void)alignBottom {
//    CGSize fontSize = [self.text sizeWithFont:self.font];
//    double finalHeight = fontSize.height * self.numberOfLines;
//    double finalWidth = self.frame.size.width;    //expected width of label
//    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
//    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
//    for(int i=0; i<newLinesToPad; i++)
//        self.text = [NSString stringWithFormat:@" \n%@",self.text];
}

#pragma mark 添加行间距
- (void) addLabelSpasing:(CGFloat)spa{
    if ([self.text isKindOfClass:[NSNull class]] || !self.text)
        return;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = spa;
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.text.length)];
    self.attributedText = attr;
}
#pragma mark 修改字体大小
- (void) changeLabelfont:(CGFloat)fontSize range:(NSRange)range{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
    self.attributedText = attr;
}
#pragma mark 修改字体颜色
- (void) changeLabelcolor:(UIColor *)color range:(NSRange)range{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attr addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = attr;
}
- (void) changeLabelAddLinecolor:(UIColor *)color range:(NSRange)range{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attr addAttribute:NSForegroundColorAttributeName value:color range:range];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3;
    [attr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.text.length)];
    self.attributedText = attr;
}

- (void) changeLabelcolor:(UIColor *)color font:(CGFloat)fontSize range:(NSRange)range{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
    [attr addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = attr;
}

- (void) addDeleteLineColor:(UIColor *)color range:(NSRange)range{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
    [attr addAttribute:NSStrikethroughColorAttributeName value:color range:range];
    self.attributedText = attr;
}

- (void) changeLabelcolor:(UIColor *)color font:(CGFloat)fontSize delColor:(UIColor *)del range:(NSRange)range{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
    [attr addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
    [attr addAttribute:NSStrikethroughColorAttributeName value:color range:range];
    self.attributedText = attr;
}

@end
