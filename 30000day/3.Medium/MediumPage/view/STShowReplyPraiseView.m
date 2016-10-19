//
//  STShowReplyPraiseView.m
//  30000day
//
//  Created by GuoJia on 16/9/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STShowReplyPraiseView.h"
#import "UIImageView+WebCache.h"

@interface STShowReplyPraiseView ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView_fist;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_fist;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_first;

@property (weak, nonatomic) IBOutlet UIView *backgroundView_second;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_second;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_second;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgoundView_first_topConstraint;

@property (nonatomic,strong) NSMutableArray *array_first;
@property (nonatomic,strong) NSMutableArray *array_second;

@end

@implementation STShowReplyPraiseView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userInteractionEnabled = YES;
    self.backgroundView_fist.userInteractionEnabled = YES;
    self.imageView_fist.userInteractionEnabled = YES;
    self.titleLabel_first.userInteractionEnabled = YES;
    self.backgroundView_second.userInteractionEnabled = YES;
    self.imageView_second.userInteractionEnabled = YES;
    self.titleLabel_second.userInteractionEnabled = YES;
    //第1
    UITapGestureRecognizer *tap_first = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionFirst)];
    [self.backgroundView_fist addGestureRecognizer:tap_first];
    [self.imageView_fist addGestureRecognizer:tap_first];
    [self.titleLabel_first addGestureRecognizer:tap_first];
    //第2
    UITapGestureRecognizer *tap_second = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionSecond)];
    [self.backgroundView_second addGestureRecognizer:tap_second];
    [self.imageView_second addGestureRecognizer:tap_second];
    [self.titleLabel_second addGestureRecognizer:tap_second];
}

+ (STShowReplyPraiseView *)showReplyPraiseView {
    return [[[NSBundle mainBundle] loadNibNamed:@"STShowReplyPraiseView" owner:nil options:nil] lastObject];
}

- (void)tapActionFirst {
    if (self.replyBlock) {
        self.replyBlock(self.array_first);
    }
}

- (void)tapActionSecond {
    if (self.praiseBlock) {
        self.praiseBlock(self.array_second);
    }
}

- (void)configureViewWithReplyArray:(NSArray <AVIMReplyMessage *>*)replyArray praiseArray:(NSArray <AVIMPraiseMessage *>*)praiseArray {
    self.array_first = [NSMutableArray arrayWithArray:replyArray];
    self.array_second = [NSMutableArray arrayWithArray:praiseArray];
    
    if (replyArray.count) {
        self.backgroundView_fist.hidden = NO;
        self.imageView_fist.hidden = NO;
        self.titleLabel_first.hidden = NO;
//        self.titleLabel_first.text = [NSString stringWithFormat:@"%lu条回复",(unsigned long)replyArray.count];
        self.titleLabel_first.text = @"回复了你";
        AVIMReplyMessage *lastMessage = [replyArray lastObject];
        [self.imageView_fist sd_setImageWithURL:[NSURL URLWithString:[lastMessage.attributes objectForKey:ORIGINAL_IMG_URL]] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    } else {
        self.backgroundView_fist.hidden = YES;
        self.imageView_fist.hidden = YES;
        self.titleLabel_first.hidden = YES;
        self.backgoundView_first_topConstraint.constant = -35.0f;
        [self setNeedsLayout];
    }
    
    if (praiseArray.count) {
        self.backgroundView_second.hidden = NO;
        self.imageView_second.hidden = NO;
        self.titleLabel_second.hidden = NO;
//        self.titleLabel_second.text = [NSString stringWithFormat:@"%lu条点赞",(unsigned long)praiseArray.count];
        self.titleLabel_second.text = @"点赞了你";
        AVIMPraiseMessage *lastMessage = [praiseArray lastObject];
        NSString *imageURLString = [lastMessage.attributes objectForKey:ORIGINAL_IMG_URL];
        if ([imageURLString isKindOfClass:[NSString class]]) {
            [self.imageView_second sd_setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 1)] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            }];
        }
    } else {
        self.backgroundView_second.hidden = YES;
        self.imageView_second.hidden = YES;
        self.titleLabel_second.hidden = YES;
    }
}

+ (CGFloat)heightReplyPraiseViewWithReplyArray:(NSArray <AVIMReplyMessage *>*)replyArray praiseArray:(NSArray <AVIMPraiseMessage *>*)praiseArray {
    
    if (replyArray.count && praiseArray.count) {
        return 105.0f;
    } else if (!replyArray.count && !praiseArray.count) {
        return 0.01f;
    } else {
        return 60.0f;
    }
}

@end
