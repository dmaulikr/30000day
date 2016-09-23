//
//  XHEmotionManagerView.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHEmotionManagerView.h"

#import "XHEmotionSectionBar.h"

#import "XHEmotionCollectionViewCell.h"
#import "XHEmotionCollectionViewFlowLayout.h"


@interface XHEmotionManagerView () <UICollectionViewDelegate, UICollectionViewDataSource, XHEmotionSectionBarDelegate,UICollectionViewDelegateFlowLayout>

/**
 *  显示表情的collectView控件
 */
@property (nonatomic, weak) UICollectionView *emotionCollectionView;

/**
 *  显示页码的控件
 */
@property (nonatomic, weak) UIPageControl *emotionPageControl;

/**
 *  管理多种类别gif表情的滚动试图
 */
@property (nonatomic, weak) XHEmotionSectionBar *emotionSectionBar;

/**
 *  当前选择了哪类gif表情标识
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 *  配置默认控件
 */
- (void)setup;

@end

@implementation XHEmotionManagerView

- (void)reloadData {
    
    NSInteger numberOfEmotionManagers = [self.dataSource numberOfEmotionManagers];
    
    if (!numberOfEmotionManagers) {
        
        return ;
    }
    
    self.emotionSectionBar.emotionManagers = [self.dataSource emotionManagersAtManager];
    
    [self.emotionSectionBar reloadData];
    
    
    XHEmotionManager *emotionManager = [self.dataSource emotionManagerForColumn:self.selectedIndex];
    
    self.emotionPageControl.numberOfPages = emotionManager.estimatedPages;
    
    [self.emotionCollectionView reloadData];
    
    //滚动到第一页位置
    [self.emotionCollectionView scrollRectToVisible:CGRectMake(0, 0, self.emotionCollectionView.size.width, self.emotionCollectionView.size.height) animated:NO];
}

#pragma mark - Life cycle

- (void)setup {
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
    
    self.isShowEmotionStoreButton = YES;
    
    if (!_emotionCollectionView) {
        UICollectionView *emotionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kXHEmotionPageControlHeight - kXHEmotionSectionBarHeight) collectionViewLayout:[[XHEmotionCollectionViewFlowLayout alloc] init]];
        emotionCollectionView.backgroundColor = [UIColor whiteColor];
        [emotionCollectionView registerClass:[XHEmotionCollectionViewCell class] forCellWithReuseIdentifier:kXHEmotionCollectionViewCellIdentifier];
        emotionCollectionView.showsHorizontalScrollIndicator = NO;
        emotionCollectionView.showsVerticalScrollIndicator = NO;
        [emotionCollectionView setScrollsToTop:NO];
        emotionCollectionView.pagingEnabled = YES;
        emotionCollectionView.delegate = self;
        emotionCollectionView.dataSource = self;
        [self addSubview:emotionCollectionView];
        self.emotionCollectionView = emotionCollectionView;
    }
    
    if (!_emotionPageControl) {
        UIPageControl *emotionPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionCollectionView.frame), CGRectGetWidth(self.bounds), kXHEmotionPageControlHeight)];
        emotionPageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.471 alpha:1.000];
        emotionPageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.678 alpha:1.000];
        emotionPageControl.backgroundColor = [UIColor whiteColor];
        emotionPageControl.hidesForSinglePage = YES;
        emotionPageControl.defersCurrentPageDisplay = YES;
        [self addSubview:emotionPageControl];
        self.emotionPageControl = emotionPageControl;
    }
    
    if (!_emotionSectionBar) {
        XHEmotionSectionBar *emotionSectionBar = [[XHEmotionSectionBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.emotionPageControl.frame), CGRectGetWidth(self.bounds), kXHEmotionSectionBarHeight) showEmotionStoreButton:self.isShowEmotionStoreButton];
        emotionSectionBar.delegate = self;
        emotionSectionBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        emotionSectionBar.backgroundColor = RGBACOLOR(247, 247, 247, 1);
        [self addSubview:emotionSectionBar];
        self.emotionSectionBar = emotionSectionBar;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)dealloc {
    self.emotionPageControl = nil;
    self.emotionSectionBar = nil;
    self.emotionCollectionView.delegate = nil;
    self.emotionCollectionView.dataSource = nil;
    self.emotionCollectionView = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self reloadData];
    }
}

#pragma mark - XHEmotionSectionBar Delegate

- (void)didSelecteEmotionManager:(XHEmotionManager *)emotionManager atSection:(NSInteger)section {
    self.selectedIndex = section;
    self.emotionPageControl.currentPage = 0;
    [self reloadData];
}

-(void)didSelectEmotionStoreButton:(id)button{
    if([self.delegate respondsToSelector:@selector(didSelectEmotionStoreButton:)]){
        [self.delegate didSelectEmotionStoreButton:button];
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.emotionPageControl setCurrentPage:currentPage];
}

#pragma UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    XHEmotionManager *emotionManager = [self.dataSource emotionManagerForColumn:self.selectedIndex];
    
    if (self.selectedIndex) {//表示是大图的gif表情
        
        return emotionManager.emotions.count%8 ? (emotionManager.emotions.count/8 + 1) : (emotionManager.emotions.count/8);
        
    } else {//小图表情
        
        return emotionManager.emotions.count%21 ? (emotionManager.emotions.count/21 + 1) : (emotionManager.emotions.count/21);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    XHEmotionManager *emotionManager = [self.dataSource emotionManagerForColumn:self.selectedIndex];
    
    if (emotionManager.emotions.count % (self.selectedIndex ? 8 : 21)) {//没除尽
        
        if (section ==  emotionManager.emotions.count/(self.selectedIndex ? 8 : 21)) {
            
            return emotionManager.emotions.count%(self.selectedIndex ? 8 : 21);
        }
        
        return (self.selectedIndex ? 8 : 21);
        
    } else {//除尽了
        
        return (self.selectedIndex ? 8 : 21);
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XHEmotionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXHEmotionCollectionViewCellIdentifier forIndexPath:indexPath];
    
    XHEmotionManager *emotionManager = [self.dataSource emotionManagerForColumn:self.selectedIndex];
    
    cell.emotion = emotionManager.emotions[indexPath.row + (self.selectedIndex?8:21) * indexPath.section];
    
    cell.emotionSize = emotionManager.emotionSize;
    
    return cell;
}

#pragma mark - UICollectionView delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedIndex) {//特殊表情
        
        return CGSizeMake(45.0f,45.0f);
        
    } else {//普通表情
        
        XHEmotionManager *emotionManager = [self.dataSource emotionManagerForColumn:self.selectedIndex];
        
        return emotionManager.emotionSize;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(didSelecteEmotion:atIndexPath:)]) {
        
        XHEmotionManager *emotionManager = [self.dataSource emotionManagerForColumn:self.selectedIndex];
        
        [self.delegate didSelecteEmotion:emotionManager.emotions[indexPath.row + indexPath.section * (self.selectedIndex?8:21)] atIndexPath:indexPath];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
        
    return self.selectedIndex ? UIEdgeInsetsMake(kXHEmotionCollectionViewSectionInset, (SCREEN_WIDTH - 180) / 5.0f, kXHEmotionCollectionViewSectionInset, (SCREEN_WIDTH - 180) / 5.0f)  :UIEdgeInsetsMake(kXHEmotionCollectionViewSectionInset, (SCREEN_WIDTH - 245) / 8.0f, 0, (SCREEN_WIDTH - 245) / 8.0f);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return self.selectedIndex ? (SCREEN_WIDTH - 180) / 5.0f :(SCREEN_WIDTH - 245) / 8.0f;
}

@end
