//
//  DialEvent.h
//  DialProject
//
//  Created by 班车陌路 on 2017/1/7.
//  Copyright © 2017年 jcd. All rights reserved.
//

#import "MTEvent.h"

static NSString *CALL_START_TIME = @"call_start_time";//开始
static NSString *CALL_END_TIME = @"call_end_time";//结束
static NSString *CALL_BEGIN_TIME = @"call_begin_time";//接通
static NSString *CALL_CALL_TIME = @"call_call_time";//呼入

@interface DialEvent : MTEvent

@property (nonatomic) NSString  *time;

@end
