//
//  STMediumCommentModel.h
//  30000day
//
//  Created by GuoJia on 16/10/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STMediumCommentModel : NSObject

@property (nonatomic,copy)   NSString *commenterRemark;
@property (nonatomic,copy)   NSString *commenter;//评论或者回复者
@property (nonatomic,copy)   NSString *commenterHeadImg;
@property (nonatomic,strong) NSNumber *commenterCreateTime;//创建时间
@property (nonatomic,copy)   NSString *responser;
@property (nonatomic,strong) NSNumber *responserCreateTime;
@property (nonatomic,copy)   NSString *responserHeadImg;
@property (nonatomic,copy)   NSString *responserRemark;
@property (nonatomic,copy)   NSString *isClickLike;//1：点赞，nil:表示回复或者评论

- (NSMutableAttributedString *)getAttributeName;
- (NSString *)getDisplayHeadImg;
- (NSNumber *)getDisplayTime;
- (NSMutableAttributedString *)getDisplayContent;

//"commenter": "GuoJia",
//"commenterCreateTime": 1476175703000,
//"commenterHeadImg": "http://121.196.223.175:89/images/default.png",
//"commenterRemark": "Sdfsdf",
//"responser": "郭佳",
//"responserCreateTime": 1476178322000,
//"responserHeadImg": "http://121.196.223.175:89/images/default.png",
//"responserRemark": "我们在这里等你们呢、在线指导书、在于我们是否该如何选择适合自己的人和爱的人和你在哪里！我们的爱吃辣的食物、在哪里、"


@end
