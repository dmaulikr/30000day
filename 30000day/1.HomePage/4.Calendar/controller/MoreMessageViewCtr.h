//
//  MoreMessageViewCtr.h
//  30000天
//
//  Created by 30000天_001 on 14-12-18.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreInfo.h"
#import "addCalendarDelegate.h"

@protocol CalendarNewDelegater

-(void)CalendarNew:(MoreInfo*)info;

@end

@interface MoreMessageViewCtr : ShowBackItemViewController {
    
    FMDatabase *db;
    
    NSString *database_path;
    
}

@property (weak, nonatomic) IBOutlet UITextField *titleTxt;

@property (weak, nonatomic) IBOutlet UITextField *contentTxt;

@property (weak, nonatomic) IBOutlet UIButton *dateBtn;

- (IBAction)timeBtn:(UIButton*)sender;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic , copy)NSString *time;

@property (nonatomic) MoreInfo *moreInfo;

@property (nonatomic, copy)NSString *into;

@property (nonatomic,strong)id<CalendarNewDelegater>CalDelegate;

+(id)initWithTime:(NSString*)time intoMode:(NSString*)into;

+(id)initWithInfo:(MoreInfo*)info intoMode:(NSString*)into;

@end
