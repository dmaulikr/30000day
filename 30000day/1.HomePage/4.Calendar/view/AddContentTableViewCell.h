//
//  AddContentTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/2/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemindModel.h"
#import "GJTextView.h"

@interface AddContentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet GJTextView *contentTextView;

@property (nonatomic,strong) RemindModel *model;

@end
