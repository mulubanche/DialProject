//
//  CellHomeItem.m
//  DialProject
//
//  Created by 开发者1 on 17/1/3.
//  Copyright © 2017年 jcd. All rights reserved.
//

#import "CellHomeItem.h"

@implementation CellHomeItem

- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.icon.image = [UIImage imageNamed:dic[@"icon"]];
    self.title.text = dic[@"title"];
}

@end
