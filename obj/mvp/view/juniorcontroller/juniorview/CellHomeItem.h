//
//  CellHomeItem.h
//  DialProject
//
//  Created by 开发者1 on 17/1/3.
//  Copyright © 2017年 jcd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellHomeItem : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView    *icon;
@property (weak, nonatomic) IBOutlet UILabel        *title;

@property (nonatomic) NSDictionary                  *dic;
@end
