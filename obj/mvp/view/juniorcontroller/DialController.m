//
//  DialController.m
//  DialProject
//
//  Created by 开发者1 on 16/12/30.
//  Copyright © 2016年 jcd. All rights reserved.
//

#import "DialController.h"

#import "CarouselView.h"
#import "CellTellNumber.h"

#import "DialEvent.h"
#import "DBFile.h"
#import "Hinter.h"
#import "ContactFile.h"
#import "RecordModel.h"

@interface DialController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *call_view;

@property (weak, nonatomic) IBOutlet UIView             *num_view;
@property (weak, nonatomic) IBOutlet UIView             *ban_view;
@property (weak, nonatomic) IBOutlet UICollectionView   *clct_view;
@property (weak, nonatomic) IBOutlet UILabel            *call_number;
@property (weak, nonatomic) IBOutlet UIButton           *del_num;
@property (weak, nonatomic) IBOutlet UIButton *callbutton;
@property (nonatomic) NSString                          *number;
@property (nonatomic, assign) BOOL                      ret;
@property (nonatomic) RecordModel                       *model;

@end

@implementation DialController

- (void)dealloc{
    [self unregisterAllEvent];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:false];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.number = @"";
    self.model = [RecordModel new];
    [self createView];
    
    [self registerEvent:[DialEvent class] onSEL:@selector(event:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationClick:) name:CALL_CENTER object:nil];
}

- (void) createView{
//    CarouselView *view = [[CarouselView alloc] initWithFrame:CGRectMake(0, 0, self.ban_view.width, self.ban_view.height)];
    
    self.call_view.frame = CGRectMake(-1, KSCREENH, KSCREENW+2, 50);
    self.call_view.layer.borderColor = [UIColor grayColor].CGColor;
    self.call_view.layer.borderWidth = 1;
    self.del_num.adjustsImageWhenHighlighted = false;
    self.callbutton.width = KSCREENW-100;
    
    CarouselView *view = [CarouselView newAutoLayoutView];
    [self.ban_view addSubview:view];
    
    [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [view autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    view.dataArr = @[@"001.jpg",@"002.jpg",@"003.jpg",@"004.jpg"];
    
    
    [self.clct_view registerNib:[UINib nibWithNibName:@"CellTellNumber" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"callid"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.itemSize = CGSizeMake((KSCREENW-4)/3, 50);
    
//    self.call_view.hidden = true;
    [self.clct_view setCollectionViewLayout:layout];
    self.clct_view.delegate = self;
    self.clct_view.dataSource = self;
    self.clct_view.bounces = false;
    self.clct_view.showsVerticalScrollIndicator = false;
    self.clct_view.showsHorizontalScrollIndicator = false;
    
//    self.clct_view.hidden = true;
}
- (IBAction)delclick:(UIButton *)sender {
    self.number = [self.number substringWithRange:NSMakeRange(0, self.number.length-1)];
    if([self.number isEqualToString:@""]) {
        self.del_num.hidden = true;
        self.call_number.text = @"固话请加拨区号";
        
//        [self hinddenCallView:false];
        self.ret = false;
        [self performSelector:@selector(hinddenCallView) withObject:self afterDelay:0.1];
    }else{
        self.call_number.text = self.number;
    }
}
- (void) notificationClick:(NSNotification *)info{
    NSDictionary *dic = info.userInfo;
    self.model.tell = dic[@"tell"];
    [self callClickData];
}
- (void) callClickData{
    [ToolFile judgeSaveTellIsShow:true block:^() {
        //self.model.tell = weakSelf.number;
        self.model.name = @"";
        self.model.time = [ToolFile getCurrentTime];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"callerE164"] = [KSUSERDEFAULT objectForKey:SAVE_SELF_TELL];
        dic[@"calleeE164s"] = [self newtell:self.model.tell];
        dic[@"accessE164"] = @"10081";
        dic[@"accessE164Password"] = @"891210";
        //13145011306
        [Hinter title:@"" msg:@"呼叫中..." indicator:true hideAfter:0 view:self.view];
        [Soaper connectUrl:[NSString stringWithFormat:@"%@%@", CODE_URL, COSSERVICE] Method:COSS_CALL_BACK Param:dic Success:^(NSDictionary *rawDic, NSString *rawStr) {
            DebugLog(@"%@", rawDic);
            [Hinter hide];
            [ContactFile getAddressBook:^(NSArray *ads) {
                for (NSDictionary *dic in ads) {
                    if ([[self newtell:dic[@"user_tell"]] rangeOfString:self.model.tell].length>0) {
                        self.model.name = dic[@"user_name"];
                    }
                }
                if (!self.model.name||[self.model.name isEqualToString:@""]) self.model.name = self.model.tell;
                [[DBFile shareInstance] insertRecord:self.model];
            } error:^(NSInteger num) {
                
            }];
        } Error:^(NSString *errMsg, NSString *rawStr) {
            DebugLog(@"%@", errMsg);
            //服务器无法为请求提供服务，因为不支持该媒体类型。
            [Hinter title:@"" msg:errMsg indicator:false hideAfter:1 view:self.view];
        }];
    }];
}
- (IBAction)sureCallClick:(UIButton *)sender {
    self.model.tell = self.number;
    [self callClickData];
//    self.model.tell = self.number;
//    self.model.name = @"宠溺";
//    self.model.name = rand()%2?@"陌路班车":@"宠溺";
//    self.model.state = [NSString stringWithFormat:@"%d", rand()%3+1];
//    self.model.time = [ToolFile getCurrentTime];
//    self.model.s_time = [ToolFile getCurrentTime];
//    self.model.b_time = [ToolFile getCurrentTime];
//    self.model.c_time = [ToolFile getCurrentTime];
//    self.model.e_time = [ToolFile getCurrentTime];
//    //18011407694
//    [ContactFile getAddressBook:^(NSArray *ads) {
//        for (NSDictionary *dic in ads) {
//            if ([dic[@"user_tell"] isEqualToString:self.number]) {
//                self.model.name = dic[@"user_name"];
//            }
//        }
//        if (!self.model.name||[self.model.name isEqualToString:@""]) self.model.name = self.number;
//        [[DBFile shareInstance] insertRecord:self.model];
//    } error:^(NSInteger num) {
//        
//    }];
    
//    [[DBFile shareInstance] insertRecord:self.model];
    
    
    //直接☎️，不用弹框
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.number]]];
}

