//
//  STChoosePictureView.m
//  30000day
//
//  Created by GuoJia on 16/3/15.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STChoosePictureView.h"
#define Button_string         @"close_btn"
#define Corver_image_string   @"MessageVideoPlay"

@interface STChoosePictureCollectionCell : UICollectionViewCell

@property (nonatomic,strong)   NSIndexPath *indexPath;
@property (nonatomic,copy)     void (^buttonClickBlock)(NSIndexPath *indexPath);
@property (nonatomic, strong)  UIImageView *imageView;
@property (nonatomic, strong)  UIButton *button;
@property (nonatomic, strong)  UIImageView *coverImageView;

- (void)configCellWithMedia:(STChooseMediaModel *)mediaModal;

@end

@implementation STChoosePictureCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
    }
    
    if (!self.button) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setImage:[UIImage imageNamed:Button_string] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.button];
    }
    
    if (!self.coverImageView) {
        self.coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:Corver_image_string]];
        [self.imageView addSubview:self.coverImageView];
        self.coverImageView.hidden = YES;
    }
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = RGBACOLOR(230, 230, 230, 1).CGColor;
    self.layer.borderWidth = 0.7f;
}

- (void)buttonClick {
    
    if (self.buttonClickBlock) {
        self.buttonClickBlock(self.indexPath);
    }
}

- (void)configCellWithMedia:(STChooseMediaModel *)mediaModal {
    
    if (mediaModal.mediaType == STChooseMediaPhotoType) {
        
        self.imageView.image = mediaModal.coverImage;
        self.coverImageView.hidden = YES;
        
    } else if (mediaModal.mediaType == STChooseMediaVideoType) {
        
        self.imageView.image = mediaModal.coverImage;
        self.coverImageView.hidden = NO;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0,self.width, self.height);
    self.button.frame = CGRectMake(self.imageView.width - 20, 5, 20, 20);
    self.coverImageView.width = self.imageView.width / 2.50f;
    self.coverImageView.height = self.imageView.width / 2.50f;
    self.coverImageView.center = self.imageView.center;
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
        [collectionView registerClass:[STChoosePictureCollectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
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
    
    STChoosePictureCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
//    if (cell == nil) {
//       cell = [[STChoosePictureCollectionCell alloc] init];
//    } 这里代码是多余的因为:- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier 会调用initWithFrame
    
    cell.indexPath = indexPath;
    [cell configCellWithMedia:self.imageArray[indexPath.section]];

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

@implementation STChooseMediaModel

@end
