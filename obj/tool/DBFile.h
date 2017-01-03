//
//  DBFile.h
//  DialProject
//
//  Created by 班车陌路 on 2016/12/31.
//  Copyright © 2016年 jcd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordModel.h"

@interface DBFile : NSObject

+ (DBFile *)shareInstance;
- (BOOL) insertRecord:(RecordModel *)model;
- (NSArray *) selecteRecord;
- (NSArray *) selecteRecordTell:(NSString *)tell;
- (BOOL) deleteRecord:(NSString *)tell;
- (BOOL) deleteRecordModel:(RecordModel *)model;

@end
