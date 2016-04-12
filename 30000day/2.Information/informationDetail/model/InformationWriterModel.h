//
//  InformationWriterModel.h
//  30000day
//
//  Created by wei on 16/4/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationWriterModel : NSObject

@property (nonatomic,copy) NSString *headImg;
@property (nonatomic,assign) NSInteger isMineSubscribe;
@property (nonatomic,assign) NSInteger subscribeCount;
@property (nonatomic,copy) NSString *writerDescription;
@property (nonatomic,copy) NSString *writerName;
@property (nonatomic,copy) NSArray *infomationList;
@property (nonatomic,copy) NSString *writerId;

@end
