//
//  PromoteAgeTableViewCell.m
//  30000day
//
//  Created by wei on 16/5/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PromoteAgeTableViewCell.h"

@implementation PromoteAgeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sleepSwitch:(UISwitch *)sender {
    
    
    
}

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";//对应xib中设置的identifier
    NSInteger index = 0; //xib中第几个Cell
    switch (indexPath.row) {
        case 0:
            identifier = @"sportsRemind";
            index = 0;
            break;
        case 1:
            identifier = @"sleep";
            index = 1;
            break;
        case 2:
            identifier = @"pm2.5";
            index = 1;
            break;
        case 3:
            identifier = @"physicalExamination";
            index = 2;
            break;
        case 4:
            identifier = @"ageDecline";
            index = 2;
            break;
            
        default:
            break;
    }
    
    PromoteAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PromoteAgeTableViewCell" owner:self options:nil] objectAtIndex:index];
    }
    return cell;
    
}

@end
