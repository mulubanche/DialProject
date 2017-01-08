//
//  RecordController.m
//  DialProject
//
//  Created by 开发者1 on 16/12/30.
//  Copyright © 2016年 jcd. All rights reserved.
//

#import "RecordController.h"
#import "RecordListController.h"

#import "CellRecord.h"

#import "DBFile.h"
#import "RecordModel.h"

@interface RecordController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray        *data;

@end

@implementation RecordController
{
    __weak IBOutlet UITableView *j_tb;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [j_tb.mj_header beginRefreshing];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.data = [NSMutableArray array];
    
    j_tb.delegate = self;
    j_tb.dataSource = self;
    j_tb.showsVerticalScrollIndicator = false;
    j_tb.showsHorizontalScrollIndicator = false;
    //j_tb.layoutMargins = UIEdgeInsetsZero;
    //j_tb.preservesSuperviewLayoutMargins = false;
    j_tb.tableFooterView = [[UIView alloc] init];  
    
    [self loadData];
//    WeakSelf
//    j_tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf.data removeAllObjects];
//        [weakSelf loadData];
//    }];

}

- (void) loadData{
    [self.data removeAllObjects];
    NSArray *arr = [[DBFile shareInstance] selecteRecord];
    for (id item in arr) {
        [self.data addObject:item];
    }
    [j_tb reloadData];
    [j_tb.mj_header endRefreshing];
}

- (IBAction)click:(id)sender {
    NSArray *arr = [[DBFile shareInstance] selecteRecordTell:@"18580454341"];
    for (RecordModel *model in arr) {
        DebugLog(@"%@", model.time);
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"recordid";
    CellRecord *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CellRecord" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellid];
        cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.ret = true;
    cell.model = self.data[indexPath.row];
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    RecordModel *model = self.data[indexPath.row];
    RecordListController *svc = [RecordListController new];
    svc.hidesBottomBarWhenPushed = true;
    svc.tell = model.tell;
    [self.navigationController pushViewController:svc animated:true];
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RecordModel *model = self.data[indexPath.row];
        [[DBFile shareInstance] deleteRecord:model.tell];
        [self loadData];
    }
}
- (NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
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
