//
//  STDropdownMenu.h
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STDropdownMenu;

@protocol STDropdownMenuDelegate <NSObject>

@optional

- (void)dropdownMenuDidDismiss:(STDropdownMenu *)dropdownMenu;

- (void)dropdownMenuDidShow:(STDropdownMenu *)dropdownMenu;

- (void)dropdownMenu:(STDropdownMenu *)dropdownMenu didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface STDropdownMenu : UIView

+ (instancetype)menu;

- (void)showView;

- (void)dismiss;

@property(nonatomic,retain)NSMutableArray *dataArray;//设置数据源

@property(nonatomic,strong)id <STDropdownMenuDelegate>delegate;

@end
