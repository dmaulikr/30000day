//
//  HeaderView.h
//  30000day
//
//  Created by wei on 16/4/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property (nonatomic,copy) NSString *productTypeName;
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,strong) NSMutableArray *selectedArr;
@property (nonatomic,copy) void (^(changeStateBlock))(UIButton *changeStatusButton);

@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;

- (void)loadView;
@end
