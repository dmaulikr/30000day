//
//  STDenounceTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/9/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STDenounceTableViewCell.h"
#import "STChooseView.h"
#import "GJTextView.h"

#define MarginBig 10

@interface STDenounceTableViewCell () <STChooseViewDelegate>

@property (nonatomic,strong) STChooseView *chooseView;
@property (nonatomic,strong) NSMutableArray <STDenounceModel *>*modelArray;
@property (nonatomic,strong) NSMutableArray <STChooseItemModel *>*itemModelArray;

@end

@implementation STDenounceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    if (!self.chooseView) {
        STChooseView *view = [[STChooseView alloc] initWithFrame:CGRectZero itemModelArray:nil];
        view.delegate = self;
        view.isChooseMore = NO;
        [self.contentView addSubview:view];
        self.chooseView = view;
    }
    
    if (!self.titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = RGBACOLOR(230, 230, 230, 1);
        [self.contentView addSubview:label];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        self.titleLabel = label;
    }
    
    if (!self.textView) {
        GJTextView *textView = [[GJTextView alloc] init];
        textView.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:textView];
        self.textView = textView;
        textView.placeholder = @"请输入举报理由";
        textView.placeholderColor = [UIColor lightGrayColor];
        //UI
        textView.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
        textView.layer.borderWidth = 0.7f;
        textView.layer.masksToBounds = YES;
        textView.layer.cornerRadius = 3.0f;
    }
}

- (void)configCellWith:(NSMutableArray <STDenounceModel *>*)modelArray {
    self.modelArray = modelArray;
    
    NSMutableArray *itemModelArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < modelArray.count; i++) {
        STDenounceModel *denounceModel = modelArray[i];
        
        STChooseItemModel *model = [[STChooseItemModel alloc] init];
        model.title = denounceModel.title;
        model.isChoosed = @0;//一开始是没选中的
        model.itemTag = denounceModel.denounceType;
        [itemModelArray addObject:model];
    }
    self.itemModelArray = itemModelArray;
    [self.chooseView reloadDataWith:itemModelArray];
    [self setNeedsLayout];
}

+ (CGFloat)cellHeightWithDataArray:(NSMutableArray *)dataArray {
    return MarginBig + 30 + MarginBig + 35 + MarginBig + [STChooseView chooseViewHeight:dataArray];
}

//获取所有选中的itemArray
- (NSMutableArray <STChooseItemModel *>*)getSelectedChooseItemArray {
    return [self.chooseView getSelectedChooseItemArray];
}

#pragma --
#pragma mark --- STChooseViewDelegate

//index:对应的是创建的时候模型数组坐标 NO就是没选中，YES就是选中了
- (void)chooseView:(STChooseView *)chooseItemView didSelectWithIndex:(NSInteger)index {
    
    if (self.selectedBlock) {
        self.selectedBlock();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //开始设置坐标
    self.titleLabel.frame = CGRectMake(MarginBig, MarginBig, SCREEN_WIDTH - 2 * MarginBig, 30);
    self.textView.frame = CGRectMake(MarginBig, CGRectGetMaxY(self.titleLabel.frame) + MarginBig, self.width - 2 * MarginBig, 35.f);
    self.chooseView.frame = CGRectMake(0, CGRectGetMaxY(self.textView.frame) + MarginBig, self.width, [STChooseView chooseViewHeight:self.itemModelArray]);
}

@end
