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

@interface CommodityCommentViewController () <UIAlertViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    ZLPhotoActionSheet *actionSheet;
}

@property (weak, nonatomic) IBOutlet GJTextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *insertImageButton;

@property (weak, nonatomic) IBOutlet UIView *baseView;

@property (weak, nonatomic) IBOutlet UIButton *deleteImageButton;

@property (weak, nonatomic) IBOutlet UIButton *submit;


@property (nonatomic,strong) NSMutableArray *imageArray;

@end

@implementation CommodityCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.placeholder = @"合作很愉快，期待下次继续合作";
    [self.textView setBackgroundColor:[UIColor whiteColor]];
    self.submit.layer.cornerRadius = 6;
    self.submit.layer.masksToBounds = YES;
    
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
        
        CGFloat width = 90;
        for (int i = 0; i < selectPhotos.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i%3*(width+5), 0 , width, width)];
            [imgView setBackgroundColor:[UIColor redColor]];
            imgView.image = selectPhotos[i];
            [weakSelf.baseView addSubview:imgView];
        }
    }];
    
    
}

- (IBAction)anonymousButtonClick:(UIButton *)sender {
    
    [sender setBackgroundColor:[UIColor blueColor]];
        
    
}

- (IBAction)deleteImage:(UIButton *)sender {
    
    [self.baseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    sender.hidden = YES;
    
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
