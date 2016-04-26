//
//  STChoosePictureView.m
//  30000day
//
//  Created by GuoJia on 16/3/15.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STChoosePictureView.h"
#import "STChoosePictureCollectionCell.h"


@interface STChoosePictureView () <UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation STChoosePictureView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self configUI];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self configUI];
    }
    return self;
}

- (id)init {
    
    if (self = [super init]) {
        
        [self configUI];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(5,5,self.width - 10,self.height - 10);
}

- (void)configUI {
    
    if (!self.collectionView) {
        
        //1.设置FlowLayout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumInteritemSpacing = 0;
        
        layout.minimumLineSpacing = 0;
        
        layout.itemSize = CGSizeMake(60,60);
        
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        layout.headerReferenceSize = CGSizeMake(0.5f, 0.5f);
        
        layout.footerReferenceSize = CGSizeMake(0.5f, 0.5f);
        
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        //2.设置表格视图
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5,5,self.width - 10,self.height - 10) collectionViewLayout:layout];
        
        [collectionView setCollectionViewLayout:layout animated:YES];
        
        collectionView.backgroundColor = [UIColor redColor];
        
        [collectionView registerNib:[UINib nibWithNibName:@"STChoosePictureCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"STChoosePictureCollectionCell"];
        
        collectionView.delegate = self;
        
        collectionView.dataSource = self;
        
        collectionView.backgroundColor = [UIColor whiteColor];
        
        collectionView.showsHorizontalScrollIndicator = YES;
        
        [self addSubview:collectionView];
        
        self.collectionView = collectionView;
        
        self.imageArray = [[NSMutableArray alloc] init];
    }
    
    if (!self.imageArray) {
        
        self.imageArray = [[NSMutableArray alloc] init];
    }
    
}

#pragma ---
#pragma mark --- UICollectionViewDataSource/UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.imageArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    STChoosePictureCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"STChoosePictureCollectionCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"STChoosePictureCollectionCell" owner:nil options:nil] lastObject];
    }
    
    cell.imageView.image = self.imageArray[indexPath.section];
    
    cell.indexPath = indexPath;
    
    //删除按钮点击回调
    [cell setButtonClickBlock:^(NSIndexPath *indexPath) {
        
        if (self.imageArray.count > indexPath.section ) {
            
            if ([self.delegate respondsToSelector:@selector(choosePictureView:cancelButtonDidClickAtIndex:)]) {
                
                [self.delegate choosePictureView:self cancelButtonDidClickAtIndex:indexPath.section];
            }
        }
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.delegate respondsToSelector:@selector(choosePictureView:didClickCellAtIndex:)]) {
        
        [self.delegate choosePictureView:self didClickCellAtIndex:indexPath.section];
    }
}

- (void)setImageArray:(NSMutableArray *)imageArray {
    
    _imageArray = imageArray;
    
    [self.collectionView reloadData];
}

- (void)dealloc {
    
    self.collectionView = nil;
    
    self.imageArray = nil;
}


@end
