//
//  NavigationBarView.m
//  30000day
//
//  Created by wei on 16/2/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "NavigationBarView.h"

@interface NavigationBarView()
@property (nonatomic,assign)CGFloat viewWidth;
@property (nonatomic,assign)CGFloat viewHeight;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,assign)NSInteger arrayCount;
@end

@implementation NavigationBarView

- (instancetype)initWithFrame:(CGRect)frame withWidth:(CGFloat)width withArray:(NSArray *)arr {
    self=[super initWithFrame:frame];
    if (self) {
        self.viewWidth=width;
        self.titleArray=arr;
        self.arrayCount=arr.count;
    }
    return self;
}



@end
