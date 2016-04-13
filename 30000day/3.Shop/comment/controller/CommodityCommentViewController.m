//
//  CommodityCommentViewController.m
//  30000day
//
//  Created by wei on 16/3/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CommodityCommentViewController.h"
#import "GJTextView.h"

@interface CommodityCommentViewController () <UIAlertViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet GJTextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *imageButtonOne;

@property (weak, nonatomic) IBOutlet UIButton *imageButtonTwo;

@property (weak, nonatomic) IBOutlet UIButton *imageButtonThree;

@property (strong, nonatomic) UIButton *imageCloseButtonOne;

@property (strong, nonatomic) UIButton *imageCloseButtonTwo;

@property (strong, nonatomic) UIButton *imageCloseButtonThree;

@property (nonatomic,strong) UIImage *imageOne;

@property (nonatomic,strong) UIImage *imageTwo;

@property (nonatomic,strong) UIImage *imageThree;

@property (nonatomic,assign) NSInteger clickButtonIndex;

@end

@implementation CommodityCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.clickButtonIndex = 0;
    
    self.textView.placeholder = @"合作很愉快，期待下次继续合作";
    [self.textView setBackgroundColor:[UIColor whiteColor]];
    
    self.imageCloseButtonOne = [self createImageCloseButton:1];
    self.imageCloseButtonTwo = [self createImageCloseButton:2];
    self.imageCloseButtonThree = [self createImageCloseButton:3];
    
    [self.imageButtonOne addSubview:self.imageCloseButtonOne];
    [self.imageButtonTwo addSubview:self.imageCloseButtonTwo];
    [self.imageButtonThree addSubview:self.imageCloseButtonThree];

}
- (IBAction)anonymousButtonClick:(UIButton *)sender {
    
    [sender setBackgroundColor:[UIColor blueColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choiceImage:(UIButton *)sender {
    
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
    
    self.clickButtonIndex = sender.tag;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *pickCtrl = [[UIImagePickerController alloc] init];
    //设置代理
    pickCtrl.delegate = self;
    //设置允许编辑
    pickCtrl.allowsEditing = YES;
    if (buttonIndex == 0) {//拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
            pickCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        //显示图片选择器
        [self presentViewController:pickCtrl animated:YES completion:nil];
    }else if (buttonIndex == 1){//从手机中选取照片
        pickCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //显示图片选择器
        [self presentViewController:pickCtrl animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    UIImage *originImage = info[UIImagePickerControllerOriginalImage];
    
    if (self.clickButtonIndex == 1) {
        
        [self.imageButtonOne setImage:image forState:UIControlStateNormal];
        self.imageCloseButtonOne.hidden = NO;
        self.imageOne = image;
        
        
    } else if (self.clickButtonIndex == 2) {
    
        [self.imageButtonTwo setImage:image forState:UIControlStateNormal];
        self.imageCloseButtonTwo.hidden = NO;
        self.imageTwo = image;
        
    
    } else if (self.clickButtonIndex == 3) {
    
        [self.imageButtonThree setImage:image forState:UIControlStateNormal];
        self.imageCloseButtonThree.hidden = NO;
        self.imageThree = image;
        
    
    }
    
    //保存图片到本地相册
    UIImageWriteToSavedPhotosAlbum(originImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    
    //保存headImage字段
    //[self updateImage:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = @"呵呵";
    
    if (!error) {
        
        message = @"成功保存到相册";
        
    } else {
        
        message = [error description];
    }
}

- (UIButton *)createImageCloseButton:(NSInteger)tag {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"x" forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 10.0;
    [btn setBackgroundColor:[UIColor redColor]];
    btn.tag = tag;
    [btn addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(40, 0, 20, 20)];
    btn.hidden = YES;
    return btn;

}

- (void)clickCloseButton:(UIButton *)sender {

    if (sender.tag == 1) {
        
        [self.imageButtonOne setImage:[UIImage imageNamed:@"AddGroupMemberBtn"] forState:UIControlStateNormal];
        self.imageCloseButtonOne.hidden = YES;
        self.imageOne = nil;
        
        
    } else if (sender.tag == 2) {
        
        [self.imageButtonTwo setImage:[UIImage imageNamed:@"AddGroupMemberBtn"] forState:UIControlStateNormal];
        self.imageCloseButtonTwo.hidden = YES;
        self.imageTwo = nil;
        
    } else {

        [self.imageButtonThree setImage:[UIImage imageNamed:@"AddGroupMemberBtn"] forState:UIControlStateNormal];
        self.imageCloseButtonThree.hidden = YES;
        self.imageThree = nil;
        
    }

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
