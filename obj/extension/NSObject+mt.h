//
//  NSObject.h
//  HelloTF
//
//  Created by Master on 16/9/13.
//  Copyright © 2016年 Master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "MTEvent.h"

@interface NSObject (mt)

@property(nonatomic, readonly) NSMutableDictionary* selSet;

- (void) registerEvent:(Class) class onSEL:(SEL) sel;
- (void) unregisterAllEvent;
- (void) postEvent:(MTEvent*) event;

@end
