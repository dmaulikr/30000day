//
//  MailListManager.m
//  30000day
//
//  Created by GuoJia on 16/5/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MailListManager.h"
#import "ChineseString.h"
#import <AddressBook/AddressBook.h>

@interface MailListManager () <UIAlertViewDelegate>

@property (nonatomic ,strong) NSMutableArray *modelArray;//存储的数组【数组里存储的是chineseString】模型

@property (nonatomic ,strong) NSMutableArray *indexArray;//里面装的NSSting(A,B,C,D.......)

@end

@implementation MailListManager

+ (MailListManager *)shareManager {
    
    static MailListManager *manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[MailListManager alloc] init];
    });
    
    return manager;
}

//同步数据
- (void)synchronizedMailList {
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        
        [self loadData];
        
    } else {
    
        NSString *isFirstStartString = [Common readAppDataForKey:FIRSTSTART];
        
        if ([Common isObjectNull:isFirstStartString]) {
            
            [Common saveAppDataForKey:FIRSTSTART withObject:@"1"];
            
            //提示用户
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"匹配手机通讯录" message:@"30000天将上传手机通讯录至30000天服务器匹配及推荐朋友。\n（上传通讯录仅用于匹配，不会保存资料，亦不会用作它用）" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            
            [alertView show];
            
        } else {
            
            [self loadData];
            
        }
    
    };
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex) {
        
        [self loadData];
        
    }

}

- (void)loadData{

    [STDataHandler sendAddressBooklistRequestCompletionHandler:^(NSMutableArray *chineseStringArray,NSMutableArray *sortArray,NSMutableArray *indexArray) {
        
        self.modelArray = [NSMutableArray array];
        
        self.indexArray = [NSMutableArray arrayWithArray:indexArray];
        
        NSMutableArray *phoneNumberArray = [NSMutableArray array];
        
        for (int i = 0 ; i < chineseStringArray.count ; i++) {
            
            NSMutableArray *subDataArray = chineseStringArray[i];
            
            NSMutableArray *phoneArray = [NSMutableArray array];
            
            for (int j = 0; j < subDataArray.count; j++) {
                
                ChineseString *chineseString = subDataArray[j];
                
                NSString *phoneNumber = chineseString.phoneNumber;
                
                if ([[phoneNumber substringToIndex:1] isEqualToString:@"+"]) {
                    
                    phoneNumber = [phoneNumber substringFromIndex:4];
                }
                
                phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                NSMutableDictionary *phoneNumberDictionary = [NSMutableDictionary dictionary];
                
                [phoneNumberDictionary addParameter:phoneNumber forKey:@"mobile"];
                
                [phoneArray addObject:phoneNumberDictionary];
            }
            
            [phoneNumberArray addObject:phoneArray];
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:phoneNumberArray options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [STDataHandler sendcheckAddressBookWithMobileOwnerId:STUserAccountHandler.userProfile.userId.stringValue addressBookJson:jsonString success:^(NSArray *addressArray) {
            
            NSMutableArray *registerArray = [NSMutableArray array];
            
            NSMutableArray *friendArray = [NSMutableArray array];
            
            for (int i = 0 ; i < addressArray.count; i++) {
                
                NSMutableArray *subDataArray = chineseStringArray[i];
                
                NSDictionary *dictionary = addressArray[i];
                
                NSArray *array = dictionary[@"addressBookList"];
                
                for (int j = 0; j < subDataArray.count; j++) {
                    
                    NSDictionary *dictionary = array[j];
                    
                    ChineseString *chineseString = subDataArray[j];
                    
                    chineseString.status = [dictionary[@"status"] integerValue];
                    
                    if ([dictionary[@"status"] integerValue] == 1) {
                        
                        chineseString.userId = dictionary[@"userId"];
                        
                        [registerArray addObject:chineseString];
                        
                    } else if([dictionary[@"status"] integerValue] == 2){
                        
                        [friendArray addObject:chineseString];
                    }
                }
            }
            
            self.modelArray = chineseStringArray;
            
            [self.modelArray insertObject:registerArray atIndex:0];
            
            [self.modelArray insertObject:friendArray atIndex:1];
            
            if (friendArray.count != 0) {
                
                [self.indexArray insertObject:@"友" atIndex:0];
                
            } else {
                
                [self.indexArray insertObject:@"" atIndex:0];
            }
            
            if (registerArray.count != 0) {
                
                [self.indexArray insertObject:@"+" atIndex:0];
                
            } else {
                
                [self.indexArray insertObject:@"" atIndex:0];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //同步到沙盒
                [self encodeDataObject:self.modelArray withKey:@"modelArray"];
                
                [self encodeDataObject:self.indexArray withKey:@"indexArray"];
                
                //成功的存入沙盒要发送个通知
                [STNotificationCenter postNotificationName:STDidSaveInFileSendNotification object:nil];
            });
            
        } failure:^(NSError *error) {
            
            [STNotificationCenter postNotificationName:STDidSaveInFileSendNotification object:nil];
            
        }];
    }];

}

- (NSMutableArray *)getModelArray {

    return [self decodeObjectwithKey:@"modelArray"];
}

- (NSMutableArray *)getIndexArray {
    
    return [self decodeObjectwithKey:@"indexArray"];
}

- (void)dealloc {
    
    self.indexArray = nil;
    
    self.modelArray = nil;
}

@end
