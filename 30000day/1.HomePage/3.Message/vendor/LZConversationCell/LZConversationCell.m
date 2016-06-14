//
//  LeanChatConversationTableViewCell.m
//  MessageDisplayKitLeanchatExample
//
//  Created by lzw on 15/4/17.
//  Copyright (c) 2015年 lzwjava QQ: 651142978
//

#import "LZConversationCell.h"

static CGFloat kLZImageSize = 53;
static CGFloat kLZVerticalSpacing = 10;
static CGFloat kLZHorizontalSpacing = 10;
static CGFloat kLZTimestampeLabelWidth = 100;

static CGFloat kLZNameLabelHeightProportion = 3.0 / 5;
static CGFloat kLZNameLabelHeight;
static CGFloat kLZMessageLabelHeight;
static CGFloat kLZLittleBadgeSize = 10;


@interface LZConversationCell ()

@end

@implementation LZConversationCell

+ (LZConversationCell *)dequeueOrCreateCellByTableView :(UITableView *)tableView {
    
    LZConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:[LZConversationCell identifier]];
    
    if (cell == nil) {
        
        cell = [[LZConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] identifier]];
        
    }
    
    return cell;
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture {
    
    if (self.longPressBlock) {
        
        self.longPressBlock();
    }
}

+ (void)registerCellToTableView: (UITableView *)tableView {
    
    [tableView registerClass:[LZConversationCell class] forCellReuseIdentifier:[[self class] identifier]];
}

+ (NSString *)identifier {
    
    return NSStringFromClass([LZConversationCell class]);
}

+ (CGFloat)heightOfCell {
    
    return 72.1f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        
        [self addGestureRecognizer:gesture];
    }
    
    return self;
}

- (void)setup {
    
    kLZNameLabelHeight = kLZImageSize * kLZNameLabelHeightProportion;
    
    kLZMessageLabelHeight = kLZImageSize - kLZNameLabelHeight;
    
    [self addSubview:self.avatarImageView];
    [self addSubview:self.timestampLabel];
    [self addSubview:self.litteBadgeView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.messageTextLabel];
}

- (UIImageView *)avatarImageView {
    
    if (_avatarImageView == nil) {
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLZHorizontalSpacing, kLZVerticalSpacing, kLZImageSize, kLZImageSize)];
        
        _avatarImageView.layer.cornerRadius = 3;
        
        _avatarImageView.layer.masksToBounds = YES;
        
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _avatarImageView.backgroundColor = [UIColor blackColor];
    }
    
    return _avatarImageView;
}

- (UIView *)litteBadgeView {
    
    if (_litteBadgeView == nil) {
        
        _litteBadgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLZLittleBadgeSize, kLZLittleBadgeSize)];
        
        _litteBadgeView.backgroundColor = [UIColor redColor];
        
        _litteBadgeView.layer.masksToBounds = YES;
        
        _litteBadgeView.layer.cornerRadius = kLZLittleBadgeSize / 2;
        
        _litteBadgeView.center = CGPointMake(CGRectGetMaxX(_avatarImageView.frame), CGRectGetMinY(_avatarImageView.frame));
        
        _litteBadgeView.hidden = YES;
    }
    
    return _litteBadgeView;
}

- (UILabel *)timestampLabel {
    
    if (_timestampLabel == nil) {
        
        _timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - kLZHorizontalSpacing - kLZTimestampeLabelWidth, CGRectGetMinY(_avatarImageView.frame), kLZTimestampeLabelWidth, kLZNameLabelHeight)];
        
        _timestampLabel.font = [UIFont systemFontOfSize:13];
        
        _timestampLabel.textAlignment = NSTextAlignmentRight;
        
        _timestampLabel.textColor = [UIColor grayColor];
    }
    
    return _timestampLabel;
}

- (UILabel *)nameLabel {
    
    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_avatarImageView.frame) + kLZHorizontalSpacing, CGRectGetMinY(_avatarImageView.frame), CGRectGetMinX(_timestampLabel.frame) - kLZHorizontalSpacing * 3 - kLZImageSize, kLZNameLabelHeight)];
        
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}

- (UILabel *)messageTextLabel {
    if (_messageTextLabel == nil) {
        _messageTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) - 2, CGRectGetWidth([UIScreen mainScreen].bounds)- 3 * kLZHorizontalSpacing - kLZImageSize, kLZMessageLabelHeight)];
        _messageTextLabel.backgroundColor = [UIColor clearColor];
    }
    return _messageTextLabel;
}

- (JSBadgeView *)badgeView {
    
    if (_badgeView == nil) {
        
        _badgeView = [[JSBadgeView alloc] initWithParentView:self.nameLabel alignment:JSBadgeViewAlignmentTopLeft];

    }
    return _badgeView;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.badgeView.badgeText = nil;
    self.litteBadgeView.hidden = YES;
    self.messageTextLabel.text = nil;
    self.timestampLabel.text = nil;
    self.nameLabel.text = nil;
}

@end
