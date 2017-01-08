//
//  CellRecord.h
//  DialProject
//
//  Created by 班车陌路 on 2017/1/1.
//  Copyright © 2017年 jcd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordModel.h"

@interface CellRecord : UITableViewCell

@property (nonatomic) BOOL          ret;
@property (nonatomic) RecordModel   *model;

@end
