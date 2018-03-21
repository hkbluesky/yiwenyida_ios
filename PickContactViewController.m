//
//  PickContactViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2017/10/24.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "PickContactViewController.h"
#import "RCDSearchFriendViewController.h"
#import <Contacts/CNContact.h>
#import <ContactsUI/ContactsUI.h>
@interface PickContactViewController()<CNContactPickerDelegate,CNContactViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dateArray;
@end

@implementation PickContactViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    _dateArray = [[NSMutableArray alloc] init];
    CNContactPickerViewController *nav = [[CNContactPickerViewController alloc] init];
    nav.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
    
    [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
}
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    [self.navigationController popViewControllerAnimated:YES];
}


//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
//    RCDSearchFriendViewController *searchView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
//    CNLabeledValue *labeledValue = contact.phoneNumbers[0];
//    CNPhoneNumber *tmp =labeledValue.value;
//    searchView.tel =tmp.stringValue;
//    NSLog(@"%@",searchView.tel);
//    [self.navigationController popViewControllerAnimated:YES];
//}
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact*> *)contacts{
//    for (CNContact *cont in contacts) {
//        NSMutableDictionary *userDic = [[NSMutableDictionary alloc] init];
//        //名字
//        NSString *name = @"";
//        if (cont.familyName) {
//            name = [NSString stringWithFormat:@"%@",cont.familyName];
//        }
//        if (cont.givenName) {
//            name = [NSString stringWithFormat:@"%@%@",name,cont.givenName];
//        }
//        [userDic setObject:name forKey:@"name"];
//        if (cont.organizationName) {
//
//            [userDic setObject:cont.organizationName forKey:@"organizationName"];
//        }
//        if (cont.imageData) {
//            [userDic setObject:[UIImage imageWithData:cont.imageData] forKey:@"image"];
//        }
//        if (cont.phoneNumbers) {
//
//            for (CNLabeledValue *labeValue in cont.phoneNumbers) {
//                CNPhoneNumber *phoneNumber = labeValue.value;
//                NSString *phone = [[phoneNumber.stringValue componentsSeparatedByString:@"-"] componentsJoinedByString:@""];
//                if (phone.length == 11) {
//                    [userDic setObject:phone forKey:@"phone"];
//                }
//            }
//
//        }
//        [_dateArray addObject:userDic];
//
//
//    }
//
//}
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact*> *)contacts{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (CNContact *cont in contacts) {
        if (cont.phoneNumbers) {

            for (CNLabeledValue *labeValue in cont.phoneNumbers) {
                CNPhoneNumber *phoneNumber = labeValue.value;
                NSString *tmp =phoneNumber.stringValue;
//                tmp = [tmp stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//                NSString *phone = [[tmp componentsSeparatedByString:@"-"] componentsJoinedByString:@""];
                NSString *phone = [self myStringFilter:tmp];
                [arr addObject:phone];
                
            }
            

        }
        RCDSearchFriendViewController *searchView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        searchView.tels = arr;
        [self.navigationController popViewControllerAnimated:YES];

    }

}
- (NSString *)myStringFilter:(NSString *)input{
    NSArray *arr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSString *returnStr = @"";
    for(int i=0;i<[input length];i++){
        NSString *c = [input substringWithRange:NSMakeRange(i, 1)];
        if([arr containsObject:c]){
            returnStr = [NSString stringWithFormat:@"%@%@",returnStr,c];
        }
    }
    return returnStr;
}
@end
