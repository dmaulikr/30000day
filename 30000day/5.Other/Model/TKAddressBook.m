//
//  TKAddressBook.m
//  test
//
//  Created by jtun03 on 15-1-6.
//  Copyright (c) 2015年 jtun03. All rights reserved.
//

#import "TKAddressBook.h"
#import "pinyin.h"
#import <AddressBook/AddressBook.h>
#import "ChineseString.h"
#import "FriendListInfo.h"

static TKAddressBook *instance;

@implementation TKAddressBook

- (id)init {
    
    if (self=[super init]) {
        
    }
    
    return self;
}

+ (TKAddressBook *)shareControl {
    
    @synchronized(self){
        
        if (!instance) {
            
            instance=[[TKAddressBook alloc] init];
            
        }
    }
    
    return instance;
}

- (NSMutableDictionary*)getPersonInfoTwo {
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.dataArrayDic = [NSMutableArray arrayWithCapacity:0];
    
    self.sqlFriends = [NSMutableArray arrayWithCapacity:0];
    
    self.booksFriends = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithCapacity:0];//key是lastName,对应跟key这个人的通讯录信息
    
    NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:0];//首字母标题排序之后所存的数组
    
    NSMutableArray *nameArray = [NSMutableArray arrayWithCapacity:0];//姓名排序之后所存的数组'
    
    //取得本地通信录名柄
    ABAddressBookRef addressBook ;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    } else {
        
        addressBook = ABAddressBookCreateWithOptions(addressBook, nil);
        
    }
    
    //取得本地所有联系人记录
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //    NSLog(@"-----%d",(int)CFArrayGetCount(results));
    //    NSLog(@"in %s %d",__func__,__LINE__);
    
    for(int i = 0; i < CFArrayGetCount(results); i++) {
        
        NSMutableDictionary *dicInfoLocal = [NSMutableDictionary dictionaryWithCapacity:0];
        
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        
        //读取firstname     //first 名   last 姓
        NSString *first = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if (first==nil) {
            first = @" ";
        }
        
        [dicInfoLocal setObject:first forKey:@"last"];
        
        NSString *last = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if (last == nil) {
            last = @" ";
        }
        
        [dicInfoLocal setObject:last forKey:@"first"];
        
        ABMultiValueRef tmlphone =  ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        NSString* telphone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmlphone, 0);
        
        if (telphone == nil) {
            telphone = @" ";
        }
        
        [dicInfoLocal setObject:telphone forKey:@"telphone"];
        
        NSLog(@"%@",dicInfoLocal);
        
        CFRelease(tmlphone);
        

//        if ([first isEqualToString:@" "] == NO || [last isEqualToString:@" "]) {
//            [_dataArrayDic addObject:dicInfoLocal];
//        };
        
        if ([first isEqualToString:@" "] == NO && [last isEqualToString:@" "]) {
            
            [_dataArrayDic addObject:dicInfoLocal];
            
        } else if ([first isEqualToString:@" "] && [last isEqualToString:@" "] == NO) {
            
            [_dataArrayDic addObject:dicInfoLocal];
            
        }else if([first isEqualToString:@" "]==NO && [last isEqualToString:@" "] == NO) {
            
            [_dataArrayDic addObject:dicInfoLocal];
            
        }
        
        // 通讯录好友。用于在通讯录显示的。
        FriendListInfo *info = [[FriendListInfo alloc] init];
        
        info.Remarks = [[dicInfoLocal valueForKey:@"last"] stringByAppendingString:[dicInfoLocal valueForKey:@"first"]];
        
        info.FriendPhoneNumber = [dicInfoLocal valueForKey:@"telphone"];
        
        [_booksFriends addObject:info];
        
    }
    
    CFRelease(results);//new
    
    CFRelease(addressBook);//new
    
    NSLog(@"=====%@",_dataArrayDic);
    
    _userInfo=[TKAddressBook shareControl].userInfo;
    
    //在各种排序判断之前加入用户好友
    NSString * url = @"http://116.254.206.7:12580/M/API/GetMyFriends?";
    
    //字符串的拼接
    url = [url stringByAppendingString:@"LoginName="];
    
    url = [url stringByAppendingString:_userInfo.LoginName];
    
    url = [url stringByAppendingString:@"&LoginPassword="];
    
    url = [url stringByAppendingString:_userInfo.LoginPassword];
    
    //*mUrl 就是拼接好的请求地址
    NSMutableString *mUrl=[[NSMutableString alloc] initWithString:url] ;
    
    NSError *error;
    
    NSString *jsonStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:mUrl] encoding:NSUTF8StringEncoding error:&error];
    
    //第三方类库的json解析
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
    NSDictionary * dict = [jsonParser objectWithString:jsonStr error:nil];
    
