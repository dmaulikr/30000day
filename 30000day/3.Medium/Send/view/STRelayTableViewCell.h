//
//  STRelayTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/8/4.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GJTextView.h"
#import "STMediumModel.h"

@interface STRelayTableViewCell : UITableViewCell

@property (nonatomic,strong) STMediumModel *mediumModel;
@property(weak,nonatomic)IBOutlet GJTextView *textView;
@property(weak,nonatomic)IBOutlet UIImageView *headImageView;
@property(weak,nonatomic)IBOutlet UILabel *titleLabel;
@property(weak,nonatomic)IBOutlet UILabel *contentLabel;

@end
