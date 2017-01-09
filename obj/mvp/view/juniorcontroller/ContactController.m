//
//  ContactController.m
//  DialProject
//
//  Created by 开发者1 on 16/12/30.
//  Copyright © 2016年 jcd. All rights reserved.
//

#import "ContactController.h"
#import "SystemAddressController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "CellContact.h"
#import "FDAlertView.h"

#import "DBFile.h"
#import "ContactFile.h"
#import "RecordModel.h"

@interface ContactController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, ABUnknownPersonViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tx1;
@property (weak, nonatomic) IBOutlet UITextField *tx2;
@property (weak, nonatomic) IBOutlet UISearchBar *search_view;
@property (nonatomic) UISearchController         *search_crl;
@property (nonatomic) NSMutableArray             *data;
@property (nonatomic) NSMutableArray             *mulData;
@property (nonatomic) NSMutableArray             *indexData;
@property (nonatomic) NSString                   *search_text;
@property (nonatomic) NSMutableArray             *search_list;
@property (nonatomic) RecordModel                       *model;
@end
 
@implementation ContactController
{
    __weak IBOutlet UITableView *j_tb;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.data = [NSMutableArray array];
    self.mulData = [NSMutableArray array];
    self.indexData = [NSMutableArray array];
    self.search_list = [NSMutableArray array];
    
    [self createView];
}

- (void) createView{
    self.search_view.delegate = self;
    self.search_view.showsCancelButton = true;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(navigationb)];
    
    j_tb.delegate = self;
    j_tb.dataSource = self;
    j_tb.showsVerticalScrollIndicator = false;
    j_tb.showsHorizontalScrollIndicator = false;
    j_tb.tableFooterView = [[UIView alloc] init];
    j_tb.rowHeight = UITableViewAutomaticDimension;
    j_tb.estimatedRowHeight = 10;
    WeakSelf
    [self loadData];
    j_tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.data removeAllObjects];
        [weakSelf.mulData removeAllObjects];
        [weakSelf.indexData removeAllObjects];
        [weakSelf loadData];
    }];
}

- (void) loadData{
    [ContactFile getAddressBook:^(NSArray *ads) {
        for (id item in ads) {
            [self.data addObject:item];
        }
        
        if (self.data.count>0) {
            for (int i=0; i<self.data.count; ) {
                NSMutableArray *mulArr = [NSMutableArray array];
                NSDictionary *dic = self.data[i];
                NSString *py = dic[@"user_py"];
                for (int x=i; x<self.data.count; x++) {
                    NSDictionary *c_dic = self.data[x];
                    NSString *c_py = c_dic[@"user_py"];
                    if (!py.length && c_py.length) {
                        break;
                    }
                    if (c_py.length) {
                        py = [py substringWithRange:NSMakeRange(0, 1)];
                        c_py = [c_py substringWithRange:NSMakeRange(0, 1)];
                        if ([py isEqualToString:c_py]) {
                            [mulArr addObject:c_dic];
                            i++;
                        }else{
                            break;
                        }
                    }else{
                        [mulArr addObject:c_dic];
                        i++;
                    }
                }
                if (py.length) {
                    [self.indexData addObject:py];
                }
                [self.mulData addObject:mulArr];
            }
        }
        [j_tb reloadData];
        [j_tb.mj_header endRefreshing];
    } error:^(NSInteger index) {
        
    }];
}
- (void) searchData{
    [self.search_list removeAllObjects];
    for (NSDictionary *dic in self.data) {
        NSString *tell = dic[@"user_tell"];
        NSString *name = dic[@"user_name"];
        NSString *py = dic[@"user_py"];
        if ([tell rangeOfString:self.search_text].length>0||[name rangeOfString:self.search_text].length>0||[py rangeOfString:self.search_text].length>0) {
            [self.search_list addObject:dic];
        }
    }
    [j_tb reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.search_text = searchBar.text;
    [self searchData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

//- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.data.count;
//}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==self.mulData.count) {
        return nil;
    }
    NSArray *arr = self.mulData[section];
    NSDictionary *dic = arr[0];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREENW, 20)];
    view.backgroundColor = COLOR_BACK;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 80, 18)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = COLOR_BLACK;
    label.textAlignment = NSTextAlignmentLeft;
    NSString *py = dic[@"user_py"];
    if (py.length) {
        label.text = [py substringWithRange:NSMakeRange(0, 1)];
    }else{
        label.text = @"未备注";
    }
    [view addSubview:label];
    return view;
}
// 索引目录
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (self.search_text.length) return 0;
    return self.indexData;
}
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.search_text.length) return @"";
    if (section == self.mulData.count) {
        return @"";
    }
    NSArray *arr = self.mulData[section];
    NSDictionary *dic = arr[0];
    NSString *py = dic[@"user_py"];
    if (py.length) {
        py = [py substringWithRange:NSMakeRange(0, 1)];
    }else{
        py = @"0";
    }
    return py;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.search_text.length) return 1;
    return self.mulData.count+1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.search_text.length) return self.search_list.count;
    if (section!=self.mulData.count) {
        NSArray *arr = self.mulData[section];
        return arr.count;
    }else{
        return 0;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.search_text.length) return 0.0;
    return 25.0;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.mulData[indexPath.section];
    NSDictionary *dic = self.search_text.length?self.search_list[indexPath.row]:arr[indexPath.row];
    
    static NSString *cellid = @"contactid";
    CellContact *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CellContact" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellid];
        cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    }
    if ([dic[@"user_name"] isEqualToString:@""]) cell.user_message.text = dic[@"user_tell"];
    else cell.user_message.text = dic[@"user_name"];
    return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    /*
     ABPeoplePickerNavigationController
     ABPersonViewController
     ABNewPersonViewController
     ABUnknownPersonViewController
     ABAddressFormatting
     */
