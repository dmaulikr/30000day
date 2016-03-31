//
//  STChoosePictureCollectionCell.m
//  30000day
//
//  Created by GuoJia on 16/3/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STChoosePictureCollectionCell.h"

@implementation STChoosePictureCollectionCell

- (void)awakeFromNib {
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
}

- (IBAction)buttonAction:(id)sender {
    
    if (self.buttonClickBlock) {
        
        self.buttonClickBlock(self.indexPath);
    }
}

@end
