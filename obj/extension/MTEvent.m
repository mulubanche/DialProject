//
//  MTEvent.m
//  HelloTF
//
//  Created by Master on 16/9/13.
//  Copyright © 2016年 Master. All rights reserved.
//

#import "MTEvent.h"

@implementation MTEvent


+ (instancetype) eventWithType:(NSString *)type
{
    MTEvent* event = [self new];
    [event setType:type];
    return event;
}

- (void) setType:(NSString *)type
{
    _type = type;
}


@end
