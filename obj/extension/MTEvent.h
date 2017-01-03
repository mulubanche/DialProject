//
//  MTEvent.h
//  HelloTF
//
//  Created by Master on 16/9/13.
//  Copyright © 2016年 Master. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTEvent : NSObject

@property(nonatomic, readonly) NSString* type;

+ (instancetype) eventWithType:(NSString*) type;

@end
