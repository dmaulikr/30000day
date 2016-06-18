//
//  STGroupTableViewCell.m
//  dream
//
//  Created by WeiGe on 16/6/16.
//  Copyright © 2016年 WeiGe. All rights reserved.
//

#import "STGroupTableViewCell.h"
#import "UIImageView+WebCache.h"

#define imageViewMarginX 20 //imageView左右间隔距离

#define imageViewMarginY 30 //imageView上下间隔距离

#define imageViewTop 20//imageView顶部距离

#define imageViewRowCount 4

#define imageViewWidth ([UIScreen mainScreen].bounds.size.width - imageViewMarginX * (imageViewRowCount + 1)) / imageViewRowCount


@implementation STGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

static BOOL isAdmin;

- (void)setIsMainGroup:(BOOL)isMainGroup {
    
    _isMainGroup = isMainGroup;
    
    isAdmin = isMainGroup;
}

- (void)setMemberMutableArray:(NSMutableArray *)memberMutableArray {
    
     _memberMutableArray = memberMutableArray;

    STGroupCellModel *model = [[STGroupCellModel alloc] init];
    
    [memberMutableArray addObject:model];
    
    if (self.isMainGroup) {//是群主
        
        STGroupCellModel *model = [[STGroupCellModel alloc] init];
        
        [memberMutableArray addObject:model];
    }
    
    for (UIView *view in self.contentView.subviews) {//移除之前设定的
        
        [view removeFromSuperview];
    }

    for (int i = 0; i < _memberMutableArray.count; i++) {
        
        STGroupCellModel *model = _memberMutableArray[i];//取到模型
        
        NSInteger col = i % imageViewRowCount;
        NSInteger row = i / imageViewRowCount;
        
        CGFloat x = col * imageViewWidth + col * imageViewMarginX + imageViewMarginX;
        CGFloat y = row * imageViewWidth + row * imageViewMarginY + imageViewTop;
        CGFloat lableY = row * imageViewWidth + row * imageViewMarginY + imageViewWidth + imageViewTop + 5;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageViewWidth, imageViewWidth)];
        
        [imageView.layer setCornerRadius:5.0f];
        
        [imageView.layer setMasksToBounds:YES];

        if (isAdmin) {//是群主
            
            if (i == _memberMutableArray.count - 2) {
                
                imageView.backgroundColor = [UIColor whiteColor];
                
                imageView.image = [UIImage imageNamed:@"plusSign"];
                
                imageView.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
                
                imageView.layer.borderWidth = 1.0f;
                
            } else if (i == _memberMutableArray.count - 1) {
                
                imageView.backgroundColor = [UIColor whiteColor];
                
                imageView.image = [UIImage imageNamed:@"minusSign"];
                
                imageView.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
                
                imageView.layer.borderWidth = 1.0f;

            } else {
                
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                
                imageView.backgroundColor = [UIColor blackColor];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageViewURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
            
        } else {//非群主
            
          if (i == _memberMutableArray.count - 1) {
                
                imageView.backgroundColor = [UIColor whiteColor];
                
                imageView.image = [UIImage imageNamed:@"plusSign"];
                
                imageView.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
                
                imageView.layer.borderWidth = 1.0f;
                
            } else {
                
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                
                imageView.backgroundColor = [UIColor blackColor];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageViewURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
        }

        [imageView setTag:i];
        
        imageView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        
        [imageView addGestureRecognizer:tap];
        
        if ( i < _memberMutableArray.count - 1) {
            
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(x, lableY, imageViewWidth, 10)];
            
            [lable setTextAlignment:NSTextAlignmentCenter];
            
            [lable setFont:[UIFont systemFontOfSize:12.0f]];
            
            [lable setText:model.title];
            
            [self.contentView addSubview:lable];
        }
    }
}

//计算cell的高度
+ (CGFloat)groupTableViewCellHeight:(NSMutableArray *)memberMutableArray {
    
    NSInteger numberMember = memberMutableArray.count + 1;

    if (isAdmin) {//是群主
        
        numberMember += 1;
    }
    
    CGFloat rowCountFloat =  numberMember / (float)imageViewRowCount;
    
    NSInteger rowCountInt = rowCountFloat;
    
    if (rowCountFloat > rowCountInt) {
        
        rowCountInt += 1;
    }
    
    CGFloat x = rowCountInt * imageViewWidth + rowCountInt * imageViewMarginY + imageViewTop;
    
    return x;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    UIView *view = tap.view;
    
    if (self.memberButtonBlock) {

        self.memberButtonBlock(view.tag,isAdmin);
    }
}


@end

@implementation STGroupCellModel


@end
