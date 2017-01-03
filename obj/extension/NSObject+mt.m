//
//  NSObject.m
//  HelloTF
//
//  Created by Master on 16/9/13.
//  Copyright © 2016年 Master. All rights reserved.
//

#import "NSObject+mt.h"

static NSString* k_postEvent = @"k_postEvent";

static NSString* k_selSet = @"k_selSet";

@implementation NSObject (mt)



- (void) unregisterAllEvent
{
    [self.selSet removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:k_postEvent object:nil];
}

- (void) registerEvent:(__unsafe_unretained Class )cs onSEL:(SEL)sel
{
    if(!self.selSet) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceivePostEvent:) name:k_postEvent object:nil];
        self.selSet = [NSMutableDictionary new];
    }
    
    NSString* left = NSStringFromClass(cs);
    NSString* right = NSStringFromSelector(sel);
    [self.selSet setValue:right forKey:left];
}
- (void) postEvent:(MTEvent *)event
{
    if([event class] == [MTEvent class]){
        @throw [NSException exceptionWithName:@"不能发送基础模版事件" reason:nil userInfo:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:k_postEvent object:event];
}

- (void) onReceivePostEvent:(NSNotification*) note
{
    if(self.selSet){
        MTEvent* event = note.object;
        NSString* key = NSStringFromClass([event class]);
        NSString* selname = [self.selSet valueForKey:key];
        if(selname){
            [self performSelector:NSSelectorFromString(selname) withObject:event afterDelay:0];
        }
    }
}

- (void) setSelSet:(NSMutableDictionary *)selSet
{
    objc_setAssociatedObject(self, &k_selSet, selSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSMutableDictionary*) selSet
{
    return objc_getAssociatedObject(self, &k_selSet);
}

@end
