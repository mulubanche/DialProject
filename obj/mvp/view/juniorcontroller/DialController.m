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

#import "Soaper.h"

@interface DialController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *call_view;
@property (weak, nonatomic) IBOutlet UIView *num_view;
@property (weak, nonatomic) IBOutlet UIView *ban_view;
@property (weak, nonatomic) IBOutlet UICollectionView *clct_view;
@property (weak, nonatomic) IBOutlet UILabel *call_number;
@property (weak, nonatomic) IBOutlet UIButton *del_num;
@property (nonatomic) NSString       *number;
@property (nonatomic, assign) BOOL          ret;

@end

@implementation DialController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:false];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.number = @"";
    [self createView];
}

- (void) createView{
//    CarouselView *view = [[CarouselView alloc] initWithFrame:CGRectMake(0, 0, self.ban_view.width, self.ban_view.height)];
    CarouselView *view = [CarouselView newAutoLayoutView];
    [self.ban_view addSubview:view];
    
    [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [view autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    view.dataArr = @[@"001.jpg",@"002.jpg",@"003.jpg",@"004.jpg"];
    
    self.call_view.layer.borderColor = [UIColor grayColor].CGColor;
    self.call_view.layer.borderWidth = 1;
    self.del_num.adjustsImageWhenHighlighted = false;
    
    
    [self.clct_view registerNib:[UINib nibWithNibName:@"CellTellNumber" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"callid"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.itemSize = CGSizeMake((KSCREENW-4)/3, 50);
    
    self.call_view.hidden = true;
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
- (IBAction)sureCallClick:(UIButton *)sender {
    /*
     properties.put("callerE164", SPUtils.getUserID(getActivity()));
     properties.put("calleeE164s", phone);
     properties.put("accessE164", "10081");
     properties.put("accessE164Password", "891210");
     */
    WeakSelf
    [ToolFile judgeSaveTellIsShow:true block:^() {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"callerE164"] = [KSUSERDEFAULT objectForKey:SAVE_SELF_TELL];
        dic[@"calleeE164s"] = weakSelf.number;
        dic[@"accessE164"] = @"10081";
        dic[@"accessE164Password"] = @"891210";
        [Soaper connectUrl:[NSString stringWithFormat:@"%@%@", CODE_URL, COSSERVICE] Method:COSS_CALL_BACK Param:dic Success:^(NSDictionary *rawDic, NSString *rawStr) {
            DebugLog(@"%@", rawDic);
        } Error:^(NSString *errMsg, NSString *rawStr) {
            DebugLog(@"%@", errMsg);
            //服务器无法为请求提供服务，因为不支持该媒体类型。
        }];
    }];
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
    } completion:^(BOOL finished) {
        self.call_view.hidden = false;
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
