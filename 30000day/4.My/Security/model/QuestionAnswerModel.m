//
//  QuestionAnswerModel.m
//  30000day
//
//  Created by GuoJia on 16/3/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "QuestionAnswerModel.h"

@implementation QuestionAnswerModel

+ (BOOL)questionAnswerModelIslegal:(QuestionAnswerModel *)model {

    if (![Common isObjectNull:model.questionId] && ![Common isObjectNull:model.answerString]) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}

+ (BOOL)questionAnswerMIsNull:(QuestionAnswerModel *)model {
    
    if ([Common isObjectNull:model.questionId] && [Common isObjectNull:model.answerString]) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}

@end
