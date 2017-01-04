//
//  InputTellView.h
//  DialProject
//
//  Created by 开发者1 on 17/1/4.
//  Copyright © 2017年 jcd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputTellView : UIView
@property (weak, nonatomic) IBOutlet UITextField *tell;
@property (copy, nonatomic) void (^selector)(BOOL,NSString*);
@end
