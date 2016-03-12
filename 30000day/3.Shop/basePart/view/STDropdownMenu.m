//
//  STDropdownMenu.m
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STDropdownMenu.h"

@interface DropdownTableViewCell : UITableViewCell

@property(nonatomic ,retain) UILabel *titleLabel;

@end


@implementation DropdownTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configUI];
    }
    
    return self;
}

- (void)configUI {
    
    //文字label
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.titleLabel = titleLabel;
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:titleLabel];
    
    //底部背景线条
    UIView *buttomLineView = [[UIView alloc] init];
    
    buttomLineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    buttomLineView.backgroundColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:buttomLineView];
    
    NSArray *label_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)];
    
    NSArray *view_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[buttomLineView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(buttomLineView)];
    
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleLabel]-0-[buttomLineView(0.5)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel,buttomLineView)];
    
    [self.contentView addConstraints:label_constraint_H];
    
    [self.contentView addConstraints:view_constraint_H];
    
    [self.contentView addConstraints:constraint_V];
}

@end

@interface STDropdownMenu () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,retain)NSLayoutConstraint *imageViewWidthConstraint;//宽度约束

@property(nonatomic,retain)NSLayoutConstraint *imageViewHeightConstraint;//高度约束

@property (nonatomic,retain)UIImageView *imageView;

@property (nonatomic,retain) NSIndexPath *selectIndexPath;//选中的indexPath

@end

@implementation STDropdownMenu

- (instancetype)init
{
    if (self = [super init]) {
        [self configUI];
    }
    return self;
}

+ (instancetype)menu {
    return [[self alloc] init];
}

- (void)configUI {
    //背景图片
    UIImageView *imageView = [[UIImageView alloc] init];
    UIImage *image = [UIImage imageNamed:@"Rectangle_l"];
    CGFloat top = 40; // 顶端盖高度
    CGFloat bottom = 40 ; // 底端盖高度
    CGFloat left = 40; // 左端盖宽度
    CGFloat right = 40; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    imageView.image = image;
    
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.userInteractionEnabled =  YES;
    self.imageView = imageView;
    [self addSubview:imageView];
    
    //表格视图
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setTableFooterView:[[UIView alloc] init]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.userInteractionEnabled = YES;
    [imageView addSubview:tableView];
    self.tableView = tableView;
    
    NSArray *tableViewwConstraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[tableView]-1-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)];
    NSArray *tableViewwConstraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[tableView]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tableView)];
    
    [imageView addConstraints:tableViewwConstraint_H];
    [imageView addConstraints:tableViewwConstraint_V];
    //添加约束
    NSArray *imageViewConstraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-2-[imageView(80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)];
    NSArray *imageViewConstraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[imageView(163)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)];
    
    [self addConstraints:imageViewConstraint_H];
    
    [self addConstraints:imageViewConstraint_V];

    self.imageViewWidthConstraint = [imageViewConstraint_H firstObject];
    
    self.imageViewHeightConstraint = [imageViewConstraint_V lastObject];
    
    self.backgroundColor = RGBACOLOR(200, 200, 200, 0.3);
    
}

- (CGSize)titleSize:(NSString *)title {
    CGRect frame = [title boundingRectWithSize:CGSizeMake(2000, 25) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil];
    return frame.size;
}

- (void)showView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
    //1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];

    //2.添加到自己的窗口上
    [window addSubview:self];
    
    //3.设置尺寸
    self.frame = window.bounds;
    
    
//    //调整灰色图片的箭头指向
//    self.imageView.frame.origin.x = (self.width - self.imageView.width)* 0.5;
//    
//    //self.containerView.y = CGRectGetMaxY(from.frame) + 20;
//    //默认情况下frame 是相对于父控件坐标系原点的,
//    //bounds是相对于自己来算的
//    //可以通过转过坐标系原点改变frame参照点
//    CGRect newFrame =  [from.superview convertRect:from.frame toView:window];//nil相对于空的
//    //这句代码的意思是 吧from.frame 从相对于from的父控件变成相对于window了
//    self.containerView.y = CGRectGetMaxY(newFrame);
//    self.containerView.centerX =  CGRectGetMidX(newFrame);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    CGRect imageViewFrame = self.imageView.frame;
    CGFloat imageView_X = imageViewFrame.origin.x;
    CGFloat imageView_Y = imageViewFrame.origin.y;
    CGFloat imageView_H = imageViewFrame.size.height;
    
    CGFloat X = touchPoint.x;
    CGFloat Y = touchPoint.y;
    
    //这个判断条件表示点击了模态视图
//    if (  !(( X > imageView_X)  && ((Y > imageView_Y)&& (Y < imageView_Y + imageView_H)))) {
//        //清楚所有的视图
//        [self dismiss];
//    }
    
    [self dismiss];
}

/**
 * 销毁
 */
- (void)dismiss {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    }
    
    [self removeFromSuperview];
}

#pragma  mark ---- UITableViewDelegate/UITableDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DropdownTableViewCell *cell = (DropdownTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DropdownTableViewCell"];
    if (cell == nil) {
        cell = [[DropdownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DropdownTableViewCell"];
    }
    
    if (self.selectIndexPath ) {
        if (self.selectIndexPath.row == indexPath.row) {
            cell.titleLabel.textColor = [UIColor darkGrayColor];
        }else{
            cell.titleLabel.textColor = [UIColor blackColor];
        }
    }
    
    cell.titleLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.delegate && [self.delegate respondsToSelector:@selector(dropdownMenu:didSelectRowAtIndexPath:)]) {
        
        [self.delegate dropdownMenu:self didSelectRowAtIndexPath:indexPath];
        
    }
    
    [self dismiss];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

//设置数据源
- (void)setDataArray:(NSMutableArray *)dataArray {
    
    _dataArray = dataArray;
    
    int i = 0;
    
    if (_dataArray.count > 5) {
        
        i = 5;
        
    } else {
      
        i = _dataArray.count;
    }
    
    self.imageViewHeightConstraint.constant = i * 44 + 12;
    
    [self.tableView reloadData];
}

@end





