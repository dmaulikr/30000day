
//
//  STConversationCell.m
//  30000day
//
//  Created by GuoJia on 16/5/6.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STConversationCell.h"

static CGFloat kLZImageSize = 45;
static CGFloat kLZHorizontalSpacing = 10;
static CGFloat kLZTimestampeLabelWidth = 100;

static CGFloat kLZNameLabelHeightProportion = 3.0 / 5;
static CGFloat kLZNameLabelHeight;
static CGFloat kLZMessageLabelHeight;

@interface STConversationCell ()

@end

@implementation STConversationCell

+ (STConversationCell *)dequeueOrCreateCellByTableView :(UITableView *)tableView {
    
    STConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:[STConversationCell identifier]];
    
    if (cell == nil) {
        
        cell = [[STConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[self class] identifier]];
    }
    
    return cell;
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture {
    
    if (self.longPressBlock) {
        
        self.longPressBlock();
    }
}

+ (void)registerCellToTableView: (UITableView *)tableView {
    
    [tableView registerClass:[STConversationCell class] forCellReuseIdentifier:[[self class] identifier]];
}

+ (NSString *)identifier {
    
    return NSStringFromClass([STConversationCell class]);
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
    [self addSubview:self.nameLabel];
    [self addSubview:self.messageTextLabel];
    [self addSubview:self.indicatorView];
}

- (UIImageView *)avatarImageView {
    
    if (_avatarImageView == nil) {
        
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_WIDTH)];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImageView.backgroundColor = [UIColor blackColor];
    }
    
    return _avatarImageView;
}

- (UIActivityIndicatorView *)indicatorView {
    
    if (_indicatorView == nil) {
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = self.avatarImageView.center;
        _indicatorView.hidesWhenStopped = YES;
    }
    
    return _indicatorView;
}

- (UILabel *)timestampLabel {
    
    if (_timestampLabel == nil) {
        
        _timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kLZTimestampeLabelWidth - 15, SCREEN_WIDTH + 15, kLZTimestampeLabelWidth, 18.0f)];
        _timestampLabel.font = [UIFont systemFontOfSize:13];
        _timestampLabel.textAlignment = NSTextAlignmentRight;
        _timestampLabel.textColor = [UIColor grayColor];
    }
    
    return _timestampLabel;
}

- (UILabel *)nameLabel {
    
    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, SCREEN_WIDTH + 12, CGRectGetMinX(_timestampLabel.frame) - kLZHorizontalSpacing * 3 - kLZImageSize, kLZNameLabelHeight)];
        
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _nameLabel;
}

- (UILabel *)messageTextLabel {
    
    if (_messageTextLabel == nil) {
        
        _messageTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) + 5, CGRectGetWidth([UIScreen mainScreen].bounds)- 3 * kLZHorizontalSpacing - kLZImageSize, kLZMessageLabelHeight)];
        
        _messageTextLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _messageTextLabel;
}

- (JSBadgeView *)badgeView {
    
    if (_badgeView == nil) {
        
        _badgeView = [[JSBadgeView alloc] initWithParentView:self.nameLabel alignment:JSBadgeViewAlignmentTopLeft];
        _badgeView.badgePositionAdjustment = CGPointMake(-2.0f,-2.0f);
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
    self.messageTextLabel.text = nil;
    self.timestampLabel.text = nil;
    self.nameLabel.text = nil;
}

+ (CGFloat)heightOfCell {
    
    return SCREEN_WIDTH + 15.0f + 60.0f;
}

@end
