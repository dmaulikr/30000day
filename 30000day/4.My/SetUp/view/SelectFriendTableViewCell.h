//
//  SelectFriendTableViewCell.h
//  30000day
//
//  Created by WeiGe on 16/8/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInformationModel.h"

@interface SelectFriendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

@property (nonatomic,strong) UserInformationModel *informationModel;

@property (nonatomic,assign) BOOL isSelect;

@end
