//
//  PersonViewController.h
//  30000day
//
//  Created by GuoJia on 16/1/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PersonViewController : STRefreshViewController

//YES：表示需要显示
@property (nonatomic,copy) void (^callback)(NSInteger);

@end
