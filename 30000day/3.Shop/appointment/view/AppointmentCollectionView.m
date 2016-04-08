//
//  AppointmentCollectionView.m
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AppointmentCollectionView.h"


#define HeightMargin  0.0f

#define WidthMargin  100.0f

#define cellNumber_width  4.0f

@interface FlagModel : NSObject

@property (nonatomic,strong) NSIndexPath *flagIndexPath;

@property (nonatomic,assign) NSInteger flag;//用来表示是否被选中

@end

@implementation FlagModel

- (id)init {
    
    if (self = [super init]) {
        
        _flag = 0;
        
    }
    
    return self;
}

@end

@interface AppointmentCollectionView () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> {
    NSMutableArray *_flagArray;
    
    UICollectionView *_collectionView;
}
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
    
    CGFloat length = (self.height - HeightMargin)/(self.time_dataArray.count ? (self.time_dataArray.count + 1) : cellNumber_width);
    
    layout.itemSize = CGSizeMake((self.width - WidthMargin)/cellNumber_width,length);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    layout.headerReferenceSize = CGSizeMake(0.05f, 0.05f);
    
    layout.footerReferenceSize = CGSizeMake(0.05f, 0.05f);
    
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    //2.设置表格视图
     UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(WidthMargin, HeightMargin,self.width - WidthMargin,self.height - HeightMargin) collectionViewLayout:layout];
    
    [collectionView setCollectionViewLayout:layout animated:NO];
    
    collectionView.delegate = self;
    
    [collectionView registerNib:[UINib nibWithNibName:@"AppointmentCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"AppointmentCollectionViewCell"];
    
    [collectionView registerNib:[UINib nibWithNibName:@"TitleCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TitleCollectionViewCell"];
    
    collectionView.delegate = self;
    
    collectionView.dataSource = self;
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.showsHorizontalScrollIndicator = YES;
    
    [self addSubview:collectionView];
    
    _collectionView = collectionView;
    
    //3.循环创建时间label
    for (int i = 0; i < self.time_dataArray.count; i++) {
    
        UILabel *timeLabel = [[UILabel alloc] init];
        
        timeLabel.text = self.time_dataArray[i];
                
        timeLabel.frame = CGRectMake(0.0f, HeightMargin + length + length*i, WidthMargin, length);
        
        timeLabel.textAlignment = NSTextAlignmentCenter;
        
        timeLabel.textColor = [UIColor darkGrayColor];
        
        timeLabel.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:timeLabel];
    }
}

#pragma ---
#pragma mark --- UICollectionViewDataSource/UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.time_dataArray.count + 1;
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

        if ([self.delegate respondsToSelector:@selector(appointmentCollectionView:typeForRowAtIndexPath:)]) {
            
            NSInteger a = indexPath.section;
            
            NSInteger b = indexPath.row;
            
            AppointmentColorType type = [self.delegate appointmentCollectionView:self typeForRowAtIndexPath:[NSIndexPath indexPathForItem:a inSection:b - 1]];
            
            cell.type = type;
            
            if (type == AppointmentColorCanUse) {
        
                if (_flagArray.count) {
                    
                    FlagModel *model = _flagArray[b-1][a];
                    
                    if (model.flag) {
                        
                        cell.backgroundColor = [UIColor redColor];
                        
                    } else {
                        
                        cell.backgroundColor = RGBACOLOR(175, 235, 178, 1);
                        
                    }
                    
                    cell.titleLabel.textColor = [UIColor darkGrayColor];
                    
                }
                
            } else if (type == AppointmentColorMyUse) {
                
                cell.backgroundColor = RGBACOLOR(204, 225, 255, 1);
                
                cell.titleLabel.textColor = [UIColor darkGrayColor];
                
            } else if (type == AppointmentColorSellOut) {
                
                cell.backgroundColor = RGBACOLOR(242, 242, 242, 1);
                
                cell.titleLabel.textColor = [UIColor darkGrayColor];
                
            } else if (type == AppointmentColorNoneUse) {
                
                cell.backgroundColor = [UIColor whiteColor];
                
                cell.titleLabel.textColor = RGBACOLOR(200, 200, 200, 1);
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(appointmentCollectionView:titleForRowAtIndexPath:)]) {
            
            NSInteger a = indexPath.section;
            
            NSInteger b = indexPath.row;
            
            if (cell.type != AppointmentColorNoneUse) {//可用状态
                
                cell.titleLabel.text = [self.delegate appointmentCollectionView:self titleForRowAtIndexPath:[NSIndexPath indexPathForItem:a inSection:b - 1]];
                
            } else {//不可用状态
                
                cell.titleLabel.text = @"不可用";
            }
        }
        
        return cell;
    }
    
    return nil;
}

- (void)setTime_dataArray:(NSMutableArray *)time_dataArray {
    
    _time_dataArray = time_dataArray;
}

- (void)reloadData {
    
    //循环设置数据源数组
    _flagArray = [NSMutableArray array];
    
    NSInteger a = _time_dataArray.count ? _time_dataArray.count : cellNumber_width;
    
    NSInteger b = _dataArray.count ? _dataArray.count : cellNumber_width;
    
    for (int i = 0 ; i < a ; i++) {
        
        NSMutableArray *firstArray = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < b; j++) {
            
            FlagModel *model = [[FlagModel alloc] init];
            
            model.flagIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
            
            model.flag = 0;
            
            [firstArray addObject:model];
        }
        
        [_flagArray addObject:firstArray];
    }
    [_collectionView reloadData];//重新刷新数据
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger a = indexPath.section;
    
    NSInteger b = indexPath.row;
    
     if (!(indexPath.section <= self.dataArray.count && indexPath.row == 0)) {
         
         AppointmentCollectionViewCell *cell = (AppointmentCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
         
         if (cell.type == AppointmentColorCanUse) {
            
             if (_flagArray.count) {//如果存在
                 
                 FlagModel *model = _flagArray[b-1][a];
                 
                 if (model.flag) {
                     
                     model.flag = 0;
                     
                     cell.backgroundColor = RGBACOLOR(175, 235, 178, 1);
                     
                     if ([self.delegate respondsToSelector:@selector(appointmentCollectionView: didSelectionAppointmentIndexPath:selector:)]) {
                         
                         [self.delegate appointmentCollectionView:self didSelectionAppointmentIndexPath:[NSIndexPath indexPathForRow:a inSection:b-1] selector:NO];
                     }
                     
                 } else {
                     
                     model.flag = 1;
                     
                     cell.backgroundColor = [UIColor redColor];
                     
                     if ([self.delegate respondsToSelector:@selector(appointmentCollectionView: didSelectionAppointmentIndexPath:selector:)]) {
                         
                         [self.delegate appointmentCollectionView:self didSelectionAppointmentIndexPath:[NSIndexPath indexPathForRow:a inSection:b-1] selector:YES];
                     }
                 }
             }
            
         }
     }
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    
    _dataArray = dataArray;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
