//
//  RecordModel.h
//  DialProject
//
//  Created by 班车陌路 on 2016/12/31.
//  Copyright © 2016年 jcd. All rights reserved.
//

#import "Model.h"

@interface RecordModel : Model

@property (nonatomic) NSString  *   tell;
@property (nonatomic) NSString  *   time;
@property (nonatomic) NSString  *   name;
@property (nonatomic) NSString  *   state;//1播出，2播入，3中断
@property (nonatomic) NSString  *   icon;
@property (nonatomic) NSString  *   s_time;
@property (nonatomic) NSString  *   e_time;
@property (nonatomic) NSString  *   b_time;
@property (nonatomic) NSString  *   c_time;

@end
