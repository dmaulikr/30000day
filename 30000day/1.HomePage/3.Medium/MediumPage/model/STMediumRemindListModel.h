//
//  STMediumRemindListModel.h
//  30000day
//
//  Created by GuoJia on 16/10/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STMediumRemindListModel : NSObject

@property (nonatomic,strong) NSNumber *createTime;//创建时间
@property (nonatomic,strong) NSNumber *weMediaId;//指向的自媒体的id
@property (nonatomic,strong) NSNumber *currentId;//当前的id
@property (nonatomic,copy)   NSString *isClickLike;//1：点赞，nil:表示回复或者评论
@property (nonatomic,copy)   NSString *headImg;
@property (nonatomic,copy)   NSString *mediaImage;//用来显示一张图片，微信是这么做的
@property (nonatomic,copy)   NSString *nickName;//昵称
@property (nonatomic,copy)   NSString *remark;//评论的内容
@property (nonatomic,strong) NSNumber *pId;

@end

//"busiId": 76,
//"createTime": 1472628381000,
//"headImg": "http://121.196.223.175:89/images/1000000157_1575.png",
//"id": 56,
//"isClickLike": "",
//"mediaImage": "http://ac-0t5Nyhng.clouddn.com/nbbYIICwSktiwEfksKpYNFC",
//"mediaJsonStr": "",
//"nickName": "小米米",
//"pId": 55,
//"remark": "好吧"