//    NSArray *arr = self.mulData[indexPath.section];
//    NSDictionary *dic = self.search_text.length?self.search_list[indexPath.row]:arr[indexPath.row];
//    ABUnknownPersonViewController *npvc = [ABUnknownPersonViewController new];
//    
//    npvc.hidesBottomBarWhenPushed = true;
//    CFErrorRef error =NULL;
//    ABRecordRef personRef=ABPersonCreate();
//    ABMutableMultiValueRef multi=ABMultiValueCreateMutable(kABMultiStringPropertyType);
//    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)(dic[@"user_tell"]), kABPersonPhoneMobileLabel, NULL);
//    ABRecordSetValue(personRef, kABPersonPhoneProperty, multi, &error);
//    npvc.displayedPerson = personRef;
//    npvc.navigationItem.rightBarButtonItem = nil;
//    [self.navigationController pushViewController:npvc animated:true];
    [self callClick:indexPath];
}

- (void) callClick:(NSIndexPath *)indexPath{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:nil icon:nil message:@"请选择功能" buttonTitles:@[@"查看",@"拨打"] callback:^(int buttonIndex, FDAlertView *alert) {
        NSArray *arr = self.mulData[indexPath.section];
        NSDictionary *dic = self.search_text.length?self.search_list[indexPath.row]:arr[indexPath.row];
        
        if (buttonIndex==0) {
            ABUnknownPersonViewController *npvc = [ABUnknownPersonViewController new];
            npvc.hidesBottomBarWhenPushed = true;
            CFErrorRef error =NULL;
            ABRecordRef personRef=ABPersonCreate();
            ABMutableMultiValueRef multi=ABMultiValueCreateMutable(kABMultiStringPropertyType);
            ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)(dic[@"user_tell"]), kABPersonPhoneMobileLabel, NULL);
            ABRecordSetValue(personRef, kABPersonPhoneProperty, multi, &error);
            npvc.displayedPerson = personRef;
            npvc.navigationItem.rightBarButtonItem = nil;
            [self.navigationController pushViewController:npvc animated:true];
        }else if (buttonIndex==1){
            [[NSNotificationCenter defaultCenter] postNotificationName:CALL_CENTER object:nil userInfo:@{@"tell":dic[@"user_tell"]}];
        }
    }];
    [alert show];
}


- (void)unknownPersonViewController:(ABUnknownPersonViewController *)unknownCardViewController didResolveToPerson:(nullable ABRecordRef)person{
    DebugLog(@"unknownPersonViewController");
}

- (IBAction)add:(id)sender {
    NSDateFormatter *matter = [NSDateFormatter new];
    [matter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    RecordModel *model = [RecordModel new];
    model.name = _tx2.text;
    model.tell = _tx1.text;
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
