//
//  STCalendarViewController.m
//  30000day
//
//  Created by GuoJia on 16/2/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STCalendarViewController.h"

@interface STCalendarViewController () <VRGCalendarViewDelegate>

@property(nonatomic,retain)VRGCalendarView *VRG_view;

@end

@implementation STCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.view addSubview:self.VRG_view];
}

- (VRGCalendarView *)VRG_view
{
    if (!_VRG_view) {
        
        _VRG_view = [[VRGCalendarView alloc] init];//目前版本修改过，原版http://code4app.com/ios/VurigCalendar/4fe81c286803fa1553000000
        
        _VRG_view.frame = CGRectMake(0, 64, SCREEN_WIDTH, 100);
        
        _VRG_view.delegate = self;
        
        UISwipeGestureRecognizer *swipDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        
        [swipDown setDirection:UISwipeGestureRecognizerDirectionDown];
        
        [_VRG_view addGestureRecognizer:swipDown];
        
        
        UISwipeGestureRecognizer *swipUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        
        [swipUp setDirection:UISwipeGestureRecognizerDirectionUp];
        
        [_VRG_view addGestureRecognizer:swipUp];
        
        [self.view addSubview:_VRG_view];
    }
    return _VRG_view;
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
       
        [_VRG_view showPreviousMonth];
    }
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        
        [_VRG_view showNextMonth];
    }

}

#pragma mark ----VRGCalendarViewDelegate

- (void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month swithchedToYear:(int)year targetHeight:(float)targetHeight animated:(BOOL)animated {
    
    
}

- (void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    
    
}

@end
