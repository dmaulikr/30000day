//
//  STMediumCommentTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/10/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumCommentTableViewCell.h"
#import "STShowTextView.h"
#import "UIImageView+WebCache.h"
#import "DateTools.h"

#define Margin 5
#define MarginBig 15
#define AvatarViewHeight 50
#define Margin_right 15  //文字控件到右边的距离

@interface STMediumCommentTableViewCell ()

@property (nonatomic,strong) UIImageView *avatarView;//头像label
@property (nonatomic,strong) UILabel *nameLabel;//名字label
@property (nonatomic,strong) UILabel *timeLabel;//时间label
@property (nonatomic,strong) STShowTextView *textView;//显示时间label
@property (nonatomic,strong) STMediumCommentModel *commentModel;
@property (nonatomic,strong) UIImageView *praiseView;
@property (nonatomic,strong) UIImageView *showImageView;

@end

@implementation STMediumCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    if (!self.avatarView) {
        //头像
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(MarginBig, MarginBig, AvatarViewHeight, AvatarViewHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:imageView];
        self.avatarView = imageView;
        //点击手势
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTapAction)];
        //        imageView.userInteractionEnabled = YES;
        //        [imageView addGestureRecognizer:tap];
    }
    
    if (!self.nameLabel) {
        //名字
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 7,MarginBig - 2, 150, 20)];
        nameLabel.textColor = LOWBLUECOLOR;
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
    }
    
    if (!self.timeLabel) {
        //名字
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - Margin - 100,MarginBig - 2, 100, 20)];
        timeLabel.font = [UIFont systemFontOfSize:13.0f];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:timeLabel];
        timeLabel.textColor = LOWBLUECOLOR;
        self.timeLabel = timeLabel;
    }
    
    if (!self.textView) {
        STShowTextView *textView = [[STShowTextView alloc] init];
        [self.contentView addSubview:textView];
        self.textView = textView;
    }
    
    if (!self.praiseView) {//点赞的图标
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame) + 7,39.5, 24.0f, 25.5f)];
        imageView.image = [UIImage imageNamed:@"icon_zan_blue"];
        [self.contentView addSubview:imageView];
        self.praiseView = imageView;
    }
    
    if (!self.showImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        self.showImageView = imageView;
    }
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    self.textView.delegate = delegate;
}

- (void)configureWithCommentModel:(STMediumCommentModel *)commentModel {
    self.commentModel = commentModel;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[commentModel getDisplayHeadImg]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLabel.attributedText = [commentModel getAttributeName];
    self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:[[commentModel getDisplayTime] longLongValue] / 1000] timeAgoSinceNow];
    
    if ([commentModel.isClickLike isEqualToString:@"1"]) {
        self.textView.hidden = YES;
        self.praiseView.hidden = NO;
    } else if ([Common isObjectNull:commentModel.isClickLike]) {
        self.textView.hidden = NO;
        self.praiseView.hidden = YES;
        [self.textView showContent:[commentModel getDisplayContent]];
    }
    //显示图片、视频、文字
//    if ([Common isObjectNull:listModel.mediaImage]) {
//        
//    } else {
//        
//    }
    
    [self setNeedsLayout];
}

+ (CGFloat)heightWithWithCommentModel:(STMediumCommentModel *)commentModel {
    CGFloat heigth_1 = [STShowTextView heightContentViewWith:[commentModel getDisplayContent] contenteViewWidth:SCREEN_WIDTH - 62 - Margin_right] + Margin + 20;//文字高度加上margin和名字label的高度
    CGFloat height_2 = AvatarViewHeight;//名称的高度
    
    if (heigth_1 > height_2) {
        return heigth_1 + MarginBig - 2 + MarginBig;
    } else {
        return height_2 + MarginBig + MarginBig;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + Margin, SCREEN_WIDTH - 62 - Margin_right, [STShowTextView heightContentViewWith:[self.commentModel getDisplayContent] contenteViewWidth:SCREEN_WIDTH - 62 - Margin_right]);//62是到左边的距离
}


@end
