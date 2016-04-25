//
//  CommodityCommentViewController.m
//  30000day
//
//  Created by wei on 16/3/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CommodityCommentViewController.h"
#import "GJTextView.h"
#import "ZLPhotoActionSheet.h"
#import "DYRateView.h"
#import "MTProgressHUD.h"

@interface CommodityCommentViewController () <UIAlertViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,DYRateViewDelegate>
{
    ZLPhotoActionSheet *actionSheet;
}

@property (weak, nonatomic) IBOutlet GJTextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *insertImageButton;

@property (weak, nonatomic) IBOutlet UIView *baseView;

@property (weak, nonatomic) IBOutlet UIButton *deleteImageButton;

@property (weak, nonatomic) IBOutlet UIButton *submit;

@property (weak, nonatomic) IBOutlet DYRateView *rateView;

@property (weak, nonatomic) IBOutlet UIButton *isHideButton;

@property (nonatomic,assign) NSInteger rate; //星星数量

@property (nonatomic,strong) NSMutableArray *imageArray;

@end

@implementation CommodityCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rateView.editable = YES;
    [self.rateView setDelegate:self];
    self.textView.placeholder = @"合作很愉快，期待下次继续合作";
    [self.textView setBackgroundColor:[UIColor whiteColor]];
    self.submit.layer.cornerRadius = 6;
    self.submit.layer.masksToBounds = YES;
    [self.submit addTarget:self action:@selector(subMitClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rateView.rate = 1;
    
    self.rate =  1;
    
    // Do any additional setup after loading the view, typically from a nib.
    actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 3;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 20;

}

- (IBAction)choiceImage:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    [actionSheet showWithSender:self animate:YES completion:^(NSArray<UIImage *> * _Nonnull selectPhotos) {
        
        [weakSelf.baseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        weakSelf.imageArray = [NSMutableArray arrayWithArray:selectPhotos];
        weakSelf.deleteImageButton.hidden = NO;
        
        CGFloat width = 60;
        for (int i = 0; i < selectPhotos.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i%3*(width+5), 0 , width, 60)];
            [imgView setBackgroundColor:[UIColor redColor]];
            imgView.image = [self imageCompressForSize:selectPhotos[i] targetSize:CGSizeMake(width, 60)];
            [weakSelf.baseView addSubview:imgView];
        }
        
    }];
}

-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}


- (IBAction)anonymousButtonClick:(UIButton *)sender {
    
    if (sender.tag) {
        
        [sender setBackgroundColor:[UIColor whiteColor]];
        
        sender.tag = 0;
        
    } else {
    
        [sender setBackgroundColor:[UIColor colorWithRed:66.0/255.0 green:147.0/255.0 blue:255/255.0 alpha:1.0]];
        
        sender.tag = 1;
    
    }
}

- (IBAction)deleteImage:(UIButton *)sender {
    
    [self.baseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    sender.hidden = YES;
    
}

- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate {

    self.rate = rate.integerValue;
    
}

- (void)subMitClick:(UIButton *)sender {

    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [self.dataHandler sendUploadImagesWithUserId:STUserAccountHandler.userProfile.userId.integerValue type:1 imageArray:self.imageArray success:^(NSString *success) {
        
        NSString * encodingString = [success stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.dataHandler sendSaveCommentWithBusiId:self.productId.integerValue busiType:0 userId:STUserAccountHandler.userProfile.userId.integerValue remark:self.textView.text pid:-1 isHideName:self.isHideButton.tag numberStar:self.rate commentPhotos:encodingString success:^(BOOL success) {
            
            if (success) {
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                [self showToast:@"评论成功"];
                
            }
            
        } failure:^(NSError *error) {
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            [self showToast:@"评论失败"];
            
        }];
        
        
    } failure:^(NSError *error) {
    
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        NSLog(@"%@",error.userInfo[@"NSLocalizedDescription"]);
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
