//
//  MapShowTitleAnnotationView.h
//  30000day
//
//  Created by GuoJia on 16/4/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface MapShowTitleAnnotationView : BMKAnnotationView

@property (nonatomic, copy) NSString  *title;

@property (nonatomic, assign) CGSize  size;

+ (CGSize)titleSize:(NSString *)title;

@end
