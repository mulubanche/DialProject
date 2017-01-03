//
//  MyShowLabel.m
//  YiJingTong
//
//  Created by 中科创奇 on 15/4/3.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import "MyShowLabel.h"

@implementation MyShowLabel

+ (MyShowLabel *)shareShowLabel
{
    static MyShowLabel * showLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        showLabel = [[MyShowLabel alloc]init];
        showLabel.backgroundColor = JCDRGBA(240, 240, 240, 0.8);
    });
    return showLabel;
}

-(instancetype)init
{
    if ([super init]) {
//        self.layer.cornerRadius = 10;
//        self.layer.masksToBounds = YES;
        
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = JCDRGBA(67, 67, 67, 1);
        self.backgroundColor = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:16];
        
        
        
    }
    return self;
}


- (void)setText:(NSString *)text position:(int)position
{
    [super setText:text];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.frame = CGRectMake(0, 0, [self getStringWidthWithString:text]+20, 26);
    if (position == 1) {
         self.center = CGPointMake(KSCREENW/2, KSCREENH/2);
    }else if(position == -1)
    {
        self.center = CGPointMake(KSCREENW/2, KSCREENH - 100);
    }else
    {
        self.center = CGPointMake(KSCREENW/2, KSCREENH - 70);
    }
   
    self.layer.cornerRadius = 13;
    self.layer.masksToBounds = true;
    
    [self.timer invalidate];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(removeSelf:) userInfo:nil repeats:NO];
}

- (void)removeSelf:(NSTimer *)timer
{
    [self removeFromSuperview];
}
- (CGFloat)getStringWidthWithString:(NSString *)string
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(20, 222222) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    return rect.size.height;
}
@end
