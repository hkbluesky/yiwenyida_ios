//
//  PickMultiContactViewController.m
//  SealTalk
//
//  Created by ChrisLaw on 2017/10/26.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

#import "PickMultiContactViewController.h"
#import "RCDSearchFriendViewController.h"
#import <Contacts/CNContact.h>
#import <ContactsUI/ContactsUI.h>
@interface PickMultiContactViewController ()
@property (nonatomic, strong) NSMutableArray *dateArray;
@end

@implementation PickMultiContactViewController

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

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact*> *)contacts{
    for (CNContact *cont in contacts) {
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc] init];
    //名字
    NSString *name = @"";
    if (cont.familyName) {
        name = [NSString stringWithFormat:@"%@",cont.familyName];
    }
    if (cont.givenName) {
        name = [NSString stringWithFormat:@"%@%@",name,cont.givenName];
    }
    [userDic setObject:name forKey:@"name"];
    if (cont.organizationName) {
        
        [userDic setObject:cont.organizationName forKey:@"organizationName"];
    }
    if (cont.imageData) {
        [userDic setObject:[UIImage imageWithData:cont.imageData] forKey:@"image"];
    }
    if (cont.phoneNumbers) {
        
        for (CNLabeledValue *labeValue in cont.phoneNumbers) {
            CNPhoneNumber *phoneNumber = labeValue.value;
            NSString *phone = [[phoneNumber.stringValue componentsSeparatedByString:@"-"] componentsJoinedByString:@""];
            if (phone.length == 11) {
                [userDic setObject:phone forKey:@"phone"];
            }
        }
        
    }
    [_dateArray addObject:userDic];
    
    
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
