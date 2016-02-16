//
//  ShareAnimatonView.h
//  30000day
//
//  Created by GuoJia on 16/2/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressAnimationView.h"

@interface ShareAnimatonView : UIView

@property (weak, nonatomic) IBOutlet UIView *backgroudView;

@property (nonatomic , copy) void (^(shareButtonBlock))(NSInteger tag);

@end
