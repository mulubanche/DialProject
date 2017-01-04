//
//  InputTellView.m
//  DialProject
//
//  Created by 开发者1 on 17/1/4.
//  Copyright © 2017年 jcd. All rights reserved.
//

#import "InputTellView.h"
#import "FDAlertView.h"

@implementation InputTellView
- (IBAction)cancel:(id)sender {
    if (self.selector) self.selector(false, nil);
    FDAlertView *alert = (FDAlertView *)self.superview;
    [alert hide];
}
- (IBAction)sure:(id)sender {
    if (self.selector) self.selector(true, self.tell.text);
    FDAlertView *alert = (FDAlertView *)self.superview;
    [alert hide];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = true;
}

@end
