//
//  InformationDetailWebViewController.h
//  30000day
//
//  Created by wei on 16/4/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationDetailWebViewController : STRefreshViewController

@property (weak, nonatomic) IBOutlet UIWebView *informationWebView;

@property (nonatomic,copy) NSString *infoId;

@end
