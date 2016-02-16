//
//  ChineseString.m
//  30000day
//
//  Created by GuoJia on 16/2/15.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ChineseString.h"
#import "AddressBookModel.h"

@implementation ChineseString

@synthesize string;

@synthesize pinYin;

#pragma mark - 返回tableview右方 indexArray
+ (NSMutableArray*)IndexArray:(NSArray*)addressBookArray {
    
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:addressBookArray];
    
    NSMutableArray *A_Result = [NSMutableArray array];
    
    NSString *tempString ;
    
    for (NSString *object in tempArray)
    {
        if (![Common isObjectNull:((ChineseString *)object).pinYin]) {
            
            NSString *pinyin = [((ChineseString *)object).pinYin substringToIndex:1];
            
            //不同
            if(![tempString isEqualToString:pinyin])
            {
                [A_Result addObject:pinyin];
                
                tempString = pinyin;
            }
            
        }
        
    }
    return A_Result;
}

#pragma mark - 返回联系人
+ (NSMutableArray *)LetterSortArray:(NSArray *)addressBookArray {
    
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:addressBookArray];
    
    NSMutableArray *LetterResult = [NSMutableArray array];
    
    NSMutableArray *item = [NSMutableArray array];
    
    NSString *tempString;
    
    //拼音分组
    for (NSString *object in tempArray) {
        
        ChineseString *chineseString = (ChineseString *)object;
        
        if (![Common isObjectNull:chineseString.pinYin]) {
            
            NSString *pinyin = [((ChineseString *)object).pinYin substringToIndex:1];
            
            //不同
            if(![tempString isEqualToString:pinyin])
            {
                //分组
                item = [NSMutableArray array];
                
                [item  addObject:object];
                
                [LetterResult addObject:item];
                
                //遍历
                tempString = pinyin;
                
            } else {//相同
                
                [item  addObject:object];
            }
            
        }
    }
    
    return LetterResult;
}


///////////////////
//
//返回排序好的字符拼音
//
///////////////////
+ (NSMutableArray *)ReturnSortChineseArrar:(NSArray*)addressBookArray {
    
    //获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    
    for(int i = 0;i < [addressBookArray count];i++) {
        
        ChineseString *chineseString = [[ChineseString alloc]init];
        
        AddressBookModel *bookModel = addressBookArray[i];
        
        chineseString.string = bookModel.name;
        
        chineseString.phoneNumber = bookModel.mobilePhone;
        
        
        if ( chineseString.string == nil ){
            
            chineseString.string = @"";
        }
        
        //去除两端空格和回车
        chineseString.string  = [chineseString.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        chineseString.string = [ChineseString RemoveSpecialCharacter:chineseString.string];
        
        //判断首字符是否为字母
        NSString *regex = @"[A-Za-z]+";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        
        NSString *initialStr = [chineseString.string length]?[chineseString.string substringToIndex:1]:@"";
        
        if ([predicate evaluateWithObject:initialStr]) {
            
            //首字母大写
            chineseString.pinYin = [chineseString.string capitalizedString] ;
            
        } else {
            
            if (![chineseString.string isEqualToString:@""]) {
                
                NSString *pinYinResult = [NSString string];
                
                for(int j=0;j < chineseString.string.length;j++) {
                    
                    NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                     
                                                     pinyinFirstLetter([chineseString.string characterAtIndex:j])] uppercaseString];
                    
                    pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
                }
                
                chineseString.pinYin = pinYinResult;
                
            } else {
                
                chineseString.pinYin = @"";
            }
        }
        
        [chineseStringsArray addObject:chineseString];
    }
    
    //按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    return chineseStringsArray;
}

#pragma mark - 返回一组字母排序数组
+ (NSMutableArray*)SortArray:(NSArray *)addressBookArray {
    
    NSMutableArray *tempArray = [self ReturnSortChineseArrar:addressBookArray];
    
    //把排序好的内容从ChineseString类中提取出来
    NSMutableArray *result = [NSMutableArray array];
    
    for(int i = 0;i < [tempArray count]; i++ ){
        
        [result addObject:((ChineseString*)[tempArray objectAtIndex:i]).string];
    
    }
    
    return result;
}


//过滤指定字符串   里面的指定字符根据自己的需要添加 过滤特殊字符
+ (NSString *)RemoveSpecialCharacter: (NSString *)str {
    
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @",.？、 ~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"]];
    
    if (urgentRange.location != NSNotFound)
    {
        return [self RemoveSpecialCharacter:[str stringByReplacingCharactersInRange:urgentRange withString:@""]];
    }
    return str;
}
@end
