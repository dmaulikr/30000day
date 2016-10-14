//
//  STMediumModel.h
//  30000day
//
//  Created by GuoJia on 16/7/27.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STPicturesModel;

@interface STMediumModel : NSObject

@property (nonatomic,strong)   NSString        *originalHeadImg;//头像地址
@property (nonatomic,strong)   NSString        *originalNickName;//发送者的昵称
@property (nonatomic,strong)   NSNumber        *writerId;//发送者的id
@property (nonatomic,copy)     NSString        *infoContent;//内容  如果weMediaType等于2，那么等于【title;img;url】
@property (nonatomic,strong)   NSNumber        *infoTypeId;//自媒体类型id
@property (nonatomic,copy)     NSString        *infoTypeName;//自媒体类型的titile
@property (nonatomic,strong)   NSMutableArray <STPicturesModel *>*picturesArray;//图片数组
@property (nonatomic,strong)   NSMutableArray <STPicturesModel *>*videoArray;//视频数组
@property (nonatomic,copy)     NSString        *createTime;//创建时间
@property (nonatomic,copy)     NSString        *weMediaType;//自媒体类型    0自媒体 1资讯 2借 3其他
@property (nonatomic,copy)     NSString        *infoName;//老专家给资讯的名字
@property (nonatomic,strong)   NSNumber        *mediumMessageId;//自媒体消息ID
@property (nonatomic,strong)   NSNumber        *clickLikeCount;//点赞数目
@property (nonatomic,strong)   NSNumber        *commentCount;//评论数目
@property (nonatomic,strong)   NSNumber        *forwardNum;//转载数目
@property (nonatomic,copy)     NSString        *isClickLike;//0 未点赞  1 已点赞
@property (nonatomic,strong)   NSNumber        *visibleType;//公开还是好友那里,（LeanCloud发送提醒消息用到）

+ (NSString *)meidumStringWithPicutresModelArray:(NSMutableArray *)meidumArray;
+ (NSMutableArray <STMediumModel *>*)getMediumModelArrayWithDictionaryArray:(NSArray *)jsonArray;
+ (NSInteger)getNumberOfRow:(STMediumModel *)meiumModel;
- (STMediumModel *)getOriginMediumModel;//获取原创的模型，假如该模型数据是条转发数据，那么就可以获取到
//解析字符串
+ (NSMutableArray <STPicturesModel *>*)pictureArrayWith:(NSString *)mediaJsonString;
+ (NSMutableArray <STPicturesModel *>*)videoArrayWith:(NSString *)mediaJsonString;
@end