#warning 好友实例化扔单例，用于外面tableView显示
    //成功就是1
    if (dict != nil) {
        
        for (NSDictionary *dic in dict) {
            
            NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:0];
            
            [newDic setObject:[dic valueForKey:@"FriendSelfNickName"] forKey:@"last"];
            
            [newDic setObject:[dic valueForKey:@"FriendPhoneNumber"] forKey:@"telphone"];
            
            [newDic setObject:[dic valueForKey:@"FriendUserID"] forKey:@"ID"];
            
            [newDic setObject:@"" forKey:@"first"];
            
            [_dataArrayDic addObject:newDic];
            
            //    --------   0..0
            FriendListInfo *ff = [[FriendListInfo alloc] init];
            
            [ff setValuesForKeysWithDictionary:dic];
            
            [_sqlFriends addObject:ff];
            
        }
        
    } else {
        
        NSLog(@"error:%@",error);
    }
    
    for (NSDictionary *object in _dataArrayDic) {
        //for (NSString* str in dic1.allKeys) {
//        for (NSInteger i = 0; i < dic1.allKeys.count; i++) {
//            
//            NSString *str =[object valueForKey:@"last"];
//            NSLog(@"%i",[dic1.allKeys[i] isEqual:str]);
//            if ([dic1.allKeys[i] isEqualToString:str]!=0) {
//                
//                [dic1 setValue:object forKey:[NSString stringWithFormat:@"%@%d",[object valueForKey:@"last"],number++]];
//                [dic1 removeObjectForKey:dic1.allKeys[i]];
//            }
//        }
        
        if ([[object valueForKey:@"last"] isEqualToString:@" "]) {
            
            [_dataArray addObject:[object valueForKey:@"first"]];
            
            [dic1 setValue:object forKey:[object valueForKey:@"first"]];
            
        } else if ([[object valueForKey:@"last"] isEqualToString:@" "]==NO && [[object valueForKey:@"first"] isEqualToString:@" "]==NO) {
            
            NSString* ls=[object valueForKey:@"first"];
            
            ls=[ls stringByAppendingString:[NSString stringWithFormat:@"%@",[object valueForKey:@"last"]]];
            
            [_dataArray addObject:ls];
            
            [dic1 setValue:object forKey:ls];
            
        } else {
            
            [_dataArray addObject:[object valueForKey:@"last"]];
            
            [dic1 setValue:object forKey:[object valueForKey:@"last"]];
        }
    }
    
    //NSLog(@"%@",dic1);
    //NSLog(@"bbbbbbbbbbbbb  %ld",_dataArray.count);
    //排序
    indexArray = [ChineseString IndexArray:_dataArray];
    
    nameArray = [ChineseString LetterSortArray:_dataArray];// 数组里面是数组，按照index分层的数组

    // dic1 是字典，key是lastName，value对应这个人的通讯录
    //建立一个字典，字典保存key是A-Z  值是数组
    NSMutableDictionary*index=[NSMutableDictionary dictionary];//字典的value是数组，数组里面装着字典
    
    NSMutableArray*dic2=[NSMutableArray array];
    
//    NSLog(@"indexArrat%@",indexArray);
//    NSLog(@"nameArrat%@",nameArray[0][0]);
//    NSLog(@"dic1%@",dic1);
    //for (NSInteger i = 0; i < indexArray.count; i++) {
        for (NSInteger j = 0; j<indexArray.count; j++) {
            
            NSMutableArray * count = nameArray[j];
            
            for (NSInteger k=0; k<count.count; k++) {
                //[dic2 addObject:[dic1 valueForKey:[[nameArray objectAtIndex:j]objectAtIndex:k]]];
                
                NSString* ar=count[k];
                
                NSArray* dc=[dic1 valueForKey:ar];
                
                [dic2 addObject:dc];
            }
            
            //NSLog(@"dic2:%@",dic2);
            [index setValue:dic2 forKey:indexArray[j]];
            
            //NSLog(@"dic2:%@,index:%@",dic2,index);
            dic2 = [NSMutableArray array];
        }
    //}
    NSLog(@"index:%@",index);
    
    [self.dataArray addObjectsFromArray:[index allKeys]];
    
    return index;
}

#pragma  mark 字母转换大小写--6.0
- (NSString*)upperStr:(NSString*)str {
    
    //    //全部转换为大写
    //    NSString *upperStr = [str uppercaseStringWithLocale:[NSLocale currentLocale]];
    //    NSLog(@"upperStr: %@", upperStr);
    //首字母转换大写
    //    NSString *capStr = [str capitalizedStringWithLocale:[NSLocale currentLocale]];
    //    NSLog(@"capStr: %@", capStr);
    //    // 全部转换为小写
    NSString *lowerStr = [str lowercaseStringWithLocale:[NSLocale currentLocale]];
    //    NSLog(@"lowerStr: %@", lowerStr);
    return lowerStr;
    
}

#pragma mark 排序
- (NSArray*)sortMethod {
    
    NSArray*array=  [self.dataArray sortedArrayUsingFunction:cmp context:NULL];
    
    return array;
}

//构建数组排序方法SEL
//NSInteger cmp(id, id, void *);
NSInteger cmp(NSString * a, NSString* b, void * p) {
    
    if ([a compare:b] == 1) {
        
        return NSOrderedDescending;//(1)
        
    } else
        
        return  NSOrderedAscending;//(-1)
}

#pragma mark MFMessageComposeViewController 代理方法
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    self.MessageBlock(result);
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}

@end
