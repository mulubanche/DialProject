//
//  MyDBManager.m
//  Quhuanbei_IOS
//
//  Created by 开发者1 on 16/9/22.
//  Copyright © 2016年 Master. All rights reserved.
//

#import "MyDBManager.h"
#import "NSDictionary+mt.h"

@interface MyDBManager ()

@property (strong, nonatomic) FMDatabase        * myDataBase;

@end

@implementation MyDBManager

- (instancetype)init{
    if (self = [super init]) {
        
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/huanbeidb.sqlite"];
        self.myDataBase = [FMDatabase databaseWithPath:path];
        if ([self.myDataBase open]) {//autoincrement
            
            NSString *tb = @"CREATE TABLE IF NOT EXISTS hbhistory (kid integer PRIMARY KEY AUTOINCREMENT, his_info varchar(255), his_time varchar(255))";
            if ([self.myDataBase executeUpdate:tb]) {
//                DebugLog(@"数据库创建成功");
            }else{
                DebugLog(@"数据库创建失败");
            }
            NSString *usertb = @"CREATE TABLE IF NOT EXISTS usertb (kid integer PRIMARY KEY AUTOINCREMENT, userid int, user_name varchar(255), user_nick varchar(255), user_tell varchar(255), user_leveid int, user_shell int, user_gold int, user_icon varchar(255), user_turename varchar(255), user_idcode varchar(255), user_sex varchar(255), user_isdel bool, user_isfreeze bool, user_growup int, user_vipid int, user_star int, user_growupend int, user_vipname varchar(255), user_vipnick varchar(255), user_startime int, user_endtime int, user_unixcreatedate varchar(255), user_honesty int, vip_end_time int)";
            if ([self.myDataBase executeUpdate:usertb]) {
//                DebugLog(@"数据库创建用户信息表成功");
            }else{
                DebugLog(@"数据库创建用户信息表失败");
            }

            NSString *addressTb = @"CREATE TABLE IF NOT EXISTS addresstb (kid integer PRIMARY KEY AUTOINCREMENT, address varchar(255), city varchar(255), createDate varchar(255), addressid int, isdef int, isdel int, name varchar(255), province varchar(255), tel varchar(255), userid int)";
            if ([self.myDataBase executeUpdate:addressTb]) {
//                DebugLog(@"数据库默认地址表成功");
            }else{
                DebugLog(@"数据库默认地址表失败");
            }
            
            NSString *permissionTb = @"CREATE TABLE IF NOT EXISTS permissiontb (kid integer PRIMARY KEY AUTOINCREMENT,permissionid int, name varchar(255), vipid int, start int, gstart int, gend int, scale double, storscale double, sell int, buy int, recharge double, userid int)";
            if ([self.myDataBase executeUpdate:permissionTb]) {
//                DebugLog(@"数据库默认地址表成功");
            }else{
                DebugLog(@"数据库默认地址表失败");
            }
            
            NSString *timetb = @"CREATE TABLE IF NOT EXISTS timetb (kid integer PRIMARY KEY AUTOINCREMENT, time varchar(255), remind int)";
            if ([self.myDataBase executeUpdate:timetb]) {
                //                DebugLog(@"数据库默认地址表成功");
            }else{
                DebugLog(@"数据库默认地址表失败");
            }
            
        }else{
//            DebugLog(@"数据库打开失败");
        }
        
    }
    return self;
}

