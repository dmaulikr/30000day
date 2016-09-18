
//
//  STPicturesModel.m
//  30000day
//
//  Created by GuoJia on 16/9/18.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STPicturesModel.h"

@implementation STPicturesModel

- (CGFloat)photoHeight {
    
    if (isnan(_photoHeight)) {
        return 150.0f;
    } else {
        return _photoHeight;
    }
}

- (CGFloat)photoWidth {
    
    if (isnan(_photoWidth)) {
        return 150.0f;
    } else {
        return _photoWidth;
    }
}


@end
