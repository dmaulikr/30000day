//
//  STSendMediumTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/7/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJTextView.h"
#import "STChoosePictureView.h"

@class STSendMediumTableViewCell;

@protocol STSendMediumDelegale <NSObject>
//文字改变回调
- (void)sendMediumContentChange:(STSendMediumTableViewCell *)tableViewCell changedContext:(NSString *)changedContext;
- (void)sendMediumChooseMediaChange:(STSendMediumTableViewCell *)tableViewCell;

@end

@interface STSendMediumTableViewCell : UITableViewCell

@property (nonatomic,assign) STChooseMediaType sendType;
@property (nonatomic,strong) GJTextView *textView;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) NSMutableArray *videoArray;
@property (nonatomic,weak) id delegate;

+ (CGFloat)heightSendMediumCell:(NSMutableArray <STChooseMediaModel *>*)imageArray videoArray:(NSMutableArray <STChooseMediaModel *>*)videoArray;
- (void)reloadData;

- (void)cleanData;

@end
