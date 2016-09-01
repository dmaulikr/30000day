//
//  STContentView.m
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STContentView.h"
#define SingleContentHeight    16.7070313f	    //一行高度
#import "PPLabel.h"
#import "STMediumWebViewController.h"

@interface STContentView () <PPLabelDelegate>

@property (nonatomic,strong) PPLabel *contentLabel;//内容label
@property (nonatomic,copy)   NSAttributedString *mediaContent;
@property (nonatomic,strong) NSArray *matches;

@end

@implementation STContentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    if (!self.contentLabel) {
        //内容
        PPLabel *label = [[PPLabel alloc] init];
        label.delegate = self;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor darkGrayColor];
        [self addSubview:label];
        self.contentLabel = label;
    }
}

//开始展示内容
- (void)showContent:(NSAttributedString *)mediaContentAttributedString {
    self.mediaContent = mediaContentAttributedString;
    self.contentLabel.attributedText = mediaContentAttributedString;
    
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber | NSTextCheckingTypeDate error:&error];
    self.matches = [detector matchesInString:mediaContentAttributedString.string options:0 range:NSMakeRange(0, mediaContentAttributedString.string.length)];
    [self setNeedsLayout];
}

+ (CGFloat)heightContentViewWith:(NSAttributedString *)mediaContent contenteViewWidth:(CGFloat)width {
    
    if ([Common heightWithText:mediaContent.string width:width fontSize:14.0f] > 5 * SingleContentHeight) {
        return 5 * SingleContentHeight;
    } else {
        return [Common heightWithText:mediaContent.string width:width fontSize:14.0f];
    }
}

#pragma mark -- PPLabelDelegate

- (BOOL)label:(PPLabel *)label didBeginTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    [self highlightLinksWithIndex:charIndex];
    return YES;
}

- (BOOL)label:(PPLabel *)label didMoveTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    [self highlightLinksWithIndex:charIndex];
    return YES;
}

- (BOOL)label:(PPLabel *)label didEndTouch:(UITouch *)touch onCharacterAtIndex:(CFIndex)charIndex {
    
    [self highlightLinksWithIndex:NSNotFound];
    for (NSTextCheckingResult *match in self.matches) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            
            NSRange matchRange = [match range];
            
            if ([self isIndex:charIndex inRange:matchRange]) {
                STBaseViewController *baseController = (STBaseViewController *)self.delegate;
                STMediumWebViewController *controller = [[STMediumWebViewController alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                controller.URL = match.URL;
                [baseController.navigationController pushViewController:controller animated:YES];
                break;
            }
            
        } else if ([match resultType] == NSTextCheckingTypePhoneNumber) {
            
            NSRange matchRange = [match range];
            if ([self isIndex:charIndex inRange:matchRange]) {
                
                STBaseViewController *baseController = (STBaseViewController *)self.delegate;
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定拨打 %@ ?",[self.contentLabel.attributedText.string substringWithRange:matchRange]] message:@"请您提高警惕，谨防诈骗" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[self.contentLabel.attributedText.string substringWithRange:matchRange]]]];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [controller addAction:action];
                [controller addAction:cancelAction];
                [baseController presentViewController:controller animated:YES completion:nil];
                break;
            }
        }
    }
    return YES;
}

- (BOOL)label:(PPLabel *)label didCancelTouch:(UITouch *)touch {
    [self highlightLinksWithIndex:NSNotFound];
    return YES;
}

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range {
    return index > range.location && index < range.location+range.length;
}

- (void)highlightLinksWithIndex:(CFIndex)index {
    
    NSMutableAttributedString *attributedString = [self.contentLabel.attributedText mutableCopy];
    
    for (NSTextCheckingResult *match in self.matches) {
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            
            NSRange matchRange = [match range];
            
            if ([self isIndex:index inRange:matchRange]) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:matchRange];
            } else {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:matchRange];
            }
            
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:matchRange];
        }
    }
    
    self.contentLabel.attributedText = attributedString;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentLabel.frame = CGRectMake(0, 0, self.width, self.height);
}

@end
