//
//  ShopAnnotation.h
//  30000day
//
//  Created by GuoJia on 16/4/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "ShopModel.h"

@interface ShopAnnotation : BMKPointAnnotation

@property (nonatomic,strong) ShopModel *model;

@end
