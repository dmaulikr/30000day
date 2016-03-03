//
//  QGMessageCell.m
//  GJChat
//
//  Created by guojia on 15/9/1.
//  Copyright (c) 2015年 guojia. All rights reserved.
//

#import "LOMessageCell.h"
#import "UIImage+WF.h"

@interface LOMessageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bg_imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bg_imageView_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bg_imageView_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bg_imageView_trailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bg_imageView_bottom;
@end


@implementation LOMessageCell {
    
    UILabel *_label;
    UIImageView *_imageView;
}
- (void)awakeFromNib {
    
    self.myHeaderView.layer.cornerRadius = 20;
    self.myHeaderView.layer.masksToBounds = YES;
    self.friendsHeaderView.layer.cornerRadius = 20;
    self.friendsHeaderView.layer.masksToBounds = YES;
    self.myHeaderView.contentMode = UIViewContentModeScaleAspectFill;
    self.friendsHeaderView.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = nil;
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 100;
    label.textAlignment = NSTextAlignmentCenter;
    [self.bg_imageView addSubview:label];
    _label = label;
    
    _imageView = [[UIImageView alloc] init];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.layer.cornerRadius = 8;
    _imageView.layer.masksToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap)];
    [_imageView addGestureRecognizer:tap];
    [self.bg_imageView addSubview:_imageView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setMessageDetailModel:(GJChatViewMessageDetailModel *)messageDetailModel {
    
    _messageDetailModel = messageDetailModel;
    //一、总背景
    if (_messageDetailModel.isSend) {
        
        UIImage *rightImage = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
        
        rightImage = [UIImage imageWithCGImage:rightImage.CGImage scale:2 orientation:UIImageOrientationUpMirrored];
        
        self.bg_imageView.image = [rightImage stretchableImageWithLeftCapWidth:40 topCapHeight:28];//翻转以后进行拉
    } else {
        
        UIImage *rightImage = [UIImage imageNamed:@"SenderTextNodeBkg"];
        
        rightImage = [UIImage imageWithCGImage:rightImage.CGImage scale:2 orientation:UIImageOrientationUpMirrored];
        
        self.bg_imageView.image = [rightImage stretchableImageWithLeftCapWidth:40 topCapHeight:28];//翻转以后进行拉伸
    }
    //二、开始设置
    if ([_messageDetailModel.symbolStr isEqualToString:MESSAGE_STRING]) {//文字
        
        _label.text = _messageDetailModel.willShowMessage;
        
        if ( _messageDetailModel.isSend ) {//自己发的消息
            
            self.friendsHeaderView.hidden = YES;
            
            self.myHeaderView.hidden = NO;
            
            
            self.bg_imageView_leading.constant = _messageDetailModel.messageLabelConstrains <= 10 ? 10 : _messageDetailModel.messageLabelConstrains;
            
            NSArray *constrainsX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_label]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)];
            
            NSArray *constrainsY = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-5)-[_label]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)];
            
            [self.bg_imageView addConstraints:constrainsX];
            
            [self.bg_imageView addConstraints:constrainsY];
        
        } else {//对方发送的消息
        
            self.myHeaderView.hidden = YES;
            
            self.friendsHeaderView.hidden = NO;
            
            self.bg_imageView_trailing.constant = _messageDetailModel.messageLabelConstrains <= 10 ?10:_messageDetailModel.messageLabelConstrains;
            
            NSArray *constrainsX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_label]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)];
            
            NSArray *constrainsY = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-5)-[_label]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_label)];
            
            [self.bg_imageView addConstraints:constrainsX];
            
            [self.bg_imageView addConstraints:constrainsY];
        }
        
    } else if ([_messageDetailModel.symbolStr isEqualToString:MESSAGE_IMAGE]) {//图片
        
        _label.hidden = YES;
        
        _imageView.hidden = NO;
        
        if (_messageDetailModel.isSend) {//自己发的
            
            NSArray *imageView_constrainsX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-7-[_imageView]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)];
            
            NSArray *imageView_constrainsY = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_imageView]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)];
            
            [self.bg_imageView addConstraints:imageView_constrainsX];
            
            [self.bg_imageView addConstraints:imageView_constrainsY];
            
            self.friendsHeaderView.hidden = YES;
            
            self.myHeaderView.hidden = NO;
            
            self.bg_imageView_leading.constant = _messageDetailModel.imageViewConstrains;
            
            //显示图片
            [_imageView sd_setImageWithURL:[NSURL URLWithString:_messageDetailModel.willShowImageURL]];
            
        } else {//别人发的
            
            NSArray *imageView_constrainsX = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[_imageView]-7-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)];
            
            NSArray *imageView_constrainsY = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_imageView]-12-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)];
            
            [self.bg_imageView addConstraints:imageView_constrainsX];
            
            [self.bg_imageView addConstraints:imageView_constrainsY];
            
            self.friendsHeaderView.hidden = NO;
            
            self.myHeaderView.hidden = YES;
            
            self.bg_imageView_trailing.constant = _messageDetailModel.imageViewConstrains;
            
            //显示图片
            [_imageView sd_setImageWithURL:[NSURL URLWithString:_messageDetailModel.willShowImageURL]];
        }
    } else if ([_messageDetailModel.symbolStr isEqualToString:MESSAGE_VIDEO]){//视频
        
        
        
    } else if ([_messageDetailModel.symbolStr isEqualToString:MESSAGE_VOICE]){//语音
        
        
        
    }
}

//点击图片
- (void)imageTap {
    if (self.clickBlock) {
        self.clickBlock(_imageView);
    }
}

@end
