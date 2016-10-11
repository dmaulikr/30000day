//
//  STMediumModel.m
//  30000day
//
//  Created by GuoJia on 16/7/27.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumModel.h"
#import "SBJson.h"
#import "MJExtension.h"
#import "STPicturesModel.h"

@interface STMediumModel ()
@property (nonatomic,strong) STMediumModel  *retweeted_status;//被转发的原微博信息字段，当该微博为转发微博时返回STMediumModel模型
@end

@implementation STMediumModel

+ (NSMutableArray <STMediumModel *>*)getMediumModelArrayWithDictionaryArray:(NSArray *)jsonArray {
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <jsonArray.count; i++) {
        
        NSDictionary *dictionary = jsonArray[i];
        if ([dictionary[@"isShare"] isEqualToString:@"0"]) {//0原创
            
            //设置模型
            STMediumModel *model = [[STMediumModel alloc] init];
            model.originalHeadImg = dictionary[@"writerHeadImg"];
            model.originalNickName = dictionary[@"writerNickName"];
            model.writerId = dictionary[@"writerId"];
            model.infoContent = dictionary[@"infoContent"];
            model.picturesArray = [STMediumModel pictureArrayWith:dictionary[@"mediaJsonStr"]];
            model.videoArray = [STMediumModel videoArrayWith:dictionary[@"mediaJsonStr"]];
            model.createTime = dictionary[@"createTime"];
            model.weMediaType = dictionary[@"weMediaType"];
            model.infoName = dictionary[@"infoName"];
            model.mediumMessageId = dictionary[@"id"];
            model.retweeted_status = nil;
            
            //后加的
            model.clickLikeCount = dictionary[@"clickLikeCount"];
            model.commentCount = dictionary[@"commentCount"];
            model.forwardNum = dictionary[@"forwardNum"];
            model.isClickLike = dictionary[@"isClickLike"];
            model.infoTypeId = dictionary[@"infoTypeId"];
            model.infoTypeName   = dictionary[@"infoTypeName"];
            //设置数据
            [STMediumModel getModelWeMediaType:dictionary[@"weMediaType"] infoContent:dictionary[@"infoContent"] model:model];
            
            [dataArray addObject:model];
            
        } else if ([dictionary[@"isShare"] isEqualToString:@"1"]) {//1转发
            
            STMediumModel *model = [[STMediumModel alloc] init];//自媒体
            model.originalHeadImg = dictionary[@"shareHeadImg"];
            model.originalNickName = dictionary[@"shareNickName"];
            model.writerId = dictionary[@"shareWriterId"];
            model.infoContent = dictionary[@"shareContent"];
            model.picturesArray = [[NSMutableArray alloc] init];
            model.createTime = dictionary[@"shareCreateTime"];
            model.weMediaType = @"0";//自己改成0,转发的
            model.mediumMessageId = dictionary[@"shareId"];
            //后加的
            model.clickLikeCount = dictionary[@"clickLikeCount"];
            model.commentCount = dictionary[@"commentCount"];
            model.forwardNum = dictionary[@"forwardNum"];
            model.isClickLike = dictionary[@"isClickLike"];
            model.infoTypeId = dictionary[@"infoTypeId"];
            model.infoTypeName   = dictionary[@"infoTypeName"];
            
            STMediumModel *subModel = [[STMediumModel alloc] init];//被转发的自媒体
            subModel.originalHeadImg = dictionary[@"writerHeadImg"];
            subModel.originalNickName = dictionary[@"writerNickName"];
            subModel.writerId = dictionary[@"writerId"];
            subModel.infoContent = dictionary[@"infoContent"];
            subModel.picturesArray = [STMediumModel pictureArrayWith:dictionary[@"mediaJsonStr"]];
            subModel.videoArray = [STMediumModel videoArrayWith:dictionary[@"mediaJsonStr"]];
            subModel.createTime = dictionary[@"createTime"];
            subModel.weMediaType = dictionary[@"weMediaType"];
            subModel.mediumMessageId = dictionary[@"id"];
            subModel.infoName = dictionary[@"infoName"];
            subModel.retweeted_status = nil;
            
            //后加的
            subModel.clickLikeCount = dictionary[@"clickLikeCount"];
            subModel.commentCount = dictionary[@"commentCount"];
            subModel.forwardNum = dictionary[@"forwardNum"];
            subModel.isClickLike = dictionary[@"isClickLike"];
            subModel.infoTypeId = dictionary[@"infoTypeId"];
            subModel.infoTypeName   = dictionary[@"infoTypeName"];
            
            //设置数据
            [STMediumModel getModelWeMediaType:dictionary[@"weMediaType"] infoContent:dictionary[@"infoContent"] model:subModel];
            
            model.retweeted_status = subModel;
            [dataArray addObject:model];
        }
    }
    return dataArray;
}

