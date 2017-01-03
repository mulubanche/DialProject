//
//  RecordController.m
//  DialProject
//
//  Created by 开发者1 on 16/12/30.
//  Copyright © 2016年 jcd. All rights reserved.
//

#import "RecordController.h"

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
    
    WeakSelf
    [self loadData];
    j_tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.data removeAllObjects];
        [weakSelf loadData];
    }];

}

- (void) loadData{
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
    cell.model = self.data[indexPath.row];
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSDateFormatter *matter = [NSDateFormatter new];
    [matter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    RecordModel *model = [RecordModel new];
    model.name = @"陌路班车";
    model.tell = @"18580454341";
    model.state = [NSString stringWithFormat:@"%d", rand()%3+1];
    model.icon = @"";
    model.time = [matter stringFromDate:[NSDate date]];
    if ([[DBFile shareInstance] insertRecord:model]) {
        DebugLog(@"添加成功");
    }else{
        DebugLog(@"添加失败");
    }
    
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
