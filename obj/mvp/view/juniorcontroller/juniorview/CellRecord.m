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
    
    name.text = [_model.name isEqualToString:@""]?_model.tell:_model.name;
    NSInteger num = [[DBFile shareInstance] selecteRecordTell:_model.tell].count;
    name.text = num>1?[NSString stringWithFormat:@"%@(%ld)", name.text, num]:name.text;
    tell.text = _model.tell;
    
    if ([model.state integerValue]==1) state.image = [UIImage imageNamed:@"state_green"];
    else if ([model.state integerValue]==2) state.image = [UIImage imageNamed:@"state_blue"];
    else state.image = [UIImage imageNamed:@"state_red"];
    
    NSDateFormatter *matter = [NSDateFormatter new];
    [matter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date = [matter dateFromString:_model.time];
    [matter setDateFormat:@"yyyy/MM/dd"];
    time.text = [matter stringFromDate:date];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
