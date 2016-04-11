//
//  InformationDetailDownView.h
//  30000day
//
//  Created by wei on 16/4/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationDetailDownView : UIView

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIButton *zanButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (nonatomic,copy) void (^(shareButtonBlock))(UIButton *shareButton);

@property (nonatomic,copy) void (^(commentButtonBlock))();

@property (nonatomic,copy) void (^(zanButtonBlock))(UIButton *zanButton);

@end
