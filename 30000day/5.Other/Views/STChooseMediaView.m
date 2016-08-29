//
//  STChooseMediaView.m
//  30000day
//
//  Created by GuoJia on 16/8/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STChooseMediaView.h"


#define Corver_image_string   @"MessageVideoPlay"
#define ChooseItemViewMargin  10
#define ChooseItemViewW       (self.width - (self.maxRowChooseMediaNum + 1) * ChooseItemViewMargin)/self.maxRowChooseMediaNum
#define ChooseItemViewH       ChooseItemViewW
#define Button_string         @"close_btn"


@interface STChooseMediaSubView : UIView

@property (nonatomic,assign)   NSInteger index;
@property (nonatomic,copy)     void (^cancelButtonClickBlock)(NSInteger index);
@property (nonatomic,copy)     void (^imageTapClickBlock)(NSInteger index);

@property (nonatomic, strong)  UIButton *cancelButton;
@property (nonatomic, strong)  UIImageView *coverImageView;
@property (nonatomic, strong)  UIImageView *imageView;

- (void)configCellWithMedia:(STChooseMediaModel *)mediaModal;

@end

@implementation STChooseMediaSubView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    if (!self.imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        
        //点击行动
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [imageView addGestureRecognizer:tap];
        self.imageView = imageView;
    }
    
    if (!self.cancelButton) {
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setImage:[UIImage imageNamed:Button_string] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
    }
    
    if (!self.coverImageView) {
        self.coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:Corver_image_string]];
        [self.imageView addSubview:self.coverImageView];
        self.coverImageView.hidden = YES;
    }
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = RGBACOLOR(230, 230, 230, 1).CGColor;
    self.layer.borderWidth = 0.7f;
}

- (void)cancelButtonClick {
    
    if (self.cancelButtonClickBlock) {
        self.cancelButtonClickBlock(self.index);
    }
}

- (void)tapAction {
    
    if (self.imageTapClickBlock) {
        self.imageTapClickBlock(self.index);
    }
}

- (void)configCellWithMedia:(STChooseMediaModel *)mediaModal {
    
    if (mediaModal.mediaType == STChooseMediaPhotoType) {
        
        self.imageView.image = mediaModal.coverImage;
        self.coverImageView.hidden = YES;
        
    } else if (mediaModal.mediaType == STChooseMediaVideoType) {
        
        self.imageView.image = mediaModal.coverImage;
        self.coverImageView.hidden = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0,self.width, self.height);
    self.cancelButton.frame = CGRectMake(self.imageView.width - 20, 0, 20, 20);
    self.coverImageView.width = self.imageView.width / 2.50f;
    self.coverImageView.height = self.imageView.width / 2.50f;
    self.coverImageView.center = self.imageView.center;
}

@end

@interface STChooseMediaView ()

@property (nonatomic,strong) STChooseMediaSubView *originSubView;
@property (nonatomic,strong) NSMutableArray *viewArray;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation STChooseMediaView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    if (!self.originSubView) {
        STChooseMediaSubView *subView = [[STChooseMediaSubView alloc] init];
        subView.imageView.image = [UIImage imageNamed:@"plusSign"];
        [self addSubview:subView];
        self.originSubView = subView;
        subView.cancelButton.hidden = YES;
        subView.coverImageView.hidden = YES;
        //点击回调
        [subView setImageTapClickBlock:^(NSInteger index) {
            
            if ([self.delegate respondsToSelector:@selector(chooseMediaView:addActionIndex:)]) {
                [self.delegate chooseMediaView:self addActionIndex:self.viewArray.count];
            }
        }];
    }
    self.viewArray = [[NSMutableArray alloc]  init];
    self.dataArray = [[NSMutableArray alloc] init];
    self.maxChooseMediaNum = 3;
    self.maxRowChooseMediaNum = 3;
}

- (void)setMaxChooseMediaNum:(NSInteger)maxChooseMediaNum {
    _maxChooseMediaNum = maxChooseMediaNum;
}

