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
#define Max_height  159 //	@"【快播案一审宣判　王欣被判有期徒刑３年６个月】１３日，快播公司及王欣等人涉嫌非法传播淫秽物品罪一案在北京市海淀区人民法院一审宣判。法院最终判决快播公司及王欣等四名被告涉嫌传播淫秽物品牟利罪成立，王欣等四人分别被判处３年６个月至３年有期徒刑，并处罚金。"

@interface STShowTextView () <SETextViewDelegate>

@property (nonatomic,copy)   NSAttributedString *mediaContent;
@property (nonatomic,strong) SETextView *displayTextView;
@property (nonatomic,strong) NSArray *matches;
@property (nonatomic,strong) UILabel *allLabel;

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
    if (!self.displayTextView) {
        SETextView *displayTextView = [[SETextView alloc] initWithFrame:CGRectZero];
        displayTextView.backgroundColor = [UIColor clearColor];
        displayTextView.selectable = NO;
        displayTextView.lineSpacing = 2;
        displayTextView.font = [UIFont systemFontOfSize:15.0f];
        displayTextView.showsEditingMenuAutomatically = YES;
        displayTextView.highlighted = NO;
        displayTextView.delegate = self;
        [self addSubview:displayTextView];
        _displayTextView = displayTextView;
    }
    
    if (!self.allLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"全文";
        label.textColor = LOWBLUECOLOR;
        label.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:label];
        self.allLabel = label;
    }
}

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range {
    return index > range.location && index < range.location+range.length;
}

#pragma mark --- SETextViewDelegate
- (BOOL)textView:(SETextView *)textView clickedOnLink:(SELinkText *)link atIndex:(NSUInteger)charIndex {
    if ([Common isMobile:link.text]) {//手机号码、电话号码
        
        STBaseViewController *baseController = (STBaseViewController *)self.delegate;
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定拨打 %@ ?",link.text] message:@"请您提高警惕，谨防诈骗" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",link.text]]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:action];
        [controller addAction:cancelAction];
        [baseController presentViewController:controller animated:YES completion:nil];
        
    } else {//网页URL
        STBaseViewController *baseController = (STBaseViewController *)self.delegate;
        STMediumWebViewController *controller = [[STMediumWebViewController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        controller.URL = link.object;
        [baseController.navigationController pushViewController:controller animated:YES];
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
    
    if ([Common isObjectNull:mediaContent.string]) {
        return 0.0f;
    } else {
        CGRect frameRect = [SETextView frameRectWithAttributtedString:mediaContent
                                                       constraintSize:CGSizeMake(width, CGFLOAT_MAX)
                                                          lineSpacing:2
                                                                 font:[UIFont systemFontOfSize:15.0f]];
        return frameRect.size.height > Max_height ? Max_height + SingleContentHeight : frameRect.size.height;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([Common isObjectNull:self.mediaContent.string]) {
        self.displayTextView.hidden = YES;
    } else {
        self.displayTextView.hidden = NO;
    }
    
    if (self.height == Max_height + SingleContentHeight) {//表示文字高度超过Max_height了
        self.allLabel.hidden = NO;
        self.displayTextView.frame = CGRectMake(0, 0, self.width, self.height - SingleContentHeight);
    } else {
        self.allLabel.hidden = YES;
        self.displayTextView.frame = CGRectMake(0, 0, self.width, self.height);
    }
    self.allLabel.frame = CGRectMake(self.width - 30,self.height - SingleContentHeight, 30, SingleContentHeight);
}

@end
