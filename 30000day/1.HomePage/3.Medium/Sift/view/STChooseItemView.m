//
//  STChooseItemView.m
//  30000day
//
//  Created by GuoJia on 16/8/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STChooseItemView.h"

#define ChooseItemViewH 40
#define ChooseItemViewMargin 10
#define ChooseNumber       3
#define ChooseItemViewW  (self.width - (ChooseNumber + 1) * ChooseItemViewMargin)/ChooseNumber
#define Button_string         @"close_btn"


@interface STChooseItemSubView : UIView

@property (nonatomic,assign)   NSInteger index;
@property (nonatomic,copy)     void (^cancelButtonClickBlock)(NSInteger index);
@property (nonatomic,copy)     void (^superButtonClickBlock)(NSInteger index);

@property (nonatomic, strong)  UIButton *superButton;
@property (nonatomic, strong)  UIButton *button;

- (void)configCellWithMedia:(STChooseItemModel *)itemModel;

@end

@implementation STChooseItemSubView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    if (!self.superButton) {
        self.superButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.superButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.superButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.superButton addTarget:self action:@selector(superButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.superButton];
    }
    
    if (!self.button) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setImage:[UIImage imageNamed:Button_string] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
    }
    
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    self.layer.borderWidth = 0.7f;
}

- (void)buttonClick {
    
    if (self.cancelButtonClickBlock) {
        self.cancelButtonClickBlock(self.index);
    }
}

- (void)superButtonClick {
 
    if (self.superButtonClickBlock) {
        self.superButtonClickBlock(self.index);
    }
}

- (void)configCellWithMedia:(STChooseItemModel *)itemModel {
    
    [self.superButton setTitle:itemModel.title forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.superButton.frame = CGRectMake(0, 0,self.width, self.height);
    self.button.frame = CGRectMake(self.superButton.width - 20, 0, 20, 20);
}

@end


@interface STChooseItemView ()

@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation STChooseItemView

- (id)initWithFrame:(CGRect)frame itemModelArray:(NSMutableArray <STChooseItemModel *>*)dataArray {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
        [self configUIWithItemModelArray:dataArray];
    }
    
    return self;
}

- (void)setup {
    self.showCancelButton = YES;
}

- (void)configUIWithItemModelArray:(NSMutableArray <STChooseItemModel *>*)dataArray {
    
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[STChooseItemSubView class]]) {
            [view removeFromSuperview];
        }
    }

    self.buttonArray = [[NSMutableArray alloc] init];
    self.dataArray = dataArray;
    
    for (int i = 0; i < dataArray.count; i++) {
        
        STChooseItemSubView *subView = [[STChooseItemSubView alloc] initWithFrame:CGRectZero];
        subView.index = i;
        [self addSubview:subView];
        [self.buttonArray addObject:subView];
        
        STChooseItemModel *model = self.dataArray[i];
        [subView configCellWithMedia:model];
        //点击删除button
        [subView setCancelButtonClickBlock:^(NSInteger index) {
            
            if ([self.delegate respondsToSelector:@selector(chooseItemView:didTapCancelButtonWithIndex:)]) {
                [self.delegate chooseItemView:self didTapCancelButtonWithIndex:index];
            }
        }];
        //点击
        [subView setSuperButtonClickBlock:^(NSInteger index) {
            
            if ([self.delegate respondsToSelector:@selector(chooseItemView:didSelectWithIndex:)]) {
                [self.delegate chooseItemView:self didSelectWithIndex:index];
            }            
        }];
        
        subView.button.hidden = !self.showCancelButton;
    }
}

- (void)setShowCancelButton:(BOOL)showCancelButton {
    _showCancelButton = showCancelButton;
    
    if (showCancelButton) {
        
        for (int i = 0; i < self.buttonArray.count; i++) {
            
            STChooseItemSubView *subView = self.buttonArray[i];
            subView.button.hidden = NO;
        }
        
    } else {
        
        for (int i = 0; i < self.buttonArray.count; i++) {
            
            STChooseItemSubView *subView = self.buttonArray[i];
            subView.button.hidden = YES;
        }
    }
}

- (void)reloadDataWith:(NSMutableArray <STChooseItemModel *>*)newDataArray {
    [self configUIWithItemModelArray:newDataArray];
    [self setNeedsLayout];
}

+ (CGFloat)chooseItemViewHeight:(NSMutableArray <STChooseItemModel *>*)dataArray {
    
    NSUInteger rows = (dataArray.count + ChooseNumber - 1)/ChooseNumber;
    
    if (rows == 0) {
        return 0;
    } else {
        CGFloat viewHeight  = rows * ChooseItemViewH + (rows - 1) * ChooseItemViewMargin;
        return viewHeight;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i = 0; i < self.buttonArray.count; i++) {
        
        STChooseItemView *view = self.buttonArray[i];//取出其中每一个imageView
        
        int col = i % ChooseNumber;
        int row = i / ChooseNumber;
        
        view.x  = col * (ChooseItemViewW + ChooseItemViewMargin) + 10;
        view.y  = row * (ChooseItemViewH + ChooseItemViewMargin);
        view.width =  ChooseItemViewW;
        view.height = ChooseItemViewH;
    }
}

@end

@implementation STChooseItemModel

@end