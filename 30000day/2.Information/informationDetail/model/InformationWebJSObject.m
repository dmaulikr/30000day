//
//  InformationWebJSObject.m
//  30000day
//
//  Created by wei on 16/4/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationWebJSObject.h"

@implementation InformationWebJSObject


-(void)toAuthorPage:(NSString *)authorId{
    NSLog(@"this is ios TestOneParameter=%@",authorId);
    
    self.writerId = authorId;
    
    self.writerButtonBlock();
}


@end
