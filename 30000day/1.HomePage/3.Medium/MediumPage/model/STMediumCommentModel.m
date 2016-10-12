//
//  STMediumCommentModel.m
//  30000day
//
//  Created by GuoJia on 16/10/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumCommentModel.h"

@implementation STMediumCommentModel

- (NSMutableAttributedString *)getAttributeName {
    
    if ([Common isObjectNull:self.responser]) {
        return [[NSMutableAttributedString alloc] initWithString:self.commenter attributes:@{NSForegroundColorAttributeName:LOWBLUECOLOR}];
    } else {
        NSMutableAttributedString *string_1 = [[NSMutableAttributedString alloc] initWithString:self.responser attributes:@{NSForegroundColorAttributeName:LOWBLUECOLOR}];
        NSMutableAttributedString *string_2  = [[NSMutableAttributedString alloc] initWithString:@"回复" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        NSMutableAttributedString *string_3 = [[NSMutableAttributedString alloc] initWithString:self.commenter attributes:@{NSForegroundColorAttributeName:LOWBLUECOLOR}];
        [string_1 appendAttributedString:string_2];
        [string_1 appendAttributedString:string_3];
        return string_1;
    }
}

- (NSString *)getDisplayHeadImg {
    if (self.responserHeadImg) {
        return self.responserHeadImg;
    } else {
        return self.commenterHeadImg;
    }
}

- (NSNumber *)getDisplayTime {
    if (self.responserCreateTime) {
        return self.responserCreateTime;
    } else {
        return self.commenterCreateTime;
    }
}

- (NSMutableAttributedString *)getDisplayContent {
    if (self.responserRemark) {
        return [[NSMutableAttributedString alloc] initWithString:self.responserRemark attributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
    } else {
        return [[NSMutableAttributedString alloc] initWithString:self.commenterRemark attributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
    }
}

@end
