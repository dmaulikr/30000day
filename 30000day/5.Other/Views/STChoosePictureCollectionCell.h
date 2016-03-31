//
//  STChoosePictureCollectionCell.h
//  30000day
//
//  Created by GuoJia on 16/3/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STChoosePictureCollectionCell : UICollectionViewCell

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,copy) void (^buttonClickBlock)(NSIndexPath *indexPath);

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end
