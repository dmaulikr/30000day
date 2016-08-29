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
            
            [dataArray addObject:model];
            
        } else if ([dictionary[@"isShare"] isEqualToString:@"1"]) {//1转发
            
            STMediumModel *model = [[STMediumModel alloc] init];
            model.originalHeadImg = dictionary[@"shareHeadImg"];
            model.originalNickName = dictionary[@"shareNickName"];
            model.writerId = dictionary[@"shareWriterId"];
            model.infoContent = dictionary[@"shareContent"];
            model.picturesArray = [[NSMutableArray alloc] init];
            model.createTime = dictionary[@"shareCreateTime"];
            model.weMediaType = dictionary[@"weMediaType"];
            model.mediumMessageId = dictionary[@"shareId"];
            //后加的
            model.clickLikeCount = dictionary[@"clickLikeCount"];
            model.commentCount = dictionary[@"commentCount"];
            model.forwardNum = dictionary[@"forwardNum"];
            model.isClickLike = dictionary[@"isClickLike"];
            model.infoTypeId = dictionary[@"infoTypeId"];
            model.infoTypeName   = dictionary[@"infoTypeName"];
            
            STMediumModel *subModel = [[STMediumModel alloc] init];
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
            
            model.retweeted_status = subModel;
            [dataArray addObject:model];
        }
    }
    return dataArray;
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

@end

@implementation STPicturesModel

- (CGFloat)photoHeight {
    
    if (isnan(_photoHeight)) {
        return 150.0f;
    } else {
        return _photoHeight;
    }
}

- (CGFloat)photoWidth {
    
    if (isnan(_photoWidth)) {
        return 150.0f;
    } else {
        return _photoWidth;
    }
}

@end