- (void)setMaxRowChooseMediaNum:(NSInteger)maxRowChooseMediaNum {
    _maxRowChooseMediaNum = maxRowChooseMediaNum;
}

- (void)reloadMediaViewWithModelArray:(NSMutableArray <STChooseMediaModel *>*)dataArray {
    
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[STChooseMediaSubView class]] && (view != self.originSubView)) {
            [view removeFromSuperview];
        }
    }
    
    self.viewArray = [[NSMutableArray alloc] init];
    self.dataArray = dataArray;
    
    for (int i = 0; i < dataArray.count; i++) {
        
        STChooseMediaSubView *subView = [[STChooseMediaSubView alloc] initWithFrame:CGRectZero];
        subView.index = i;
        [self addSubview:subView];
        [self.viewArray addObject:subView];
        
        STChooseMediaModel *model = self.dataArray[i];
        [subView configCellWithMedia:model];
        //点击删除button
        [subView setCancelButtonClickBlock:^(NSInteger index) {
            
            if ([self.delegate respondsToSelector:@selector(chooseMediaView:didTapCancelButtonWithIndex:)]) {
                [self.delegate chooseMediaView:self didTapCancelButtonWithIndex:index];
            }
        }];
        //点击
        [subView setImageTapClickBlock:^(NSInteger index) {
            if ([self.delegate respondsToSelector:@selector(chooseMediaView:didSelectWithIndex:)]) {
                [self.delegate chooseMediaView:self didSelectWithIndex:index];
            }
        }];
    }
    [self setNeedsLayout];
}

+ (CGFloat)mediaViewHeight:(NSMutableArray <STChooseMediaModel *>*)dataArray mediaViewWidth:(CGFloat)mediaViewWidth maxChooseMediaNum:(NSUInteger)maxChooseMediaNum maxRowChooseMediaNum:(NSUInteger)maxRowChooseMediaNum {
    
    if (maxChooseMediaNum > dataArray.count) {
        
        NSUInteger rows = (dataArray.count + maxRowChooseMediaNum)/maxRowChooseMediaNum;
        CGFloat viewHeight  = rows * ((mediaViewWidth - (maxRowChooseMediaNum + 1) * ChooseItemViewMargin)/maxRowChooseMediaNum) + (rows - 1) * ChooseItemViewMargin;
        return viewHeight;
        
    } else {
     
        NSUInteger rows = (dataArray.count + maxRowChooseMediaNum - 1)/maxRowChooseMediaNum;
        CGFloat viewHeight  = rows * ((mediaViewWidth - (maxRowChooseMediaNum + 1) * ChooseItemViewMargin)/maxRowChooseMediaNum) + (rows - 1) * ChooseItemViewMargin;
        return viewHeight;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i = 0; i < self.viewArray.count; i++) {
        
        STChooseMediaSubView *view = self.viewArray[i];//取出其中每一个imageView
        
        int col = i % self.maxRowChooseMediaNum;
        int row = i / self.maxRowChooseMediaNum;
        
        view.x  = col * (ChooseItemViewW + ChooseItemViewMargin) + 10;
        view.y  = row * (ChooseItemViewH + ChooseItemViewMargin);
        view.width =  ChooseItemViewW;
        view.height = ChooseItemViewH;
    }
    
    if (self.maxChooseMediaNum > self.viewArray.count) {//
        
        NSInteger col = self.viewArray.count % self.maxRowChooseMediaNum;
        NSInteger row = self.viewArray.count / self.maxRowChooseMediaNum;
        
        self.originSubView.x  = col * (ChooseItemViewW + ChooseItemViewMargin) + 10;
        self.originSubView.y  = row * (ChooseItemViewH + ChooseItemViewMargin);
        self.originSubView.width =  ChooseItemViewW;
        self.originSubView.height = ChooseItemViewH;
    }
}

@end
