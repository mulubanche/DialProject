//
//  HomeController.m
//  DialProject
//
//  Created by 开发者1 on 16/12/30.
//  Copyright © 2016年 jcd. All rights reserved.
//

#import "HomeController.h"

#import "CarouselView.h"
#import "CellHomeItem.h"
#import "FDAlertView.h"
#import "InputTellView.h"

@interface HomeController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView             *top_view;
@property (weak, nonatomic) IBOutlet UICollectionView   *item_view;
@property (nonatomic) NSArray                           *data;
@end

@implementation HomeController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:false];
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:false];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.data = @[
                  @{@"title":@"官方网站",@"icon":@"icon_web"},
                  @{@"title":@"在线客服",@"icon":@"icon_contact"},
                  @{@"title":@"号码查询",@"icon":@"icon_search"},
                  @{@"title":@"天气预报",@"icon":@"icon_forecast"},
                  @{@"title":@"更多功能",@"icon":@"icon_apps"},
                  @{@"title":@"充值",@"icon":@"icon_money"},
                  @{@"title":@"查询余额",@"icon":@"icon_rest"},
                  @{@"title":@"更多设置",@"icon":@"icon_setting"},
                  ];
    
    
    [self createView];
}

- (void) createView{
    
    CarouselView *view = [CarouselView newAutoLayoutView];
    [self.top_view addSubview:view];
    
    [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [view autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    view.dataArr = @[@"001.jpg",@"002.jpg",@"003.jpg",@"004.jpg"];
    
    [self.item_view registerNib:[UINib nibWithNibName:@"CellHomeItem" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"homeid"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.itemSize = CGSizeMake((KSCREENW-5)/4, 90);
    
    [self.item_view setCollectionViewLayout:layout];
    self.item_view.delegate = self;
    self.item_view.dataSource = self;
    self.item_view.bounces = false;
    self.item_view.showsVerticalScrollIndicator = false;
    self.item_view.showsHorizontalScrollIndicator = false;
    
    [self.item_view reloadData];
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 0, 0, 1);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CellHomeItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeid" forIndexPath:indexPath];
    cell.dic = self.data[indexPath.row];
    return cell;
}
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
    if (indexPath.row==7) {
        InputTellView *contentView = [[NSBundle mainBundle] loadNibNamed:@"InputTellView" owner:nil options:nil].lastObject;
        FDAlertView *alert = [[FDAlertView alloc] init];
        alert.contentView = contentView;
        [alert show];
        contentView.width = KSCREENW-80;
        contentView.x = 40;
        contentView.selector = ^(BOOL ret, NSString * tell){
            if (ret) {
                [KSUSERDEFAULT setObject:tell forKey:SAVE_SELF_TELL];
                [KSUSERDEFAULT synchronize];
            }
        };
        return;
    }
    [[MyShowLabel shareShowLabel] setText:@"敬请期待..." position:-1];
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
