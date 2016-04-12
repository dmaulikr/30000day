//
//  ShopTableViewController.h
//  30000day
//
//  Created by GuoJia on 16/1/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface ShopViewController : STRefreshViewController <BMKMapViewDelegate> {
    BMKMapView  *_mapView;
}

@end
