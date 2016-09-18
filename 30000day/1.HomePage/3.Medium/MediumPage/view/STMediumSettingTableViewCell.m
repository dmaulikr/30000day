//
//  STMediumSettingTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/8/4.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumSettingTableViewCell.h"
#import "STSettingView.h"


@interface STMediumSettingTableViewCell ()

@property (nonatomic,strong) STSettingView *settingView;

@end

@implementation STMediumSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    if (!self.settingView) {
        STSettingView *settingView = [[STSettingView alloc] init];
        [self.contentView addSubview:settingView];
        self.settingView = settingView;
    }
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    self.settingView.delegate = delegate;
}

+ (CGFloat)heightMediumCellWith:(STMediumModel *)mixedMediumModel {//高度
    return [STSettingView heightView:mixedMediumModel];
}
//配置
- (void)cofigCellWithModel:(STMediumModel *)mixedMediumModel {
    [self.settingView configureViewWithModel:mixedMediumModel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.settingView.frame = CGRectMake(0, 0, self.width, self.height);
}

@end
