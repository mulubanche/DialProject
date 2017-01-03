//
//  NSString+jcd.m
//  Quhuanbei_IOS
//
//  Created by 开发者1 on 16/9/22.
//  Copyright © 2016年 Master. All rights reserved.
//

#import "NSString+jcd.h"

@implementation NSString (jcd)

- (CGSize) textsizelimit:(CGSize)limit font:(UIFont *)font{
    return  [self boundingRectWithSize:limit options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

@end
