//
//  SystemAddressController.m
//  DialProject
//
//  Created by 开发者1 on 17/1/3.
//  Copyright © 2017年 jcd. All rights reserved.
//

#import "SystemAddressController.h"

#import <ContactsUI/ContactsUI.h>

@interface SystemAddressController ()<CNContactPickerDelegate>

@end

@implementation SystemAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CNContactPickerViewController *picketVC = [[CNContactPickerViewController alloc] init]; // 真机或者模拟器的系统版本必须是9.0以上
    
    // 2.遵守代理 CNContactPickerDelegate
    picketVC.delegate = self;
    // 3.展现通讯录界面
    //[self presentViewController:picketVC animated:YES completion:nil];
    //[self.view addSubview:picketVC];
    [self.navigationController pushViewController:picketVC animated:true];
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    DebugLog(@"%s",__func__);
}


@end
