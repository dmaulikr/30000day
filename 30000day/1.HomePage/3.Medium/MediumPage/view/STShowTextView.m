//
//  STShowTextView.m
//  30000day
//
//  Created by GuoJia on 16/9/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STShowTextView.h"
#import "SETextView.h"
#import "STMediumWebViewController.h"

#define SingleContentHeight    17.9003906f	    //字体大小等于15的一行高度
#define SingleContentNum        6

@interface STShowTextView () <SETextViewDelegate>

@property (nonatomic,copy)   NSAttributedString *mediaContent;
@property (nonatomic,strong) SETextView *displayTextView;
@property (nonatomic,strong) NSArray *matches;

@end

@implementation STShowTextView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    SETextView *displayTextView = [[SETextView alloc] initWithFrame:CGRectZero];
    displayTextView.backgroundColor = [UIColor clearColor];
    displayTextView.selectable = NO;
    displayTextView.lineSpacing = 4;
    displayTextView.font = [UIFont systemFontOfSize:15.0f];
    displayTextView.showsEditingMenuAutomatically = NO;
    displayTextView.highlighted = NO;
    [self addSubview:displayTextView];
    _displayTextView = displayTextView;
}

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range {
    return index > range.location && index < range.location+range.length;
}

- (BOOL)textView:(SETextView *)textView clickedOnLink:(SELinkText *)link atIndex:(NSUInteger)charIndex
{
    NSString *text = link.object;
    if ([text hasPrefix:@"http"]) {
        
    } else if ([text hasPrefix:@"@"]) {
        
    } else if ([text hasPrefix:@"#"]) {

    }
    
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
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定拨打 %@ ?",[self.displayTextView.attributedText.string substringWithRange:matchRange]] message:@"请您提高警惕，谨防诈骗" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[self.displayTextView.attributedText.string substringWithRange:matchRange]]]];
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

- (BOOL)textView:(SETextView *)aTextView longPressedOnLink:(SELinkText *)link atIndex:(NSUInteger)charIndex {
    return YES;
}

//开始展示内容
- (void)showContent:(NSAttributedString *)mediaContentAttributedString {
    self.mediaContent = mediaContentAttributedString;
    self.displayTextView.attributedText = mediaContentAttributedString;
    
    NSError *error = NULL;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber | NSTextCheckingTypeDate error:&error];
    self.matches = [detector matchesInString:mediaContentAttributedString.string options:0 range:NSMakeRange(0, mediaContentAttributedString.string.length)];
    [self setNeedsLayout];
}

+ (CGFloat)heightContentViewWith:(NSAttributedString *)mediaContent contenteViewWidth:(CGFloat)width {
    
    
    CGRect frameRect = [SETextView frameRectWithAttributtedString:mediaContent
                                                   constraintSize:CGSizeMake(width, CGFLOAT_MAX)
                                                      lineSpacing:4
                                                             font:[UIFont systemFontOfSize:5.0f]];
    return frameRect.size.height;
//    if ([Common heightWithText:mediaContent.string width:width fontSize:15.0f] > SingleContentNum * SingleContentHeight) {
//        return SingleContentNum * SingleContentHeight;
//    } else {
//        return [Common heightWithText:mediaContent.string width:width fontSize:15.0f];
//    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.displayTextView.frame = CGRectMake(0, 0, self.width, self.height);
}

@end