#pragma mark 获取用户等级对应的权限
+ (NSArray *) selectedUserCompetenceWithUserid:(NSInteger)userid{
    GetVipModel *model = [[GetVipModel alloc] init];
    MyDBManager *m = [MyDBManager new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM permissiontb WHERE userid =%ld", (long)userid];
    if ([m.myDataBase executeQuery:sql]) {
        FMResultSet *set = [m.myDataBase executeQuery:sql];
        while ([set next]) {
            model.ID            = [set intForColumn:@"permissionid"];
            model.LevelName     = [set stringForColumn:@"name"];
            model.VIPID         = [set intForColumn:@"vipid"];
            model.Star          = [set intForColumn:@"start"];
            model.GrowupStart   = [set intForColumn:@"gstart"];
            model.GrowupEnd     = [set intForColumn:@"gend"];
            model.ComScale      = [set doubleForColumn:@"scale"];
            model.StorageScale  = [set doubleForColumn:@"storscale"];
            model.RechargeScale = [set doubleForColumn:@"recharge"];
        }
    }
    if (!model.LevelName) {
        return nil;
    }
    return @[model];
}
+ (BOOL) insertUserCompetenceWithModel:(GetVipModel *)model{
    MyDBManager *m = [MyDBManager new];
    NSString *sql = @"INSERT INTO permissiontb(permissionid, name, vipid, start, gstart, gend, scale, storscale, recharge, userid) VALUES(?,?,?,?,?,?,?,?,?,?)";
    NSArray*items = @[
                      [NSNumber numberWithInteger:model.ID],
                      model.LevelName,
                      [NSNumber numberWithInteger:model.VIPID],
                      [NSNumber numberWithInteger:model.Star],
                      [NSNumber numberWithInteger:model.GrowupStart],
                      [NSNumber numberWithInteger:model.GrowupEnd],
                      [NSNumber numberWithDouble:model.ComScale],
                      [NSNumber numberWithDouble:model.StorageScale],
                      [NSNumber numberWithDouble:model.RechargeScale],
                      [KSUSERDEFAULT objectForKey:LOGIN_SUCCESS_ID]
                      ];
    return [m.myDataBase executeUpdate:sql values:items error:nil];
}
+ (BOOL) updateUserConpetenceWithUserid:(NSInteger)userid vipModel:(GetVipModel *)model{
    MyDBManager *m = [MyDBManager new];
    NSArray *odlData = [MyDBManager selectedUserCompetenceWithUserid:userid];
    if (!odlData) {
        [MyDBManager insertUserCompetenceWithModel:model];
        return true;
    }
    NSString *sql = [NSString stringWithFormat:@"UPDATE permissiontb SET permissionid=%ld, name='%@', vipid=%ld, start=%ld, gstart=%ld, gend=%ld, scale=%.3f, storscale=%.3f, recharge=%.3f WHERE userid=%ld", (long)model.ID, model.LevelName, (long)model.VIPID, (long)model.Star, (long)model.GrowupStart, (long)model.GrowupEnd, model.ComScale, model.StorageScale, model.RechargeScale, (long)userid];
    return [m.myDataBase executeUpdate:sql];
}


#pragma mark 默认地址
//+ (NSArray *) selectedAddressWithUserId:(NSInteger)userid{
//    AddressInfoModel *addressModel = [[AddressInfoModel alloc] init];
//    MyDBManager *m = [MyDBManager new];
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM addresstb WHERE userid =%ld", (long)userid];
//    if ([m.myDataBase executeQuery:sql]) {
//        FMResultSet *set = [m.myDataBase executeQuery:sql];
//        while ([set next]) {
//            addressModel.Address    = [set stringForColumn:@"address"];
//            addressModel.CityName       = [set stringForColumn:@"city"];
//            addressModel.CreateDate = [set stringForColumn:@"createDate"];
//            addressModel.ID         = [set intForColumn:@"addressid"];
//            addressModel.IsDef      = [set boolForColumn:@"isdef"];
//            addressModel.IsDel      = [set boolForColumn:@"isdel"];
//            addressModel.Name       = [set stringForColumn:@"name"];
//            addressModel.Province   = [set stringForColumn:@"province"];
//            addressModel.Tel        = [set stringForColumn:@"tel"];
//            addressModel.UserID     = [set intForColumn:@"userid"];
//        }
//    }
//    if (!addressModel.UserID) {
//        return nil;
//    }
//    return @[addressModel];
//}
//+ (BOOL) insertAddressWithModel:(AddressInfoModel *)model{
//    MyDBManager *m = [MyDBManager new];
//    NSString *sql = @"INSERT INTO addresstb(address, city, createDate, addressid, isdef, isdel, name, province, tel, userid) VALUES(?,?,?,?,?,?,?,?,?,?)";
//    NSArray *items = @[
//                       model.Address,
//                       model.City,
//                       model.CreateDate,
//                       [NSNumber numberWithBool:model.ID],
//                       [NSNumber numberWithBool:model.IsDef],
//                       [NSNumber numberWithBool:model.IsDel],
//                       model.Name,
//                       model.Province,
//                       model.Tel,
//                       [NSNumber numberWithInteger:model.UserID]
//                       ];
//    return [m.myDataBase executeUpdate:sql values:items error:nil];
//}
//+ (BOOL) updateAddressWithUserid:(NSInteger) userid addressModel:(AddressInfoModel *)model{
//    MyDBManager *m = [MyDBManager new];
//    NSArray *odlData = [MyDBManager selectedAddressWithUserId:userid];
//    if (!odlData) {
//        [MyDBManager insertAddressWithModel:model];
//        return true;
//    }
//    NSString *sql = [NSString stringWithFormat:@"UPDATE addresstb SET address='%@' , city='%@' , createDate='%@' , addressid=%ld , isdef=%d , isdel=%d , name='%@' , province='%@' , tel='%@' WHERE userid=%ld", model.Address, model.City, model.CreateDate, (long)model.ID, model.IsDef, model.IsDel, model.Name, model.Province, model.Tel, (long)model.UserID];
//    return [m.myDataBase executeUpdate:sql];
//}


#pragma mark 添加用户信息
+ (BOOL) insertUserWithInfo:(UserInfo *)info{
    MyDBManager *m = [MyDBManager new];
    
    NSString *sql = @"INSERT INTO usertb(userid, user_name, user_nick, user_tell, user_leveid, user_shell, user_gold, user_icon, user_turename, user_idcode, user_sex, user_isdel, user_isfreeze, user_growup, user_vipid, user_star, user_growupend, user_vipname, user_vipnick, user_startime, user_endtime, user_unixcreatedate, user_honesty, vip_end_time) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    NSArray *items = @[
                       [NSNumber numberWithInteger:info.ID],
                       info.LoginName,
                       info.Nickname,
                       info.Tel,
                       [NSNumber numberWithInteger:info.UserLevelID],
                       [NSNumber numberWithInteger:info.Shell],
                       [NSNumber numberWithInteger:info.Gold],
                       info.UserICon,
                       info.TrueName,
                       info.IDCode,
                       info.Sex,
                       [NSNumber numberWithBool:info.IsDel],
                       [NSNumber numberWithBool:info.IsFreeze],
                       [NSNumber numberWithInteger:info.Growup],
                       [NSNumber numberWithInteger:info.VIPID],
                       [NSNumber numberWithInteger:info.Star],
                       [NSNumber numberWithInteger:info.GrowupEnd],
                       info.VIPName,
                       info.VIPNick,
                       @0,
                       @0,
                       info.UnixCreateDate,
                       [NSNumber numberWithInteger:info.Honesty],
                       [NSNumber numberWithInteger:info.UnixEndTime]
                       ];
    
    return  [m.myDataBase executeUpdate:sql values:items error:nil];
}
+ (UserInfo *) selectedUserMessage:(NSInteger)userid{
    UserInfo *userInfo = [[UserInfo alloc] init];
    MyDBManager *m = [MyDBManager new];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM usertb WHERE userid =%ld", (long)userid];
    if ([m.myDataBase executeQuery:sql]) {
        FMResultSet *set = [m.myDataBase executeQuery:sql];
        while ([set next]) {
            userInfo.LoginName      = [set stringForColumn:@"user_name"];
            userInfo.Nickname       = [set stringForColumn:@"user_nick"];
            userInfo.Tel            = [set stringForColumn:@"user_tell"];
            userInfo.UserLevelID    = [set intForColumn:@"user_leveid"];
            userInfo.Shell          = [set intForColumn:@"user_shell"];
            userInfo.Gold           = [set intForColumn:@"user_gold"];
            userInfo.UserICon       = [set stringForColumn:@"user_icon"];
            userInfo.TrueName       = [set stringForColumn:@"user_turename"];
            userInfo.IDCode         = [set stringForColumn:@"user_idcode"];
            userInfo.Sex            = [set stringForColumn:@"user_sex"];
            userInfo.IsDel          = [set boolForColumn:@"user_isdel"];
            userInfo.Growup         = [set intForColumn:@"user_growup"];
            userInfo.VIPID          = [set intForColumn:@"user_vipid"];
            userInfo.Star           = [set intForColumn:@"user_star"];
            userInfo.GrowupEnd      = [set intForColumn:@"user_growupend"];
            userInfo.VIPName        = [set stringForColumn:@"user_vipname"];
            userInfo.VIPNick        = [set stringForColumn:@"user_vipnick"];
            userInfo.UnixCreateDate = [set stringForColumn:@"user_unixcreatedate"];
            userInfo.Honesty        = [set intForColumn:@"user_honesty"];
            userInfo.UnixEndTime    = [set intForColumn:@"vip_end_time"];
        }
    }
    return userInfo;
}
+ (BOOL) updateUserInfo:(NSInteger)userid userInfo:(UserInfo *)info{
    MyDBManager *m = [MyDBManager new];
    NSString *sql = [NSString stringWithFormat:@"UPDATE usertb SET user_name='%@', user_nick='%@', user_tell='%@', user_leveid=%ld, user_shell=%ld, user_gold=%ld, user_icon='%@', user_turename='%@', user_idcode='%@', user_sex='%@', user_isdel=%d, user_growup=%ld, user_vipid=%ld, user_star=%ld, user_growupend=%ld, user_vipname='%@', user_vipnick='%@', user_unixcreatedate='%@', user_honesty=%ld, vip_end_time=%ld WHERE userid=%ld", info.LoginName, info.Nickname, info.Tel, (long)info.UserLevelID, (long)info.Shell, (long)info.Gold, info.UserICon, info.TrueName, info.IDCode, info.Sex, info.IsDel, (long)info.Growup, (long)info.VIPID, (long)info.Star, (long)info.GrowupEnd, info.VIPName, info.VIPNick, info.UnixCreateDate, (long)info.Honesty, (long)info.UnixEndTime, (long)userid];
    return [m.myDataBase executeUpdate:sql];
}
+ (BOOL) deleteUserInfo{
    MyDBManager *m = [MyDBManager new];
    NSString *sql = @"DELETE FROM usertb";
    return [m.myDataBase executeUpdate:sql];
}
+ (BOOL) deleteUserInfoWithIndex:(NSString *)index{
    MyDBManager *m = [MyDBManager new];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM usertb WHERE kid=%@", index];
    return [m.myDataBase executeUpdate:sql];
}




