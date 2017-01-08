//
//  TellTool.m
//  DialProject
//
//  Created by 班车陌路 on 2017/1/7.
//  Copyright © 2017年 jcd. All rights reserved.
//

#import "TellTool.h"
#import "DialEvent.h"

@interface TellTool ()

@property (nonatomic) CTCallCenter *callCenter;

@property (nonatomic) DialEvent *event;

@end

@implementation TellTool

+ (TellTool *) shareTool{
    static TellTool *tool = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        tool = [TellTool new];
    });
    return tool;
}
//- (void)dealloc{
//    [self unregisterAllEvent];
//}
- (instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventClick) name:@"start_tell_tool" object:nil];
    }
    return self;
}

-(void)detectCall {

    if (self.event) {
        [self postEvent:self.event];
        self.event = nil;
    }
    
    WeakSelf;
    self.callCenter = [[CTCallCenter alloc] init];
    self.callCenter.callEventHandler=^(CTCall* call) {
        if (call.callState == CTCallStateDisconnected) {
            weakSelf.event = [DialEvent eventWithType:CALL_END_TIME];
            weakSelf.event.time = [ToolFile getCurrentTime];
            [weakSelf postEvent:weakSelf.event];
            DebugLog(@"Call has been disconnected/电话结束 ---%@",[ToolFile getCurrentTime]);
        } else if (call.callState == CTCallStateConnected) {
            weakSelf.event = [DialEvent eventWithType:CALL_BEGIN_TIME];
            weakSelf.event.time = [ToolFile getCurrentTime];
            [weakSelf postEvent:weakSelf.event];
            DebugLog(@"Call has just been connected/电话已接听 ---%@",[ToolFile getCurrentTime]);
        } else if(call.callState == CTCallStateIncoming) {
            weakSelf.event = [DialEvent eventWithType:CALL_CALL_TIME];
            weakSelf.event.time = [ToolFile getCurrentTime];
            [weakSelf postEvent:weakSelf.event];
            DebugLog(@"Call is incoming/电话呼入"); //self.viewController.signalStatus=NO;
        } else if (call.callState ==CTCallStateDialing) {
            weakSelf.event = [DialEvent eventWithType:CALL_START_TIME];
            weakSelf.event.time = [ToolFile getCurrentTime];
            [weakSelf postEvent:weakSelf.event];
            DebugLog(@"call is dialing/电话呼叫开始 ---%@",[ToolFile getCurrentTime]);
        } else {
            DebugLog(@"Nothing is done");
        }
    };
}


@end
