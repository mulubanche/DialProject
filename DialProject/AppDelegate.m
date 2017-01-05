//
//  AppDelegate.m
//  DialProject
//
//  Created by 开发者1 on 16/12/29.
//  Copyright © 2016年 jcd. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>

@interface AppDelegate ()

@property (nonatomic) CTCallCenter *callCenter;
@property (nonatomic,copy)NSString *startCallTime;
@property (nonatomic,copy)NSString *beginTelTime;
@property (nonatomic,copy)NSString *endCallTime;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [RootTabBarController new];
    
    return YES;
}


-(void)detectCall {
    
    
    //    NextViewController *next = [NextViewController new];
    
    WeakSelf;
    
    self.callCenter = [[CTCallCenter alloc] init];
    self.callCenter.callEventHandler=^(CTCall* call) {
        if (call.callState == CTCallStateDisconnected) {
            weakSelf.endCallTime = [weakSelf getCurrentTime];
            NSDictionary *dict = @{@"endTimes":weakSelf.endCallTime,@"startTimes":weakSelf.startCallTime};
            NSNotification *notifi = [NSNotification notificationWithName:@"callTime" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter]postNotification:notifi];
            DebugLog(@"Call has been disconnected/电话结束 ---%@",weakSelf.endCallTime);
        } else if (call.callState == CTCallStateConnected) {
            weakSelf.beginTelTime = [weakSelf getCurrentTime];
            NSDictionary *dict = @{@"endTimes":weakSelf.endCallTime,@"beginTimes":weakSelf.beginTelTime};
            NSNotification *notifi = [NSNotification notificationWithName:@"alreadyTel" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter]postNotification:notifi];
            DebugLog(@"Call has just been connected/电话已接听 ---%@",weakSelf.beginTelTime);
        } else if(call.callState == CTCallStateIncoming) {
            DebugLog(@"Call is incoming"); //self.viewController.signalStatus=NO;
        } else if (call.callState ==CTCallStateDialing) {
            weakSelf.startCallTime = [weakSelf getCurrentTime];
            DebugLog(@"call is dialing/电话呼叫开始 ---%@",weakSelf.startCallTime);
        } else {
            DebugLog(@"Nothing is done");
        }
    };
}
- (NSString *)getCurrentTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    
    return dateTime;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self detectCall];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    DebugLog(@"applicationWillEnterForeground  程序进入前台");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    DebugLog(@"applicationDidBecomeActive  程序重新激活");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
