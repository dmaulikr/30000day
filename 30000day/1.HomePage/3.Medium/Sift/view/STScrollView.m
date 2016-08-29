//
//  STScrollView.m
//  30000day
//
//  Created by GuoJia on 16/7/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STScrollView.h"

@interface STPrivateCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *titleLabel;


@end

@implementation STPrivateCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 2;
        self.layer.masksToBounds = YES;
        
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.7f;
        
        if (!self.titleLabel) {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.font = [UIFont systemFontOfSize:15.0f];
            titleLabel.textColor = [UIColor darkGrayColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:titleLabel];
            self.titleLabel = titleLabel;
        }
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)prepareForReuse {
    self.titleLabel.text = nil;
    [super prepareForReuse];
}

@end

@interface STScrollView () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation STScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    
    //1.设置FlowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(ITEM_WIDTH,ITME_HIGHT);
    layout.sectionInset = UIEdgeInsetsMake(0, 2.5f, 0, 2.5f);
    layout.headerReferenceSize = CGSizeMake(0.5f, 0.5f);
    layout.footerReferenceSize = CGSizeMake(0.5f, 0.5f);
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //2.设置表格视图
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,self.width,self.height) collectionViewLayout:layout];
    [collectionView setCollectionViewLayout:layout animated:YES];
    collectionView.backgroundColor = [UIColor redColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = YES;
    [collectionView registerClass:[STPrivateCollectionViewCell class] forCellWithReuseIdentifier:@"STPrivateCollectionViewCell"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma ---
#pragma mark --- UICollectionViewDataSource/UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    if ([self.delegate respondsToSelector:@selector(numberOfItemInScrollView:)]) {
        return [self.delegate numberOfItemInScrollView:self];
    }
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    STPrivateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STPrivateCollectionViewCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[STPrivateCollectionViewCell alloc] init];
    }
    
    if ([self.delegate respondsToSelector:@selector(titleOfItemInScrollView:index:)]) {
        
        cell.titleLabel.text = [self.delegate titleOfItemInScrollView:self index:indexPath.section];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(scrollView:didClickCellAtIndex:)]) {
        [self.delegate scrollView:self didClickCellAtIndex:indexPath.section];
    }
}

@end
