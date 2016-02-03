//
//  MailListViewController.m
//  30000day
//
//  Created by wei on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MailListViewController.h"
#import <AddressBook/AddressBook.h>
#import "mailList.h"

@interface MailListViewController ()
@property (nonatomic,strong)NSMutableArray* mailListArray;
@end

@implementation MailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mailListArray=[NSMutableArray array];
    [self loadPerson];
    
    
    for (int i=0; i<self.mailListArray.count; i++) {
        mailList* ms=self.mailListArray[i];
        NSLog(@"%@",ms.name);
        NSLog(@"%@",ms.mobilePhone);
    }
    
}

- (void)loadPerson
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            [self copyAddressBook:addressBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        [self copyAddressBook:addressBook];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            //[hud turnToError:@"没有获取通讯录权限"];
        });
    }
}

- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for ( int i = 0; i < numberOfPeople; i++){
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++){
            //获取电话Label
            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            
            if ([personPhoneLabel isEqualToString:@"mobile"]) {
                //获取該Label下的电话值
                NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                NSLog(@"%@",personPhone);
                NSString* name;
                mailList* ml=[[mailList alloc]init];
                if (firstName!=nil && lastName!=nil) {
                    name=[lastName stringByAppendingString:firstName];
                }
                
                if (firstName!=nil && lastName==nil) {
                    name=firstName;
                }
                
                if (firstName==nil && lastName!=nil) {
                    name=lastName;
                }
                
                ml.name=name;
                ml.mobilePhone=personPhone;
                
                [self.mailListArray addObject:ml];
                break;
            }
        }
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
