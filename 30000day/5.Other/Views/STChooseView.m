//
//  STChooseView.m
//  30000day
//
//  Created by GuoJia on 16/9/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STChooseView.h"
#define Margin                5
#define ChooseRowNumber       2 // 每行的个数
#define ChooseSubViewH        35
#define ChooseSubViewMargin   10
#define ChooseSubViewW   (self.width - (ChooseRowNumber + 1) * ChooseSubViewMargin)/ChooseRowNumber
#define SelectedImageString     @"oneSelect"
#define UnSelectedImageString   @"oneNoSelect"

@interface STChooseSubView : UIView

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,assign,getter=isSelected) BOOL selected;//是否被选中，默认是NO
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) void (^clickBlock)(NSInteger index);

- (void)configCellWithMedia:(STChooseItemModel *)itemModel;

@end

@implementation STChooseSubView {
    BOOL _flag;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    if (!self.imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:imageView];
        self.imageView = imageView;
        imageView.userInteractionEnabled = YES;
        //点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [imageView addGestureRecognizer:tap];
    }
    
    if (!self.titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:label];
        self.titleLabel = label;
        //点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:tap];
    }
    //默认是NO
    _flag = NO;
}

//点击事件
- (void)tapAction {
    if (self.clickBlock) {
        self.clickBlock(self.index);
    }
}

- (BOOL)isSelected {
    return _flag;
}

- (void)setSelected:(BOOL)selected {
    _flag = selected;
}

- (void)configCellWithMedia:(STChooseItemModel *)itemModel {
    self.titleLabel.text = itemModel.title;
    if ([itemModel.isChoosed isEqualToNumber:@0]) {//没有选中间
        self.imageView.image  = [UIImage imageNamed:UnSelectedImageString];
        self.selected = NO;
    } else if ([itemModel.isChoosed isEqualToNumber:@1]){//选中的
        self.imageView.image  = [UIImage imageNamed:SelectedImageString];
        self.selected = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //设置坐标
    self.imageView.frame = CGRectMake(Margin,self.height / 2.0f - 10, 20, 20);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + Margin, 0, self.width - self.imageView.width - 3 * Margin, self.height);
}

@end


@interface STChooseView ()

@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation STChooseView

- (id)initWithFrame:(CGRect)frame itemModelArray:(NSMutableArray <STChooseItemModel *>*)dataArray {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self configUIWithItemModelArray:dataArray];
    }
    
    return self;
}

- (void)configUIWithItemModelArray:(NSMutableArray *)dataArray {
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[STChooseSubView class]]) {
            [view removeFromSuperview];
        }
    }

    self.buttonArray = [[NSMutableArray alloc] init];
    self.dataArray = dataArray;
 
    for (int i = 0; i < dataArray.count; i++) {
        
        STChooseSubView *view = [[STChooseSubView alloc] initWithFrame:CGRectZero];
        view.index = i;
        [self addSubview:view];
        [self.buttonArray addObject:view];
        
        STChooseItemModel *model = self.dataArray[i];
        [view configCellWithMedia:model];
        //点击回调
        [view setClickBlock:^(NSInteger index) {
            
            if (!self.isChooseMore) {//单选的时候需要重新设置
                [self resetCurrentItemArrayWithViewWithIndex:index];
                [self resetOtherItemArrayAndViewWithIndex:index];
            } else {
                [self resetCurrentItemArrayWithViewWithIndex:index];
            }
            
            if ([self.delegate respondsToSelector:@selector(chooseView:didSelectWithIndex:)]) {
                [self.delegate chooseView:self didSelectWithIndex:index];
            }
        }];
    }
}

- (void)resetOtherItemArrayAndViewWithIndex:(NSInteger)index {//设置别的
    
    for (int i = 0; i < self.dataArray.count; i++) {//把别的变成1
        
        if (i != index) {
            
            STChooseItemModel *model = self.dataArray[i];
            if ([model.isChoosed isEqualToNumber:@1]) {
                model.isChoosed  = @0;
                STChooseSubView *view = self.buttonArray[i];
                [view configCellWithMedia:model];
            }
        }
    }
}

- (void)resetCurrentItemArrayWithViewWithIndex:(NSInteger)index {
    //设置当前确定的
    STChooseItemModel *indexModel = self.dataArray[index];
    STChooseSubView *indexView = self.buttonArray[index];
    if ([indexModel.isChoosed isEqualToNumber:@0]) {
        indexModel.isChoosed = @1;
    } else if ([indexModel.isChoosed isEqualToNumber:@1]) {
        indexModel.isChoosed = @0;
    }
    [indexView configCellWithMedia:indexModel];
}

- (void)reloadDataWith:(NSMutableArray <STChooseItemModel *>*)newDataArray {
    [self configUIWithItemModelArray:newDataArray];
    [self setNeedsLayout];
}

+ (CGFloat)chooseViewHeight:(NSMutableArray <STChooseItemModel *>*)dataArray {
    
    NSUInteger rows = (dataArray.count + ChooseRowNumber - 1)/ChooseRowNumber;
    
    if (rows == 0) {
        return 0;
    } else {
        CGFloat viewHeight  = rows * ChooseSubViewH + (rows - 1) * ChooseSubViewMargin;
        return viewHeight;
    }
}

- (void)setIsChooseMore:(BOOL)isChooseMore {
    _isChooseMore = isChooseMore;
}

//获取所有选中的itemArray
- (NSMutableArray <STChooseItemModel *>*)getSelectedChooseItemArray {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        STChooseItemModel *model = self.dataArray[i];
        if ([model.isChoosed isEqualToNumber:@1]) {//得到选中的
            [dataArray addObject:model];
        }
    }
    return dataArray;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i = 0; i < self.buttonArray.count; i++) {
        
        STChooseItemView *view = self.buttonArray[i];//取出其中每一个imageView
        
        int col = i % ChooseRowNumber;
        int row = i / ChooseRowNumber;
        
        view.x  = col * (ChooseSubViewW + ChooseSubViewMargin) + 10;
        view.y  = row * (ChooseSubViewH + ChooseSubViewMargin);
        view.width =  ChooseSubViewW;
        view.height = ChooseSubViewH;
    }
}

@end
