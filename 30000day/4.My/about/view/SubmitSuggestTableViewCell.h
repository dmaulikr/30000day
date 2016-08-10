//
//  SubmitSuggestTableViewCell.h
//  30000day
//
//  Created by wei on 16/8/8.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitSuggestTableViewCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic,strong) UILabel *lable;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic,copy) void (^(subMitBlock))();


@end