+ (void)getModelWeMediaType:(NSString *)weMediaType infoContent:(NSString *)infoContent model:(STMediumModel *)mediumModel {
    if ([weMediaType isEqualToString:@"2"]) {//表示是特殊的链接类型，需要特殊处理
#warning 这里需要配合服务器进行修改-- ；；；
        NSArray *array = [infoContent componentsSeparatedByString:@";"];
        if (array.count == 3) {
            
            NSString *string = array[1];
            NSError *error;
            NSString *regulaStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
            NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
            
            if (arrayOfAllMatches.count) {
                
                NSTextCheckingResult *match = arrayOfAllMatches[0];
                NSString *substringForMatch = [string substringWithRange:match.range];
                if ([Common isObjectNull:substringForMatch]) {//空了
                    mediumModel.weMediaType = @"2";
                    mediumModel.infoContent = [NSString stringWithFormat:@"%@;;%@",[Common isObjectNull:array[0]] ? @"网页链接":array[0],array[2]];
                } else {//有图片
                    mediumModel.infoContent = [NSString stringWithFormat:@"%@;%@;%@",[Common isObjectNull:array[0]] ? @"网页链接":array[0],substringForMatch,array[2]];
                    mediumModel.weMediaType = @"2";
                }
            } else {
                mediumModel.weMediaType = @"2";
                mediumModel.infoContent = [NSString stringWithFormat:@"%@;;%@",[Common isObjectNull:array[0]] ? @"网页链接":array[0],array[2]];
            }
        } else {//服务器解析链接问题，这时候需要特殊处理
            mediumModel.weMediaType = @"2";
            mediumModel.infoContent = [NSString stringWithFormat:@"网页链接;;%@",[array lastObject]];
        }
    }
}


+ (NSString *)meidumStringWithPicutresModelArray:(NSMutableArray *)meidumArray {
    
    NSMutableArray *photoArray = [[NSMutableArray alloc] init];
    NSMutableArray *videoArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < meidumArray.count; i++) {
        
        STPicturesModel *model = meidumArray[i];
        if (model.mediaType == 0) {//图片
            
            NSMutableDictionary *ditionary = [[NSMutableDictionary alloc] init];
            [ditionary addParameter:model.mediaURLString forKey:@"originPhotoURLString"];
            [ditionary addParameter:model.thumbnailCoverPhotoURLString forKey:@"thumbnailPhotoURLString"];
            [ditionary addParameter:[NSString stringWithFormat:@"%f",model.photoWidth] forKey:@"photoWidth"];
            [ditionary addParameter:[NSString stringWithFormat:@"%f",model.photoHeight] forKey:@"photoHeight"];
            [photoArray addObject:ditionary];
            
        } else if (model.mediaType == 1) {//视频
            
            NSMutableDictionary *ditionary = [[NSMutableDictionary alloc] init];
            [ditionary addParameter:model.mediaURLString forKey:@"videoURLString"];
            [ditionary addParameter:model.thumbnailCoverPhotoURLString forKey:@"thumbnailPhotoURLString"];
            [ditionary addParameter:[NSString stringWithFormat:@"%f",model.photoWidth] forKey:@"photoWidth"];
            [ditionary addParameter:[NSString stringWithFormat:@"%f",model.photoHeight] forKey:@"photoHeight"];
            [videoArray addObject:ditionary];
        }
    }

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if (photoArray.count > 0) {
        [dictionary addParameter:photoArray forKey:@"photoBody"];
    }
    if (videoArray.count > 0 ) {
        [dictionary addParameter:videoArray forKey:@"videoBody"];
    }
    return [dictionary mj_JSONString];
}

