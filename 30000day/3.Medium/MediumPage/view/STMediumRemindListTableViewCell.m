//
//  STMediumRemindListTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/10/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumRemindListTableViewCell.h"
#import "STShowTextView.h"
#import "UIImageView+WebCache.h"
#import "DateTools.h"
#import "STMediumModel.h"
#import "STPicturesModel.h"

#define Margin 5
#define MarginBig 15
#define AvatarViewHeight 50
#define ShowImageView  60

@interface STMediumRemindListTableViewCell ()

@property (nonatomic,strong) UIImageView *avatarView;//头像label
@property (nonatomic,strong) UILabel *nameLabel;//名字label
@property (nonatomic,strong) UILabel *timeLabel;//时间label
@property (nonatomic,strong) STShowTextView *textView;//显示时间label
@property (nonatomic,strong) STMediumRemindListModel *listModel;
@property (nonatomic,strong) UIImageView *praiseView;
@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UIImageView *coverImageView_first;

@end

@implementation STMediumRemindListTableViewCell

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
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - MarginBig - 100,MarginBig - 2, 100, 20)];
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
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.borderColor = RGBACOLOR(230, 230, 230, 1).CGColor;
        imageView.layer.borderWidth = 0.7f;
        imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:imageView];
        self.showImageView = imageView;
    }
    
    if (!self.coverImageView_first) {
        self.coverImageView_first = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
        [self.showImageView addSubview:self.coverImageView_first];
    }
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    self.textView.delegate = delegate;
}

- (void)configureWithListModel:(STMediumRemindListModel *)listModel {
    self.listModel = listModel;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:listModel.headImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLabel.text = listModel.nickName;
    self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:[listModel.createTime longLongValue] / 1000] timeAgoSinceNow];
   
    if ([listModel.isClickLike isEqualToString:@"1"]) {
        self.textView.hidden = YES;
        self.praiseView.hidden = NO;
    } else if ([Common isObjectNull:listModel.isClickLike]) {
        self.textView.hidden = NO;
        self.praiseView.hidden = YES;
        [self.textView showContent:[[NSMutableAttributedString alloc] initWithString:self.listModel.remark]];
    }
    //显示图片、视频、文字
    NSMutableArray *pictureArray =  [STMediumModel pictureArrayWith:listModel.mediaJsonStr];
    NSMutableArray *videoArray =  [STMediumModel videoArrayWith:listModel.mediaJsonStr];
    
    if (videoArray.count && pictureArray.count) {//视频和图片
        self.showImageView.hidden = NO;
        self.coverImageView_first.hidden = NO;
        
        STPicturesModel *model = videoArray[0];
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)]];
        
    } else if (videoArray.count == 0 && pictureArray.count == 0) {//单纯的文字
        self.showImageView.hidden = YES;
        self.coverImageView_first.hidden = YES;
    } else if (videoArray.count == 0 && pictureArray.count != 0) {//图片
        self.showImageView.hidden = NO;
        self.coverImageView_first.hidden = YES;
        
        STPicturesModel *model = pictureArray[0];
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)]];
        
    } else if (videoArray.count != 0 && pictureArray.count == 0) {//视频
        self.showImageView.hidden = NO;
        self.coverImageView_first.hidden = YES;
        
        STPicturesModel *model = videoArray[0];
        [self.showImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbnailCoverPhotoURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)]];
    }
    [self setNeedsLayout];
}

+ (CGFloat)heightWithWithListModel:(STMediumRemindListModel *)listModel {
    
    NSMutableArray *pictureArray =  [STMediumModel pictureArrayWith:listModel.mediaJsonStr];
    NSMutableArray *videoArray =  [STMediumModel videoArrayWith:listModel.mediaJsonStr];
    
    if (videoArray.count == 0 && pictureArray.count == 0) {
        
        CGFloat heigth_1 = [STShowTextView heightContentViewWith:[[NSMutableAttributedString alloc] initWithString:listModel.remark] contenteViewWidth:SCREEN_WIDTH - 62 - 100] + Margin + 20;//文字高度加上margin和名字label的高度
        CGFloat height_2 = AvatarViewHeight;//头像图片的高度
        
        if (heigth_1 > height_2) {
            return heigth_1 + MarginBig - 2 + MarginBig;
        } else {
            return height_2 + MarginBig + MarginBig;
        }
        
    } else {
        
        CGFloat heigth_1 = [STShowTextView heightContentViewWith:[[NSMutableAttributedString alloc] initWithString:listModel.remark] contenteViewWidth:SCREEN_WIDTH - 62 - 100] + Margin + 20;//文字高度加上margin和名字label的高度
        CGFloat height_2 = ShowImageView;//显示多媒体的图片高度
        
        if (heigth_1 > height_2) {
            return heigth_1 + MarginBig - 2 + MarginBig;
        } else {
            return height_2 + MarginBig + MarginBig - 2 + 20 + Margin;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + Margin, SCREEN_WIDTH - 62 - 100, [STShowTextView heightContentViewWith:[[NSMutableAttributedString alloc] initWithString:self.listModel.remark] contenteViewWidth:SCREEN_WIDTH - 62 - 100]);//100是右边留出的宽度，62是到左边的距离
    
    self.showImageView.frame = CGRectMake(SCREEN_WIDTH - ShowImageView - MarginBig , CGRectGetMaxY(self.timeLabel.frame) + Margin, ShowImageView, ShowImageView);
}


@end
