//
//  DBFile.m
//  DialProject
//
//  Created by 班车陌路 on 2016/12/31.
//  Copyright © 2016年 jcd. All rights reserved.
//

#import "DBFile.h"
#import <FMDB/FMDB.h>

@implementation DBFile
{
    FMDatabase * base;
}

+ (DBFile *)shareInstance
{
    static DBFile *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBFile alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        [self createDB];
    }
    return self;
}

- (void) createDB{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/dialproject.sqlite"];
    
    base = [[FMDatabase alloc] initWithPath:path];
    if (![base open]) {
        NSLog(@"数据库打开失败");
    }
    else{
        NSString *createTabel = @"create table if not exists tb_record (record_id integer primary key autoincrement, tell varchar(255), time varchar(255), state varchar(255), name varchar(255), icon varchar(255), start_time varchar(255), end_time varchar(255), begin_time varchar(255), call_time varchar(255))";
        if (![base executeUpdate:createTabel]) {
            NSLog(@"创建tb_record表失败");
        }
    }
}

- (BOOL) insertRecord:(RecordModel *)model{
    NSString *sql = @"INSERT INTO tb_record(tell, time, state, name, icon, start_time, end_time, begin_time, call_time) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
    if([base executeUpdate:sql, model.tell, model.time, model.state, model.name, model.icon, model.s_time, model.e_time, model.b_time, model.c_time]) return true;
    else return false;
}
- (NSArray *) selecteRecord{
    //select  * from table where fid in(Select min(fid) FROM table group by name)
    //SELECT * FROM tb_record WHERE record_id IN(SELECT MIN(record_id) FROM tb_record GROUP BY tell
    //having count(*)>1
    //having COUNT(*)>1
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_record WHERE record_id IN(SELECT MAX(record_id) FROM tb_record GROUP BY tell)"];
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_record"];
    FMResultSet *set = [base executeQuery:sql];
    NSMutableArray *mulArr = [NSMutableArray array];
    while ([set next]) {
        RecordModel *model = [RecordModel new];
        model.tell = [set stringForColumn:@"tell"];
        model.name = [set stringForColumn:@"name"];
        model.state = [set stringForColumn:@"state"];
        model.time = [set stringForColumn:@"time"];
        model.icon = [set stringForColumn:@"icon"];
        model.s_time = [set stringForColumn:@"start_time"];
        model.s_time = [set stringForColumn:@"end_time"];
        model.b_time = [set stringForColumn:@"begin_time"];
        model.c_time = [set stringForColumn:@"call_time"];
        [mulArr addObject:model];
    }
    return [[mulArr reverseObjectEnumerator] allObjects];
}
- (NSArray *) selecteRecordTell:(NSString *)tell{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM tb_record WHERE TELL='%@'", tell];
    FMResultSet *set = [base executeQuery:sql];
    NSMutableArray *mulArr = [NSMutableArray array];
    while ([set next]) {
        RecordModel *model = [RecordModel new];
        model.tell = [set stringForColumn:@"tell"];
        model.name = [set stringForColumn:@"name"];
        model.state = [set stringForColumn:@"state"];
        model.time = [set stringForColumn:@"time"];
        model.icon = [set stringForColumn:@"icon"];
        model.s_time = [set stringForColumn:@"start_time"];
        model.s_time = [set stringForColumn:@"end_time"];
        model.b_time = [set stringForColumn:@"begin_time"];
        model.c_time = [set stringForColumn:@"call_time"];
        [mulArr addObject:model];
    }
    return [[mulArr reverseObjectEnumerator] allObjects];
}
- (BOOL) deleteRecord:(NSString *)tell{
    NSString *sql = @"DELETE FROM tb_record WHERE Tell=?";
    if ([base executeUpdate:sql, tell]) return true;
    else return false;
}
- (BOOL) deleteRecordModel:(RecordModel *)model{
    NSString *sql = @"DELETE FROM tb_record WHERE Tell=? AND time=?";
    if ([base executeUpdate:sql, model.tell, model.time]) return true;
    else return false;
}










@end
