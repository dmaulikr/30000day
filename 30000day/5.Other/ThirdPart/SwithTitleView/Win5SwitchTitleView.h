//
//  Win5SwitchTitleView.h
//  切换视图
//
//  Created by win5 on 8/6/15.
//  Copyright (c) 2015 win5. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Win5SwitchTitleViewDelegate;

@interface Win5SwitchTitleView : UIView <UIScrollViewDelegate>

/** 按钮之间的间隔,如果不设置默认是15,若按钮比较少并且不设置间隔的话，会有自动排版的效果，最好别设置 */
@property(nonatomic,assign)NSUInteger titleBtnMargin;

/** 顶部bar的高度,如果不设置默认是30(如果低于30无效)，假设需要更低，自行修改 */
@property(nonatomic,assign)CGFloat titleBarHeight;

/** 顶部bar的颜色,如果不设置模式是[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:0.5f] */
@property(nonatomic,retain)UIColor *titleBarColor;

/** 按钮的字体大小,如果不设置默认是15 */
@property(nonatomic,assign)CGFloat btnTitlefont;

/** 按钮的字体颜色,如果不设置默认是黑色 */
@property(nonatomic,retain)UIColor *btnNormalColor;

/** 按钮选中字体颜色,如果不设置默认是绿色 */
@property(nonatomic,retain)UIColor *btnSelectedColor;

/** 按钮选中背景图片*/
@property(nonatomic,retain)UIImage *btnSelectedBgImage;

/** 按钮正常背景图片*/
@property(nonatomic,retain)UIImage *btnNormalBgImage;


@property (nonatomic, weak) IBOutlet id<Win5SwitchTitleViewDelegate> titleViewDelegate;

/** 这个方法要在设置好控制器后在调用 */
- (void)reloadData;

@end

@protocol Win5SwitchTitleViewDelegate <NSObject>

@required

- (NSUInteger)numberOfTitleBtn:(Win5SwitchTitleView *)View;

- (UIViewController *)titleView:(Win5SwitchTitleView *)View viewControllerSetWithTilteIndex:(NSUInteger)index;

@optional

- (void)titleView:(Win5SwitchTitleView *)View didselectTitle:(NSUInteger)number;

@end


/*** 如果想在titleBtn下面弄个下滑线,给titleBtn设置一个背景图片就行了 */

/**
 
 1.例子:
Win5SwitchTitleView *view = [[Win5SwitchTitleView alloc] init];
view.titleViewDelegate = self;
view.frame = CGRectMake(0, 0, 320,300);
self.ctrl1 = [[QCListViewController alloc] init];
self.ctrl1.title = @"发生的范德萨发";
[self addChildViewController:self.ctrl1];//如果想要push效果 需加上
[view reloadData];//要放在最下面调用
[self.view addSubview:view];

 #pragma delegate
 - (NSUInteger)numberOfTitleBtn:(Win5SwitchTitleView *)View
 {
 return 1;
 }
 - (UIViewController *)titleView:(Win5SwitchTitleView *)View viewControllerSetWithTilteIndex:(NSUInteger)index
 {
 if (index == 0) {
 return self.ctrl1;
 
 }
 return nil;
 }
 
 2.或者用xib和storyboard直接约束,然后只需要调用下reloadData,完成代理就行了.
 3.IOS7以上(且使用autolayout的）需要在控制器里面将automaticallyAdjustsScrollViewInsets属性设置为NO。[原因是标题滚动按钮没进行约束]
 4.注意该控件最好完全宽度要保持和屏幕宽度一致
 5.如果有bug,自行调调约束
*/

