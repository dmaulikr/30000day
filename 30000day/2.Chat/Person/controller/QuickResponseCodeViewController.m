//
//  QuickResponseCodeViewController.m
//  30000day
//
//  Created by WeiGe on 16/6/27.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "QuickResponseCodeViewController.h"
#import "UIImageView+WebCache.h"

@interface QuickResponseCodeViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIView *QRCodeView;

@property (nonatomic,strong) UIImageView *customImageView;

@end

@implementation QuickResponseCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userName.text = STUserAccountHandler.userProfile.nickName;
    
    self.mainView.layer.borderWidth = 0.5f;
    
    self.mainView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.userImageView.layer.masksToBounds = YES;
    
    self.userImageView.layer.cornerRadius = 5.0f;
    
    self.mainView.layer.masksToBounds = YES;
    
    self.mainView.layer.cornerRadius = 3.0f;
    
    self.title = @"我的二维码";
    
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:STUserAccountHandler.userProfile.headImg]];
    
    CGFloat mainViewSize = [UIScreen mainScreen].bounds.size.width - 80;
    
    self.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake((mainViewSize - 250) / 2, 10, 250, 250)];
    
    // 1.创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.还原滤镜默认属性
    [filter setDefaults];
    
    // 3.设置需要生成二维码的数据到滤镜中
    // OC中要求设置的是一个二进制数据
    NSData *data = [[NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId] dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"InputMessage"];
    
    // 4.从滤镜从取出生成好的二维码图片
    CIImage *ciImage = [filter outputImage];
    
    self.customImageView.layer.shadowOffset = CGSizeMake(0, 0.5);  // 设置阴影的偏移量
    self.customImageView.layer.shadowRadius = 1;  // 设置阴影的半径
    self.customImageView.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
    self.customImageView.layer.shadowOpacity = 0.3; // 设置阴影的不透明度
    self.customImageView.image = [self createNonInterpolatedUIImageFormCIImage:ciImage size: 500];
    [self.QRCodeView addSubview:self.customImageView];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"保存图片" style:UIBarButtonItemStyleDone target:self action:@selector(keepImage)];
    [self.navigationItem setRightBarButtonItem:bar];
}

- (void)keepImage {
    
    UIImage *img = [self showWithView:self.mainView];
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (UIImage *)showWithView:(UIView *)view {
    
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (!error) {
        
        [self showToast:@"保存成功"];
        
    } else {
        
        [self showToast:@"保存失败"];
    }
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)ciImage size:(CGFloat)widthAndHeight {
    
    CGRect extentRect = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(widthAndHeight / CGRectGetWidth(extentRect), widthAndHeight / CGRectGetHeight(extentRect));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extentRect) * scale;
    size_t height = CGRectGetHeight(extentRect) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extentRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extentRect, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    //return [UIImage imageWithCGImage:scaledImage]; // 黑白图片
    UIImage *newImage = [UIImage imageWithCGImage:scaledImage];
    return [self imageBlackToTransparent:newImage withRed:0 andGreen:0 andBlue:0];
}

- (UIImage *)imageBlackToTransparent:(UIImage *)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue {
    
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

void ProviderReleaseData (void *info, const void *data, size_t size) {
    
    free((void*)data);
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
