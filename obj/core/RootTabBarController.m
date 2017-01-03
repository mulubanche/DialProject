//
//  RootTabBarController.m
//  DialProject
//
//  Created by 开发者1 on 16/12/30.
//  Copyright © 2016年 jcd. All rights reserved.
//

#import "RootTabBarController.h"
#import "DialController.h"
#import "RecordController.h"
#import "ContactController.h"
#import "HomeController.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *crls = @[@"DialController",@"RecordController",@"ContactController",@"HomeController"];
    NSArray *imgs_none = @[@"menu_ico_1_1",@"menu_ico_2_1",@"menu_ico_3_1",@"menu_ico_4_1"];
    NSArray *imgs_sel = @[@"menu_ico_1_2",@"menu_ico_2_2",@"menu_ico_3_2",@"menu_ico_4_2"];
    NSArray *crls_name = @[@"电话",@"通话记录",@"通讯录",@"主页"];
    
    NSMutableArray *svcs = [NSMutableArray array];
    for (int i=0; i<crls.count; i++) {
        Class cls = NSClassFromString(crls[i]);
        UIViewController *svc = [[cls alloc] init];
        svc.title = crls_name[i];
        UIImage *img = [UIImage imageNamed:imgs_none[i]];
        UIImage *selImg = [UIImage imageNamed:imgs_sel[i]];
        svc.tabBarItem.image = img;
        svc.tabBarItem.selectedImage = selImg;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:svc];
        [svcs addObject:nav];
    }
    
    self.viewControllers = svcs;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidetabbarcenter:) name:@"hidetabbarcenter" object:nil];
}

- (void) hidetabbarcenter:(NSNotification *)info{
    NSDictionary *dic = info.userInfo;
    [self hideTabbar:[dic[@"ret"] boolValue]];
}

- (void) hideTabbar:(BOOL)ret{
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:0.2 animations:^{
        for (UIView *item in self.view.subviews) {
            if ([item isKindOfClass:[UITabBar class]]) {
                if (ret) {
                    CGRect frame = item.frame;
                    frame.origin.y = KSCREENH;
                    item.frame = frame;
                }else{
                    CGRect frame = item.frame;
                    frame.origin.y = KSCREENH-49;
                    item.frame = frame;
                }
            }
        }
    }];
    [UIView commitAnimations];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
