//
//  PersonInformationTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentModel.h"
#import "GJTextView.h"

@interface PersonInformationTableViewCell : UITableViewCell

//******************************************************************************************
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;//联系人label

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;//手机号码label

@property (weak, nonatomic) IBOutlet GJTextView *remarkTextView;//备注的textView


@end
