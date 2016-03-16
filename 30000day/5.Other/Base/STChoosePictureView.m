//
//  STChoosePictureView.m
//  30000day
//
//  Created by GuoJia on 16/3/15.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STChoosePictureView.h"
#import "AppointmentCollectionViewCell.h"

@interface STChoosePictureCollectionCell : UICollectionViewCell

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,copy) void (^buttonClickBlock)(NSIndexPath *indexPath);

@end

@implementation STChoosePictureCollectionCell

- (void)configUI {
    
    //1.设置imageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];

    imageView.backgroundColor = [UIColor orangeColor];
    
    [self addSubview:imageView];
    
    //2.button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(self.width - 20, 0 , 20, 20);
    
    button.layer.cornerRadius = 10;
    
    button.layer.masksToBounds = YES;
    
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    button.layer.borderWidth = 1.0f;
    
    [button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
}

- (void)cancelButtonAction {
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self configUI];
}

@end

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

- (void)configUI {
    
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[UICollectionView class]]) {
            
            [view removeFromSuperview];
        }
    }
    
    //1.设置FlowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumInteritemSpacing = 0;
    
    layout.minimumLineSpacing = 0;
    
    layout.itemSize = CGSizeMake(40,40);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    layout.headerReferenceSize = CGSizeMake(0.5f, 0.5f);
    
    layout.footerReferenceSize = CGSizeMake(0.5f, 0.5f);
    
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //2.设置表格视图
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5,5,self.width - 10,self.height - 10) collectionViewLayout:layout];
    
    [collectionView setCollectionViewLayout:layout animated:YES];
    
    collectionView.backgroundColor = [UIColor redColor];
    
    collectionView.delegate = self;
    
    [collectionView registerClass:[STChoosePictureCollectionCell class] forCellWithReuseIdentifier:@"STChoosePictureCollectionCell"];
    
    collectionView.delegate = self;
    
    collectionView.dataSource = self;
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.showsHorizontalScrollIndicator = YES;
    
    self.collectionView = collectionView;
    
    [self addSubview:collectionView];
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
        
        cell = [[STChoosePictureCollectionCell alloc] init];
    }
    
    return cell;
}

- (void)setImageArray:(NSMutableArray *)imageArray {
    
    _imageArray = imageArray;
    
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"----%d",indexPath.section);
}

@end