#pragma mark 历史记录
+ (NSArray *) selecteHistory{
    NSMutableArray *mulArr = [NSMutableArray array];
    MyDBManager *m = [MyDBManager new];
    NSString *sql = @"SELECT * FROM hbhistory ORDER BY kid DESC";
    if ([m.myDataBase executeQuery:sql]) {
        FMResultSet *set = [m.myDataBase executeQuery:sql];
        while ([set next]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"info"]   = [set stringForColumn:@"his_info"];
            dict[@"date"]   = [set stringForColumn:@"his_time"];
            dict[@"id"]     = [NSString stringWithFormat:@"%d", [set intForColumn:@"kid"]];
            [mulArr addObject:dict];
        }
    }
    return mulArr;
}
+ (BOOL) insertHistoryWithInfo:(NSString *)info time:(NSDate *)date{
    MyDBManager *m = [MyDBManager new];
    NSString *sql = @"INSERT INTO hbhistory(his_info, his_time) VALUES(?,?)";
    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM hbhistory WHERE his_info='%@'", info];
    FMResultSet *set = [m.myDataBase executeQuery:selectSql];
    NSMutableArray *mulArr = [NSMutableArray array];
    while ([set next]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"info"]   = [set stringForColumn:@"his_info"];
        dict[@"date"]   = [set stringForColumn:@"his_time"];
        dict[@"id"]     = [NSString stringWithFormat:@"%d", [set intForColumn:@"kid"]];
        [mulArr addObject:dict];
    }
    if (mulArr.count > 0) {
        [MyDBManager deleteHistoryWithIndex:mulArr[0][@"id"]];
    }
    return [m.myDataBase executeUpdate:sql withArgumentsInArray:@[info, date]];
}
+ (BOOL) deleteHistoryWithIndex:(NSString *)index{
    MyDBManager *m = [MyDBManager new];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM hbhistory WHERE kid=%@", index];
    return [m.myDataBase executeUpdate:sql];
}
+ (BOOL) deleteHistory{
    MyDBManager *m = [MyDBManager new];
    NSString *sql = @"DELETE FROM hbhistory";
    return [m.myDataBase executeUpdate:sql];
}


#pragma mark 当天是否首次启动
+ (NSDictionary *) selecteRemind{
    NSMutableDictionary *mulDic = [NSMutableDictionary dictionary];
    MyDBManager *m = [MyDBManager new];
    NSString *sql = @"SELECT * FROM timetb";
    if ([m.myDataBase executeQuery:sql]) {
        FMResultSet *set = [m.myDataBase executeQuery:sql];
        while ([set next]) {
            mulDic[@"time"] = [set stringForColumn:@"time"];
            mulDic[@"remind"] = [NSNumber numberWithInt:[set intForColumn:@"remind"]];
        }
    }
    return mulDic;
}
//+ (BOOL) insertRemindWithDict:(NSDictionary *)dic{
//    MyDBManager *m = [MyDBManager new];
//    NSString *sql = @"INSERT INTO hbhistory(his_info, his_time) VALUES(?,?)";
//    NSString *selectSql = [NSString stringWithFormat:@"SELECT * FROM hbhistory WHERE his_info='%@'", info];
//    FMResultSet *set = [m.myDataBase executeQuery:selectSql];
//    return true;
//}




@end
