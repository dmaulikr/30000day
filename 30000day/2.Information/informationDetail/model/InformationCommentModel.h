//
//  InformationCommentModel.h
//  30000day
//
//  Created by wei on 16/4/19.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationCommentModel : NSObject

@property (nonatomic,copy) NSString *busiType;
@property (nonatomic,copy) NSString *isClickLike;
@property (nonatomic,copy) NSString *countCommentNum;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *defaultShowCount;
@property (nonatomic,copy) NSString *commentId;
@property (nonatomic,copy) NSString *numberStar;
@property (nonatomic,copy) NSString *pId;
@property (nonatomic,copy) NSString *busiId;
@property (nonatomic,copy) NSString *remark;
@property (nonatomic,copy) NSString *sumStars;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *headImg;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *parentUserName;

@property (nonatomic,assign) BOOL selected;//是否被选中的

@end
