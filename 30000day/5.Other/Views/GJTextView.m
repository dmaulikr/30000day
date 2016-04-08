//
//  GJTextView.m
//  郭佳微博
//
//  Created by admian on 15/4/17.
//  Copyright (c) 2015年 guojia. All rights reserved.
//

#import "GJTextView.h"

@interface GJTextView ()


@end

@implementation GJTextView


- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}


#pragma mark -系统方法
//或者弄个label在里面,然后一点输入东西不显示label
- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        //不要设置代理为自己,在我们这个类里面,外面只是传字符串过来的,不监听文字的文字的改变，要我们自己监听的，设置代理或者block都不合理【最好是别人】,最好用通知
        //通知
        //监听文字改变,当UITextView的文字发生改变的时,UITextView自己会发出一个,如果填self,只是当前的对象监听，如果nil是任何对象都能监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}
/** 这句代码的含义是当系统ARC释放该方法释放对象的时候[调用dealloc释放的],我们的的加进去的观察者self也要被移除,体现思维的缜密性 */
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -我们自己重写setter的方法
/** 监听文字的改变 */
- (void)TextChange
{
    //重新描绘
    [self setNeedsDisplay];
}

/** 吧控件描绘在view上面,每次调用都会吧上次擦掉 */
- (void)drawRect:(CGRect)rect {
    if (self.hasText){
        
        return;
    }
    //文字改变
    NSMutableDictionary *attri = [NSMutableDictionary dictionary];
    attri[NSFontAttributeName] = self.font;
#pragma mark --解决了设置self.placeholderColor还是显示黑色问题了,是因为调用的GJ(0.6,0.6,0.6)方法本来里面就带分母,如果0.6改成160就可以了
    attri[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor:RGBACOLOR(160, 160, 160, 1);
    //画文字
    //[self.placeholder drawAtPoint:CGPointMake(5, 8) withAttributes:attri];
    CGFloat x = 5;
    CGFloat y = 8;
    CGFloat w = rect.size.width - 2*x;
    CGFloat h = rect.size.height - 2*y;//这样就能让那个占位的多行显示了
    CGRect placeholderRect = CGRectMake(x, 8,w , h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attri];
}

/** 重写setter保证外面随时改变文字里面都能实时改变 */
- (void)setPlaceholder:(NSString *)placeholder {
    
    _placeholder = [placeholder copy];
    
    //改了文字重新画下
    [self setNeedsDisplay];
    
}

/** 重写setter保证外面随时改变文字颜色里面都能实时改变 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

/** 为了防止外面用户用系统的方法来改变文字,而我们里面却监视不到的悲剧,重写setter方法也能监视用系统方法了那些活动了 */
- (void)setText:(NSString *)text {
    
    [super setText:text];
    
    [self setNeedsDisplay];//该方法会吧所有需要描绘的东西放在消息队里里面并且会在下个消息循环时候,调用drawRect:而且你如果连续调用5次drawRect:它只会画一次。
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"说明有一层textView蒙在自定义键盘上 = aaa");//说明有一层textView蒙在自定义键盘上
    
}

@end
