//
//  MyDBManager.h
//  Quhuanbei_IOS
//
//  Created by 开发者1 on 16/9/22.
//  Copyright © 2016年 Master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "UserInfo.h"
#import "AddressInfoModel.h"
#import "GetVipModel.h"

@interface MyDBManager : NSObject

#pragma mark 搜索历史纪录
+ (BOOL) insertHistoryWithInfo:(NSString *)info time:(NSDate *)date;
+ (NSArray *) selecteHistory;
+ (BOOL) deleteHistoryWithIndex:(NSString *)index;
+ (BOOL) deleteHistory;

#pragma mark 用户信息
+ (BOOL) insertUserWithInfo:(UserInfo *)info;
+ (UserInfo *) selectedUserMessage:(NSInteger)userid;
+ (BOOL) updateUserInfo:(NSInteger)userid userInfo:(UserInfo *)info;
+ (BOOL) deleteUserInfo;

#pragma mark 收获地址
//+ (NSArray *) selectedAddressWithUserId:(NSInteger)userid;
//+ (BOOL) insertAddressWithModel:(AddressInfoModel *)model;
//+ (BOOL) updateAddressWithUserid:(NSInteger)userid addressModel:(AddressInfoModel *)model;

#pragma mark 获取用户等级对应的权限
+ (NSArray *) selectedUserCompetenceWithUserid:(NSInteger)userid;
+ (BOOL) insertUserCompetenceWithModel:(GetVipModel *)model;
+ (BOOL) updateUserConpetenceWithUserid:(NSInteger)userid vipModel:(GetVipModel *)model;

@end
