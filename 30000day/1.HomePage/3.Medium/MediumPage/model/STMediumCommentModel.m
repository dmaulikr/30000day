//
//  STMediumCommentModel.m
//  30000day
//
//  Created by GuoJia on 16/10/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumCommentModel.h"

@implementation STMediumCommentModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"currentId":@"id"};
}

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
    if ([Common isObjectNull:self.responserHeadImg]) {
        return self.commenterHeadImg;
    } else {
        return self.responserHeadImg;
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
    if (![Common isObjectNull:self.responserRemark]) {
        return [[NSMutableAttributedString alloc] initWithString:self.responserRemark attributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
    } else {
        return [[NSMutableAttributedString alloc] initWithString:self.commenterRemark attributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor]}];
    }
}

//用来发送leanCloud消息的
- (NSString *)headImgUsedByLeanCloud {
    if ([Common isObjectNull:self.responserHeadImg]) {
        return self.commenterHeadImg;
    } else {
        return self.responserHeadImg;
    }
}

- (NSString *)nickNameUsedByLeanCloud {
    if ([Common isObjectNull:self.responser]) {
        return self.commenter;
    } else {
        return self.responser;
    }
}

- (NSNumber *)userIdUsedByLeanCloud {
    if ([Common isObjectNull:self.responserId] || [self.responserId isEqualToNumber:@0]) {
        return self.commenterId;
    } else {
        return self.responserId;
    }
}

@end
