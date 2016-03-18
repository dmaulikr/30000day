//
//  QGRecordDetailHeadView.h
//  QGym
//
//  Created by win5 on 9/28/15.
//  Copyright (c) 2015 win5. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击了哪个按钮
typedef enum{
    
    QGSwtichBtnFirstType,
    
    QGSwtichBtnSecondType,
    
}QGSwtichBtnType;

@interface QGRecordDetailSwitchHeadView: UIView

@property (weak, nonatomic) IBOutlet UIView *view_1;

@property (weak, nonatomic) IBOutlet UIView *view_2;

@property(nonatomic,copy) void (^(ClickBlock))(QGSwtichBtnType);

@property (weak, nonatomic) IBOutlet UIButton *btn_1;

@property (weak, nonatomic) IBOutlet UIButton *btn_2;

@end
