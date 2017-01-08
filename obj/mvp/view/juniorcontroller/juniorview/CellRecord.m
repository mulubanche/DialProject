//
//  CellRecord.m
//  DialProject
//
//  Created by 班车陌路 on 2017/1/1.
//  Copyright © 2017年 jcd. All rights reserved.
//

#import "CellRecord.h"
#import "DBFile.h"

@implementation CellRecord
{
    __weak IBOutlet UIImageView *icon;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *tell;
    __weak IBOutlet UIImageView *state;
    __weak IBOutlet UILabel *time;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(RecordModel *)model{
    _model = model;
    
    if ([model.state integerValue]==1) state.image = [UIImage imageNamed:@"state_green"];
    else if ([model.state integerValue]==2) state.image = [UIImage imageNamed:@"state_blue"];
    else state.image = [UIImage imageNamed:@"state_red"];
    
    NSDateFormatter *matter = [NSDateFormatter new];
    [matter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    if (self.ret) {
        name.text = [_model.name isEqualToString:@""]?_model.tell:_model.name;
        NSInteger num = [[DBFile shareInstance] selecteRecordTell:_model.tell].count;
        name.text = num>1?[NSString stringWithFormat:@"%@(%ld)", name.text, num]:name.text;
        tell.text = _model.tell;
        
        NSDate *date = [matter dateFromString:_model.time];
        [matter setDateFormat:@"yyyy/MM/dd"];
        time.text = [matter stringFromDate:date];
    }else{
        NSInteger b_time = [[matter dateFromString:_model.b_time] timeIntervalSince1970];
        NSInteger e_time = [[matter dateFromString:_model.e_time] timeIntervalSince1970];
        NSInteger cate = [_model.state integerValue];
        NSInteger c = (e_time-b_time)>0?e_time-b_time:0;
        
        if (cate==3) name.text = @"未接来电";
        else if (cate==2) name.text = [self beginTime:c];
        else if (cate==1) name.text = [self beginTime:c];
        
        tell.text = [_model.name isEqualToString:@""]?_model.tell:_model.name;
        NSDate *date = [matter dateFromString:_model.time];
        [matter setDateFormat:@"hh:MM:ss"];
        time.text = [matter stringFromDate:date];
        
//        NSInteger time1 = [NSDate dateWith]
    }
}

- (NSString *) beginTime:(NSInteger)inv{
    NSString *str = @"";
    if (inv%3600>0) {
        str = [NSString stringWithFormat:@"%ld小时", inv/3600];
        inv = inv%3600;
    }
    if (inv%60>0) {
        str = [NSString stringWithFormat:@"%@%ld分钟", str, inv/60];
        inv = inv%60;
    }
    if (inv>0) {
        str = [NSString stringWithFormat:@"%@%ld秒", str, inv];
    }
    return [str isEqualToString:@""]?@"0秒":str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
