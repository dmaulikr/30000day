//
//  AppointmentCollectionView.m
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AppointmentCollectionView.h"
#import "AppointmentCollectionViewCell.h"
#import "TitleCollectionViewCell.h"

#define HeightMargin  0.0f

@interface AppointmentCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation AppointmentCollectionView

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self configUI];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [self configUI];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
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
    
    self.backgroundColor = [UIColor whiteColor];
    
    //1.设置FlowLayout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumInteritemSpacing = 0;
    
    layout.minimumLineSpacing = 0;
    
    layout.itemSize = CGSizeMake((self.width - 50.0f)/5.0f,(self.height - HeightMargin)/(self.time_dataArray.count ? self.time_dataArray.count : 4));
    
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    layout.headerReferenceSize = CGSizeMake(0.5f, 0.5f);
    
    layout.footerReferenceSize = CGSizeMake(0.5f, 0.5f);
    
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //2.设置表格视图
   
     UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(50, HeightMargin,self.width - 50,self.height - HeightMargin) collectionViewLayout:layout];
    
    [collectionView setCollectionViewLayout:layout animated:NO];
    
    collectionView.delegate = self;
    
    [collectionView registerNib:[UINib nibWithNibName:@"AppointmentCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"AppointmentCollectionViewCell"];
    
    [collectionView registerNib:[UINib nibWithNibName:@"TitleCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TitleCollectionViewCell"];
    
    collectionView.delegate = self;
    
    collectionView.dataSource = self;
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.showsHorizontalScrollIndicator = YES;
    
    [self addSubview:collectionView];
    
    //3.循环创建时间label
    for (int i = 0; i < self.time_dataArray.count; i++) {
    
        UILabel *timeLabel = [[UILabel alloc] init];
        
        timeLabel.text = self.time_dataArray[i];
        
        timeLabel.frame = CGRectMake(0.0f, HeightMargin + (self.height - HeightMargin)/(self.time_dataArray.count ? self.time_dataArray.count : 4)/2.0f + (self.height - HeightMargin)/(self.time_dataArray.count ? self.time_dataArray.count : 4)*i, 50, (self.height - HeightMargin)/(self.time_dataArray.count ? self.time_dataArray.count : 4.0f));
        
        timeLabel.textAlignment = NSTextAlignmentCenter;
        
        timeLabel.textColor = [UIColor darkGrayColor];
        
        timeLabel.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:timeLabel];
    }
}

#pragma ---
#pragma mark --- UICollectionViewDataSource/UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.time_dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section <= self.dataArray.count && indexPath.row == 0) {

        static NSString *titleIdentifier = @"TitleCollectionViewCell";
        
        TitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:titleIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:titleIdentifier owner:nil options:nil] firstObject];
        }
        
        cell.titleLabel.text = self.dataArray[indexPath.section];
        
        return cell;
    
    } else {
    
        static NSString *appoinitmentIdentifier = @"AppointmentCollectionViewCell";
        
        AppointmentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:appoinitmentIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:appoinitmentIdentifier owner:nil options:nil] lastObject];
        }
        
        return cell;
    }
    
    return nil;
}

- (void)setTime_dataArray:(NSMutableArray *)time_dataArray {
    
    _time_dataArray = time_dataArray;
    
    [self setNeedsDisplay];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger a = indexPath.section;
    
    NSInteger b = indexPath.row;
    
    if ([self.delegate respondsToSelector:@selector(appointmentCollectionView: didSelectionAppointmentIndexPath:)]) {
        
        [self.delegate appointmentCollectionView:self didSelectionAppointmentIndexPath:[NSIndexPath indexPathForItem:a inSection:b]];
    }
}

//
//- (void)setDataArray:(NSMutableArray *)dataArray {
//    
//    _dataArray = dataArray;
//    
//    [self setNeedsDisplay];
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