- (void) event:(DialEvent *)event{
    if ([event.type isEqualToString:CALL_START_TIME]) {
        self.model.s_time = event.time;
    }else if([event.type isEqualToString:CALL_BEGIN_TIME]){
        self.model.b_time = event.time;
    }else if ([event.type isEqualToString:CALL_END_TIME]){
        if (![self.model.s_time isEqualToString:@""]) self.model.state = @"1";
        else if (![self.model.c_time isEqualToString:@""]&&![self.model.b_time isEqualToString:@""]) self.model.state = @"3";
        else if (![self.model.c_time isEqualToString:@""]) self.model.state = @"2";
        self.model.e_time = event.time;
        
        [ContactFile getAddressBook:^(NSArray *ads) {
            for (NSDictionary *dic in ads) {
                if ([dic[@"user_tell"] isEqualToString:self.number]) {
                    self.model.name = dic[@"dic_name"];
                }
            }
            if ([self.model.name isEqualToString:@""]) self.model.name = self.number;
        } error:^(NSInteger num) {
            
        }];
        
        [[DBFile shareInstance] insertRecord:self.model];
    }else if ([event.type isEqualToString:CALL_CALL_TIME]){
        self.model.state = @"2";
        self.model.c_time = event.time;
    }
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 0, 0, 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellTellNumber *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"callid" forIndexPath:indexPath];    
    cell.call_number.tag = 100+indexPath.row;
    [cell.call_number setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"tell_num%ld_ic1",indexPath.row]] forState:UIControlStateNormal];
    [cell.call_number setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"tell_num%ld_ic2",indexPath.row]] forState:UIControlStateHighlighted];
    [cell.call_number addTarget:self action:@selector(callClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void) callClick:(UIButton *)sender{
    NSInteger tag = sender.tag-100;
    if (tag==9) {
        self.number = [self.number stringByAppendingString:@"*"];
    }else if (tag==11){
        self.number = [self.number stringByAppendingString:@"#"];
    }else if (tag==10){
        self.number = [self.number stringByAppendingString:@"0"];
    }else{
        self.number = [self.number stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)tag+1]];
    }
    self.call_number.text = self.number;
    self.del_num.hidden = false;
    
    self.ret = true;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.call_view.y = KSCREENH-49;
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidetabbarcenter" object:nil userInfo:@{@"ret":[NSNumber numberWithBool:self.ret]}];
}

- (void) hinddenCallView{
    
    if (self.ret){
//        [UIView animateWithDuration:0.2 animations:^{
//            self.call_view.y = KSCREENH-49;
//        } completion:^(BOOL finished) {
//            self.call_view.hidden = false;
//        }];
    }
    else{
        [UIView animateWithDuration:0.2 animations:^{
            self.call_view.y = KSCREENH;
        }];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidetabbarcenter" object:nil userInfo:@{@"ret":[NSNumber numberWithBool:self.ret]}];
}

- (NSString *) newtell:(NSString *)tell{
    return [[[tell stringByReplacingOccurrencesOfString:@"+86" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
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
