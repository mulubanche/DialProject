//
//  ContactFile.m
//  DialProject
//
//  Created by 开发者1 on 17/1/3.
//  Copyright © 2017年 jcd. All rights reserved.
//

#import "ContactFile.h"

#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

#define USER_TELL @"user_tell"
#define USER_PY @"user_py"
#define USER_NAME @"user_name"
#define USER_ICON @"";

@implementation ContactFile

+ (void) getAddressBook:(void(^)(NSArray *ads))books error:(void(^)(NSInteger))ero{
    
    ContactFile *tool = [ContactFile new];
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    //用户授权
//    WeakSelf
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {//首次访问通讯录
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (!error) {
                if (granted) {//允许
                    NSArray *contacts = [tool fetchContactWithAddressBook:addressBook];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        books([tool usersort:contacts]);
                    });
                }else{
                    //拒绝授权
                    ero(1);
                }
            }else{
                //打开失败
                ero(2);
            }
        });
    }else{//非首次访问通讯录
        NSArray *contacts = [tool fetchContactWithAddressBook:addressBook];
        dispatch_async(dispatch_get_main_queue(), ^{
            books([tool usersort:contacts]);
        });
    }
}

- (NSMutableArray *)fetchContactWithAddressBook:(ABAddressBookRef)addressBook{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {////有权限访问
        //获取联系人数组
        NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSMutableArray *contacts = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            //获取联系人
            ABRecordRef people = CFArrayGetValueAtIndex((__bridge ABRecordRef)array, i);
            //获取联系人详细信息,如:姓名,电话,住址等信息
            NSString *firstName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
            ABMutableMultiValueRef phoneNumRef = ABRecordCopyValue(people, kABPersonPhoneProperty);
            NSString *phoneNumber =  ((__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneNumRef)).lastObject;
            //            [contacts addObject:@{@"name": [firstName stringByAppendingString:lastName], @"phoneNumber": phoneNumber}];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (!firstName) {
                firstName = @"";
            }
            if (!lastName) {
                lastName = @"";
            }
            NSString *name = [NSString stringWithFormat:@"%@%@", lastName, firstName];
            NSString *name_py = [self transform:name];
            [dic setValue:[NSString stringWithFormat:@"%@%@", lastName, firstName] forKey:USER_NAME];
            [dic setValue:phoneNumber forKey:USER_TELL];
            [dic setValue:name_py forKey:USER_PY];
            [contacts addObject:dic];
        }
        return contacts;
    }else{//无权限访问
        DebugLog(@"无权限访问通讯录");
        return nil;
    }
}


#pragma mark 联系人拼音
- (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [[pinyin uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
}
#pragma mark 根据首字母排序
- (NSArray *) usersort:(NSArray *)data{
    //    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        [arr addObject:dic[USER_PY]];
    }
    NSArray *dataArr = [arr sortedArrayUsingSelector:@selector(compare:)];
    [arr removeAllObjects];
    for (NSString *item in dataArr) {
        for (NSDictionary *dic in data) {
            if ([item isEqualToString:dic[USER_PY]]) {
                [arr addObject:dic];
                break;
            }
        }
    }
    
    return arr;
}

@end
