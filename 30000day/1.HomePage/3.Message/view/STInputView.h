//
//  STInputView.h
//  30000day
//
//  Created by GuoJia on 16/3/4.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    STShowInputViewPhotosAlbum,
    
    STInputViewTypeCamera,
    
   STInputViewTypeVideo
    
}STInputViewType;

@interface STInputView : UIView

+ (instancetype)inputView;

@property (nonatomic ,copy) void (^buttonClickBlock)(STInputViewType type);

@end
