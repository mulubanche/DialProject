//
//  RecordListController.m
//  DialProject
//
//  Created by 班车陌路 on 2017/1/7.
//  Copyright © 2017年 jcd. All rights reserved.
//

#import "RecordListController.h"

#import "CellRecord.h"

#import "DBFile.h"
#import "RecordModel.h"

@interface RecordListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView   *j_tb;
@property (nonatomic) NSArray   *data;

@end

@implementation RecordListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通话详情";
    [self createView];
    [self loadData];
}

- (void) createView{
    self.j_tb = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KSCREENW, KSCREENH-64) style:UITableViewStylePlain];
    self.j_tb.delegate = self;
    self.j_tb.dataSource = self;
    self.j_tb.showsVerticalScrollIndicator = false;
    self.j_tb.showsHorizontalScrollIndicator = false;
    self.j_tb.tableFooterView = [UIView new];
    [self.view addSubview:self.j_tb];
}

- (void) loadData{
    self.data = [[DBFile shareInstance] selecteRecordTell:self.tell];
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
    cell.ret = false;
    cell.model = self.data[indexPath.row];
    return cell;
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
