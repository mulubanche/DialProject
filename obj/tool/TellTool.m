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
- (void)dealloc{
    [self unregisterAllEvent];
}
- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(void)detectCall {

    WeakSelf;
    self.callCenter = [[CTCallCenter alloc] init];
    self.callCenter.callEventHandler=^(CTCall* call) {
        if (call.callState == CTCallStateDisconnected) {
            DialEvent *event = [DialEvent eventWithType:CALL_END_TIME];
            event.time = [ToolFile getCurrentTime];
            [weakSelf postEvent:event];
            DebugLog(@"Call has been disconnected/电话结束 ---%@",[ToolFile getCurrentTime]);
        } else if (call.callState == CTCallStateConnected) {
            DialEvent *event = [DialEvent eventWithType:CALL_BEGIN_TIME];
            event.time = [ToolFile getCurrentTime];
            [weakSelf postEvent:event];
            DebugLog(@"Call has just been connected/电话已接听 ---%@",[ToolFile getCurrentTime]);
        } else if(call.callState == CTCallStateIncoming) {
            DialEvent *event = [DialEvent eventWithType:CALL_CALL_TIME];
            event.time = [ToolFile getCurrentTime];
            [weakSelf postEvent:event];
            DebugLog(@"Call is incoming/电话呼入"); //self.viewController.signalStatus=NO;
        } else if (call.callState ==CTCallStateDialing) {
            DialEvent *event = [DialEvent eventWithType:CALL_START_TIME];
            event.time = [ToolFile getCurrentTime];
            [weakSelf postEvent:event];
            DebugLog(@"call is dialing/电话呼叫开始 ---%@",[ToolFile getCurrentTime]);
        } else {
            DebugLog(@"Nothing is done");
        }
    };
}


@end
