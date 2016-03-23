//
//  CommentDetailsViewController.h
//  30000day
//
//  Created by wei on 16/3/22.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentDetailsViewController : STRefreshViewController

@property (nonatomic,strong) CommentModel* commentModel;

@end
