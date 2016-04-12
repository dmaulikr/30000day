//
//  InformationWebJSObject.h
//  30000day
//
//  Created by wei on 16/4/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestJSObjectProtocol <JSExport>

-(void)toAuthorPage:(NSString *)authorId;

@end

@interface InformationWebJSObject : NSObject <TestJSObjectProtocol>

@property (nonatomic,copy) NSString *writerId;

@property (nonatomic,copy) void (^(writerButtonBlock))();

@end
