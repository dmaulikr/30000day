//
//  ChineseString.h
//  30000day
//
//  Created by GuoJia on 16/2/15.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "pinyin.h"

@interface ChineseString : NSObject

@property(nonatomic,copy)   NSString *string;

@property(nonatomic,strong) NSString *pinYin;

@property(nonatomic,strong) NSString *phoneNumber;

//-----  返回tableview右方indexArray
+ (NSMutableArray*)IndexArray:(NSArray *)addressBookArray;

//-----  返回联系人
+ (NSMutableArray*)LetterSortArray:(NSArray*)addressBookArray;

///----------------------
//返回一组字母排序数组(中英混排)
+ (NSMutableArray*)SortArray:(NSArray *)addressBookArray;

@end