+ (NSMutableArray *)pictureArrayWith:(NSString *)mediaJsonString {
    
    if ([Common isObjectNull:mediaJsonString]) {
        
        return [[NSMutableArray alloc] init];
        
    } else {
        
        NSDictionary *dictionary = [mediaJsonString mj_JSONObject];
        
        if (!dictionary) {//解析有问题
            return [[NSMutableArray alloc] init];
        } else {
            
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            //图片
            if ([dictionary objectForKey:@"photoBody"]) {
                
                NSArray *subArray = [dictionary objectForKey:@"photoBody"];
                for (int i = 0; i < subArray.count; i++) {
                    NSDictionary *subDitionary = subArray[i];
                    STPicturesModel *pictureModel = [[STPicturesModel alloc] init];
                    pictureModel.mediaType = 0;
                    pictureModel.mediaURLString = [subDitionary objectForKey:@"originPhotoURLString"];
                    pictureModel.thumbnailCoverPhotoURLString = [subDitionary objectForKey:@"thumbnailPhotoURLString"];
                    pictureModel.photoWidth = [[subDitionary objectForKey:@"photoWidth"] floatValue];
                    pictureModel.photoHeight = [[subDitionary objectForKey:@"photoHeight"] floatValue];
                    
                    [dataArray addObject:pictureModel];
                }
            }
            return dataArray;
        }
    }
}

+ (NSMutableArray *)videoArrayWith:(NSString *)mediaJsonString {
    
    if ([Common isObjectNull:mediaJsonString]) {
        
        return [[NSMutableArray alloc] init];
        
    } else {
        
        NSDictionary *dictionary = [mediaJsonString mj_JSONObject];
        
        if (!dictionary) {//解析有问题
            return [[NSMutableArray alloc] init];
        } else {
            
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            //视频
            if ([dictionary objectForKey:@"videoBody"]) {
                
                NSArray *subArray = [dictionary objectForKey:@"videoBody"];
                for (int i = 0; i < subArray.count; i++) {
                    NSDictionary *subDitionary = subArray[i];
                    STPicturesModel *pictureModel = [[STPicturesModel alloc] init];
                    pictureModel.mediaType = 1;
                    pictureModel.mediaURLString = [subDitionary objectForKey:@"videoURLString"];
                    pictureModel.thumbnailCoverPhotoURLString = [subDitionary objectForKey:@"thumbnailPhotoURLString"];
                    pictureModel.photoWidth = [[subDitionary objectForKey:@"photoWidth"] floatValue];
                    pictureModel.photoHeight = [[subDitionary objectForKey:@"photoHeight"] floatValue];
                    
                    [dataArray addObject:pictureModel];
                }
            }
            return dataArray;
        }
    }
}

+ (NSInteger)getNumberOfRow:(STMediumModel *)meiumModel {
    
    if (meiumModel.retweeted_status) {//表示是转发的
        return 3;
    } else {//表示是原创的
        return 2;
    }
}

- (NSString *)infoContent {
    
    if ([Common isObjectNull:_infoContent]) {
        return @"";
    }else {
        return _infoContent;
    }
}

- (NSString *)infoName {
    
    if ([Common isObjectNull:_infoName]) {
        return @"";
    } else {
        return _infoName;
    }
}

- (NSString *)originalNickName {
    if ([Common isObjectNull:_originalNickName]) {
        return @"";
    } else {
        return _originalNickName;
    }
}

- (NSString *)originalHeadImg {
    if ([Common isObjectNull:_originalHeadImg]) {
        return @"";
    } else {
        return _originalHeadImg;
    }
}

- (STMediumModel *)getOriginMediumModel {
    if (self.retweeted_status) {
        return self.retweeted_status;
    } else {
        return self;
    }
}

@end
