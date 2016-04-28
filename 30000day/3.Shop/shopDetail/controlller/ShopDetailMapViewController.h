//
//  ShopDetailMapViewController.h
//  30000day
//
//  Created by GuoJia on 16/4/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShowBackItemViewController.h"
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "ShopDetailModel.h"

@interface ShopDetailMapViewController : ShowBackItemViewController <BMKMapViewDelegate> {
    
    BMKMapView  *_mapView;
}

@property (nonatomic,strong) ShopDetailModel *detailModel;//详细模型

@end
