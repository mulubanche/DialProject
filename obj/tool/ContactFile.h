//
//  ContactFile.h
//  DialProject
//
//  Created by 开发者1 on 17/1/3.
//  Copyright © 2017年 jcd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactFile : NSObject

+ (void) getAddressBook:(void(^)(NSArray *ads))books error:(void(^)(NSInteger))ero;

@end
