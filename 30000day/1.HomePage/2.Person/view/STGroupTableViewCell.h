//
//  STGroupTableViewCell.h
//  dream
//
//  Created by WeiGe on 16/6/16.
//  Copyright © 2016年 WeiGe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STGroupTableViewCell : UITableViewCell

//@property (nonatomic,copy) NSMutableArray *memberMutableArray;

@property (nonatomic,assign) BOOL isMainGroup;

//点击控件的tag，后面表示是否有群主
@property (nonatomic,copy) void (^(memberButtonBlock))(NSInteger tag,BOOL isAdmin);

+ (CGFloat)groupTableViewCellHeight:(NSMutableArray *)memberMutableArray;

- (void)configGroupTableViewCellWith:(NSMutableArray *)memberMutableArray;

@end

@interface STGroupCellModel : NSObject

@property (nonatomic,copy) NSString *imageViewURL;//将要显示

@property (nonatomic,copy) NSString *title;//名称

@end