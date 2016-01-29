//
//  TKAddressBook.h
//  test
//
//  Created by jtun03 on 15-1-6.
//  Copyright (c) 2015年 jtun03. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <AddressBookUI/AddressBookUI.h>

enum {
    ABHelperCanNotConncetToAddressBook,
    ABHelperExistSpecificContact,
    ABHelperNotExistSpecificContact
};

typedef NSUInteger ABHelperCheckExistResultType;

@interface TKAddressBook : NSObject <MFMessageComposeViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate> {
    
}

//保存排序好的数组
@property(nonatomic,retain)NSMutableArray *dataArray;

//数组里面保存每个获取名片
@property(nonatomic,retain)NSMutableArray *dataArrayDic;

// 通讯录跟数据库所有好友的数组
@property (nonatomic, retain)NSMutableArray *allFriends;

@property (nonatomic,strong)UserInfo *userInfo;

//通讯录对象数组
@property (nonatomic, retain)NSMutableArray *booksFriends;

//数据库好友对象数组
@property (nonatomic, retain)NSMutableArray *sqlFriends;

@property(nonatomic,copy)void(^MessageBlock)(int);

@property(nonatomic,assign) id target;

@property(nonatomic,copy)void(^PhoneBlock)(BOOL,NSDictionary*);

#pragma mark 获得单例
+(TKAddressBook*)shareControl;

#pragma mark 获取通讯录中的内容
-(NSArray*)sortMethod;

-(NSMutableDictionary*)getPersonInfoTwo;

@end
