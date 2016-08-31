//
//  STChooseItemCell.m
//  30000day
//
//  Created by GuoJia on 16/8/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STChooseItemCell.h"
#import "STChooseItemView.h"
#import "STChooseItemManager.h"

#define Margin  10


@interface STChooseItemCell () <STChooseItemViewDelegate>
@property (nonatomic,strong) STChooseItemView *itemView;
@property (nonatomic,strong) STChooseItemView *willChooseItemView;

@property (nonatomic,strong) NSMutableArray *choosedArray;
@property (nonatomic,strong) NSMutableArray *willChooseArray;

@property (nonatomic,strong) UILabel *willChooseTitleLabel;//即将
@property (nonatomic,strong) UILabel *choosedTitleLabel;//已经选择
@property (nonatomic,strong) NSNumber *visibleType;//0自己，1好友 2公开

@end

@implementation STChooseItemCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier visibleType:(NSNumber *)visibleType {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUIWithVisibleType:visibleType];
    }
    return self;
}

- (void)configUIWithVisibleType:(NSNumber *)visibleType {
    
    self.visibleType = visibleType;
    
    self.choosedArray = [STChooseItemManager choosedItemArrayWithUserId:STUserAccountHandler.userProfile.userId visibleType:visibleType];
    self.willChooseArray = [STChooseItemManager willChooseItemArrayWithUserId:STUserAccountHandler.userProfile.userId visibleType:visibleType];
    
    if (!self.itemView) {
        self.itemView = [[STChooseItemView alloc] initWithFrame:CGRectZero itemModelArray:self.choosedArray];
        self.itemView.delegate = self;
        [self.contentView addSubview:self.itemView];
    }
    
    if (!self.willChooseItemView) {
        self.willChooseItemView = [[STChooseItemView alloc] initWithFrame:CGRectZero itemModelArray:self.willChooseArray];
        self.willChooseItemView.showCancelButton = NO;
        self.willChooseItemView.delegate = self;
        [self.contentView addSubview:self.willChooseItemView];
    }
    
    if (!self.willChooseTitleLabel) {
        
        self.willChooseTitleLabel = [[UILabel alloc] init];
        self.willChooseTitleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.willChooseTitleLabel.textColor = [UIColor lightGrayColor];
        self.willChooseTitleLabel.text = @"点击添加更多";
        [self.contentView addSubview:self.willChooseTitleLabel];
    }
    
    if (!self.choosedTitleLabel) {
        
        self.choosedTitleLabel = [[UILabel alloc] init];
        self.choosedTitleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.choosedTitleLabel.textColor = [UIColor lightGrayColor];
        self.choosedTitleLabel.text = @"已经选择的";
        [self.contentView addSubview:self.choosedTitleLabel];
    }
}

- (CGFloat)chooseItemCellHeight {
    
    return Margin + 2.5f * Margin + Margin * 0.7f + [STChooseItemView chooseItemViewHeight:self.choosedArray] + Margin + 2.5f * Margin +  Margin * 0.7f + [STChooseItemView chooseItemViewHeight:self.willChooseArray] + Margin;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.choosedTitleLabel.frame = CGRectMake(Margin * 1.5f, Margin, 100, 2.5f * Margin);
    self.itemView.frame = CGRectMake(0, CGRectGetMaxY(self.choosedTitleLabel.frame) + 0.7f * Margin, self.width, [STChooseItemView chooseItemViewHeight:self.choosedArray]);
    
    self.willChooseTitleLabel.frame = CGRectMake(Margin * 1.5f, CGRectGetMaxY(self.itemView.frame) + Margin, 100, 2.5f * Margin);
    self.willChooseItemView.frame = CGRectMake(0, CGRectGetMaxY(self.willChooseTitleLabel.frame) + 0.7f * Margin, self.width, [STChooseItemView chooseItemViewHeight:self.willChooseArray]);
}

#pragma mark --- STChooseItemViewDelegate 
- (void)chooseItemView:(STChooseItemView *)chooseItemView didTapCancelButtonWithIndex:(NSInteger)index {
    
    STChooseItemModel *model = self.choosedArray[index];
    
    //1.开始设置
    model.isChoosed = @0;
    //2.然后存储进入数据库
    [[STChooseItemManager shareManager] setWillChoosedItemWithModel:model];
    
    [self.willChooseArray addObject:model];
    [self.choosedArray removeObject:model];
    
    [self.willChooseItemView reloadDataWith:self.willChooseArray];
    [self.itemView reloadDataWith:self.choosedArray];
    
    if (self.callback) {
        self.callback();
    }
}

- (void)chooseItemView:(STChooseItemView *)chooseItemView didSelectWithIndex:(NSInteger)index {
    
    if (chooseItemView == self.willChooseItemView) {
        
        STChooseItemModel *model = self.willChooseArray[index];
        
        //1.开始设置
        model.isChoosed = @1;
        //2.然后存储进入数据库
        [[STChooseItemManager shareManager] setChoosedItemWithModel:model];
        
        [self.choosedArray addObject:model];
        [self.willChooseArray removeObject:model];
        
        [self.willChooseItemView reloadDataWith:self.willChooseArray];
        [self.itemView reloadDataWith:self.choosedArray];
        
        if (self.callback) {
            self.callback();
        }
    }
}

@end
