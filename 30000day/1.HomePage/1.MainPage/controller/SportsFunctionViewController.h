//
//  SportsFunctionViewController.h
//  30000day
//
//  Created by WeiGe on 16/7/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportsFunctionViewController : UIViewController

@property (nonatomic,assign) BOOL type; //0 语音播报 1 设置地图

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) NSInteger selectIndex;

@end
