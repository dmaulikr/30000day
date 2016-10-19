//
//  STChooseItemSettingCell.m
//  30000day
//
//  Created by GuoJia on 16/8/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STChooseItemSettingCell.h"
#import "STChooseItemManager.h"
#import "STChooseItemView.h"

#define Margin  10

@interface STChooseItemSettingCell () <STChooseItemViewDelegate>

@property (nonatomic,strong) STChooseItemView *itemView;
@property (nonatomic,strong) NSNumber *visibleType;//0自己，1好友 2公开
@property (nonatomic,strong) NSMutableArray *choosedArray;

@end

@implementation STChooseItemSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier visibleType:(NSNumber *)visibleType {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUIWithVisibleType:visibleType];
    }
    return self;
}

- (void)configUIWithVisibleType:(NSNumber *)visibleType {
    
    self.visibleType = visibleType;
    self.choosedArray = [STChooseItemManager choosedItemArrayWithUserId:STUserAccountHandler.userProfile.userId visibleType:visibleType];
    
    if (!self.itemView) {
        self.itemView = [[STChooseItemView alloc] initWithFrame:CGRectZero itemModelArray:self.choosedArray];
        self.itemView.delegate = self;
        [self.contentView addSubview:self.itemView];
    }
}

- (CGFloat)chooseItemCellHeight {
    
    if ([STChooseItemView chooseItemViewHeight:self.choosedArray] == 0) {
        return 40.0f + 1.5f * Margin;
    } else {
        return Margin * 0.7f + [STChooseItemView chooseItemViewHeight:self.choosedArray] + Margin * 0.7f;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.itemView.frame = CGRectMake(0,0.7f * Margin, self.width - 30, [STChooseItemView chooseItemViewHeight:self.choosedArray]);
}

- (void)reloadData {
    self.choosedArray = [STChooseItemManager choosedItemArrayWithUserId:STUserAccountHandler.userProfile.userId visibleType:self.visibleType];
    [self.itemView reloadDataWith:self.choosedArray];
}

#pragma mark --- STChooseItemViewDelegate
- (void)chooseItemView:(STChooseItemView *)chooseItemView didTapCancelButtonWithIndex:(NSInteger)index {
    
    STChooseItemModel *model = self.choosedArray[index];
    
    //1.开始设置
    model.isChoosed = @0;
    //2.然后存储进入数据库
    [[STChooseItemManager shareManager] setWillChoosedItemWithModel:model];
    
    [self.choosedArray removeObject:model];
    
    [self.itemView reloadDataWith:self.choosedArray];
    
    if (self.callback) {
        self.callback();
    }
}

- (void)chooseItemView:(STChooseItemView *)chooseItemView didSelectWithIndex:(NSInteger)index {
    
//    if (chooseItemView == self.willChooseItemView) {
//        
//        STChooseItemModel *model = self.willChooseArray[index];
//        
//        //1.开始设置
//        model.isChoosed = @1;
//        //2.然后存储进入数据库
//        [[STChooseItemManager shareManager] setChoosedItemWithModel:model];
//        
//        [self.choosedArray addObject:model];
//        [self.willChooseArray removeObject:model];
//        
//        [self.willChooseItemView reloadDataWith:self.willChooseArray];
//        [self.itemView reloadDataWith:self.choosedArray];
//        
//        if (self.callback) {
//            self.callback();
//        }
//    }
}

@end
