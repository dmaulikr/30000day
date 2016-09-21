//
//  STContentView.m
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STContentView.h"
#define SingleContentHeight    17.9003906f	    //字体大小等于15的一行高度
#define SingleContentNum        6
#import "STMediumWebViewController.h"
#import <CoreText/CoreText.h>
#import "SETextView.h"
#import <UIKit/UIKit.h>

@class PPLabel;

/// The delegate of a PPLabel object
@protocol PPLabelDelegate <NSObject>

/**
 Tells the delegate that the label was touched and returns which character was touched.
 
 @param label The instance of PPLabel that called this method.
 @param touch The touch that triggered this event.
 @param cIndex of a character at given point or NSNotFound.
 
 @return Return YES if the delegate handled this touch and should not be propagated any further.
 */
- (BOOL)label:(PPLabel*)label didBeginTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;

/**
 Tells the delegate that the touch was moved.
 
 @param label The instance of PPLabel that called this method.
 @param touch The touch that triggered this event.
 @param cIndex of a character at given point or NSNotFound.
 
 @return Return YES if the delegate handled this touch and should not be propagated any further.
 */
- (BOOL)label:(PPLabel*)label didMoveTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;

/**
 Tells the delegate that the label that it's not being touched anymore.
 
 @param label The instance of PPLabel that called this method.
 @param touch The touch that triggered this event.
 @param cIndex of a character at given point or NSNotFound.
 
 @return Return YES if the delegate handled this touch and should not be propagated any further.
 */
- (BOOL)label:(PPLabel*)label didEndTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;

/**
 Tells the delegate that the label that it's not being touched anymore.
 
 @param label The instance of PPLabel that called this method.
 @param touch The touch that triggered this event.
 
 @return Return YES if the delegate handled this touch and should not be propagated any further.
 */
- (BOOL)label:(PPLabel*)label didCancelTouch:(UITouch*)touch;

@end


/// Subclass of PPLabel which can detect touches and report which character was touched.
@interface PPLabel : UILabel

/**
 The object that acts as the delegate of the receiving label.
 
 @see PPLabelDelegate
 */
@property(nonatomic, weak) id <PPLabelDelegate> delegate;

/**
 Cancels current touch and calls didCancelTouch: on the delegate.
 
 This method does nothing if there is no touch session.
 */
- (void)cancelCurrentTouch;

/**
 Returns the index of character at provided point or NSNotFound.
 
 @param point The point indicating where to look for.
 
 @return Index of a character at given point or NSNotFound.
 */
- (CFIndex)characterIndexAtPoint:(CGPoint)point;

@end

@interface PPLabel ()
@property(nonatomic, strong) NSSet* lastTouches;
@end

@implementation PPLabel

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (CFIndex)characterIndexAtPoint:(CGPoint)point {
    
    ////////
    
    NSMutableAttributedString* optimizedAttributedText = [self.attributedText mutableCopy];
    
    // use label's font and lineBreakMode properties in case the attributedText does not contain such attributes
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, [self.attributedText length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        if (!attrs[(NSString*)kCTFontAttributeName]) {
            
            [optimizedAttributedText addAttribute:(NSString*)kCTFontAttributeName value:self.font range:NSMakeRange(0, [self.attributedText length])];
        }
        
        if (!attrs[(NSString*)kCTParagraphStyleAttributeName]) {
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:self.lineBreakMode];
            
            [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        }
    }];
    
    // modify kCTLineBreakByTruncatingTail lineBreakMode to kCTLineBreakByWordWrapping
    [optimizedAttributedText enumerateAttribute:(NSString*)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, [optimizedAttributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        
        NSMutableParagraphStyle* paragraphStyle = [value mutableCopy];
        
        if ([paragraphStyle lineBreakMode] == kCTLineBreakByTruncatingTail) {
            [paragraphStyle setLineBreakMode:kCTLineBreakByWordWrapping];
        }
        
        [optimizedAttributedText removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range];
        [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
    }];
    
    ////////
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }
    
    CGRect textRect = [self textRect];
    
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    //////
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedText length]), path, NULL);
    
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    
    //NSLog(@"num lines: %d", numberOfLines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}

#pragma mark --

- (CGRect)textRect {
    
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.origin.y = (self.bounds.size.height - textRect.size.height)/2;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        textRect.origin.x = (self.bounds.size.width - textRect.size.width)/2;
    }
    if (self.textAlignment == NSTextAlignmentRight) {
        textRect.origin.x = self.bounds.size.width - textRect.size.width;
    }
    
    return textRect;
}


#pragma mark --

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.lastTouches = touches;
    
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    
    if (![self.delegate label:self didBeginTouch:touch onCharacterAtIndex:index]) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.lastTouches = touches;
    
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    
    if (![self.delegate label:self didMoveTouch:touch onCharacterAtIndex:index]) {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!self.lastTouches) {
        return;
    }
    
    self.lastTouches = nil;
    
    UITouch *touch = [touches anyObject];
    CFIndex index = [self characterIndexAtPoint:[touch locationInView:self]];
    
    if (![self.delegate label:self didEndTouch:touch onCharacterAtIndex:index]) {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!self.lastTouches) {
        return;
    }
    
    self.lastTouches = nil;
    
    UITouch *touch = [touches anyObject];
    
    if (![self.delegate label:self didCancelTouch:touch]) {
        [super touchesCancelled:touches withEvent:event];
    }
}

- (void)cancelCurrentTouch {
    
    if (self.lastTouches) {
        [self.delegate label:self didCancelTouch:[self.lastTouches anyObject]];
        self.lastTouches = nil;
    }
}

@end

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
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor = [UIColor darkGrayColor];
        label.numberOfLines = 0;
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
    
    if ([Common heightWithText:mediaContent.string width:width fontSize:15.0f] > SingleContentNum * SingleContentHeight) {
        return SingleContentNum * SingleContentHeight;
    } else {
        return [Common heightWithText:mediaContent.string width:width fontSize:15.0f];
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
