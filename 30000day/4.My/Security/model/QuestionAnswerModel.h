//
//  QuestionAnswerModel.h
//  30000day
//
//  Created by GuoJia on 16/3/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionAnswerModel : NSObject

@property (nonatomic , strong) NSNumber *questionId;//问题的编号

@property (nonatomic,copy) NSString *answerString;//问题的答案

//输入的Model里面的2个属性不能全部为空
+ (BOOL)questionAnswerModelIslegal:(QuestionAnswerModel *)model;


//当questionId和answerString都为空的时候返回YES 否则返回NO
+ (BOOL)questionAnswerMIsNull:(QuestionAnswerModel *)model;



@end
