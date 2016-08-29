//
//  STSendMediumTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/7/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STSendMediumTableViewCell.h"
#import "TZImagePickerController.h"
#import "STAvatarBrowser.h"
#import "TZImageManager.h"
#import "XHPhotographyHelper.h"
#import "XHMessageVideoConverPhotoFactory.h"
#import <AVKit/AVKit.h>
#import "STChooseMediaView.h"
#import "IDMPhotoBrowser.h"

#define Margin            5
#define TextViewHeight    80
#define LabelHeight       20

@interface STSendMediumTableViewCell () <STChooseMediaViewDelegate>

/**
 *  管理本机的摄像和图片库的工具对象
 */
@property (nonatomic, strong) XHPhotographyHelper *photographyHelper;
@property (nonatomic,strong)  STChooseMediaView *mediaView_image;//添加图片
@property (nonatomic,strong)  STChooseMediaView *mediaView_video;//添加视频
@property (nonatomic,strong)  UILabel *showPhotoLabel;//显示发送图片
@property (nonatomic,strong)  UILabel *showVideoLabel;//显示发送视频
@property (nonatomic,strong) IDMPhotoBrowser *browser;//图片浏览框架

@end

@implementation STSendMediumTableViewCell

- (XHPhotographyHelper *)photographyHelper {
    if (!_photographyHelper) {
        _photographyHelper = [[XHPhotographyHelper alloc] init];
    }
    return _photographyHelper;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {

    if (!self.textView) {
        GJTextView *textView = [[GJTextView alloc] init];
        textView.placeholder  = @"这一刻的想法...";
        [self.contentView addSubview:textView];
        self.textView = textView;
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = YES;
        textView.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
        textView.layer.borderWidth = 0.7f;
        textView.font = [UIFont systemFontOfSize:15.0f];
    }
    
    if (!self.showPhotoLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"选择图片(可选3张)";
        [self.contentView addSubview:label];
        self.showPhotoLabel = label;
    }
    
    if (!self.showVideoLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"选择视频(只能选1部)";
        [self.contentView addSubview:label];
        self.showVideoLabel = label;
    }

    if (!self.mediaView_image) {
        self.mediaView_image = [[STChooseMediaView alloc] init];
        self.mediaView_image.delegate = self;
        [self.contentView addSubview:self.mediaView_image];
    }
    
    if (!self.mediaView_video) {
        self.mediaView_video = [[STChooseMediaView alloc] init];
        self.mediaView_video.delegate = self;
        self.mediaView_video.maxRowChooseMediaNum = 1;
        self.mediaView_video.maxChooseMediaNum = 1;
        [self.contentView addSubview:self.mediaView_video];
    }
    
    self.imageArray = [[NSMutableArray alloc] init];
    self.videoArray = [[NSMutableArray alloc] init];
    [STNotificationCenter addObserver:self selector:@selector(contentChange) name:UITextViewTextDidChangeNotification object:nil];
    [self setNeedsLayout];
}

- (void)contentChange {
    if ([self.delegate respondsToSelector:@selector(sendMediumContentChange:changedContext:)]) {
        [self.delegate sendMediumContentChange:self changedContext:self.textView.text];
    }
}

- (void)reloadData {
    [self setNeedsLayout];
}

- (void)cleanData {
    self.textView.text = nil;
    [self.imageArray removeAllObjects];
    [self.videoArray removeAllObjects];
    [self resetImageMediaView];
    [self resetVideoMediaView];
}

- (void)sendVideoMessageToMedium {
    
    UIAlertController *alertControlller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action_first = [UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.photographyHelper showPickerViewControllerSourceType:UIImagePickerControllerSourceTypeCamera mediaType:@[(NSString *) kUTTypeMovie] controller:self.delegate compled:^(UIImage *image, NSDictionary *editingInfo) {
            
            if (editingInfo) {
                
                NSURL *videoURL = (NSURL *)[editingInfo objectForKey:UIImagePickerControllerMediaURL];
                UIImage *thumbnailImage = [XHMessageVideoConverPhotoFactory videoConverPhotoWithVideoPath:[videoURL path]];
                
                STChooseMediaModel *model = [[STChooseMediaModel alloc] init];
                model.mediaType = STChooseMediaVideoType;
                model.coverImage = thumbnailImage;
                model.videoURLString = [videoURL path];
                [self.videoArray addObject:model];
                [self resetVideoMediaView];
            }
        }];
    }];
    
    UIAlertAction *action_second = [UIAlertAction actionWithTitle:@"选取视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:nil];
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.allowPickingVideo = YES;
        imagePickerVc.allowPickingImage = NO;
        
        [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                STBaseViewController *viewController = (STBaseViewController *)self.delegate;
                [viewController showHUDWithContent:@"正在处理" animated:YES];
                
                [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        STChooseMediaModel *model = [[STChooseMediaModel alloc] init];
                        model.mediaType = STChooseMediaVideoType;
                        model.coverImage = coverImage;
                        model.videoURLString = outputPath;
                        [self.videoArray addObject:model];
                        [self resetVideoMediaView];
                        [viewController hideHUD:YES];
                    });
                }];
            });
        }];
        [self.delegate presentViewController:imagePickerVc animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertControlller addAction:action_first];
    [alertControlller addAction:action_second];
    [alertControlller addAction:cancelAction];
    [self.delegate presentViewController:alertControlller animated:YES completion:nil];
}

- (void)sendPhotoMessageToMedium {
    
    UIAlertController *alertControlller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action_first = [UIAlertAction actionWithTitle:@"拍一张" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.photographyHelper showPickerViewControllerSourceType:UIImagePickerControllerSourceTypeCamera mediaType:@[(NSString *) kUTTypeImage] controller:self.delegate compled:^(UIImage *image, NSDictionary *editingInfo) {
           
            if (editingInfo) {
                
                STChooseMediaModel *model = [[STChooseMediaModel alloc] init];
                model.mediaType = STChooseMediaPhotoType;
                model.coverImage = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
                [self.imageArray addObject:model];
                [self resetImageMediaView];
            }
        }];
    }];
    
    UIAlertAction *action_second = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 delegate:nil];
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.maxImagesCount = 3 - _imageArray.count;
        
        //选择图片
        [imagePickerVc setDidFinishPickingPhotosWithInfosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray<NSDictionary *> *infos) {
            
            if (isSelectOriginalPhoto) {
                
                NSMutableArray *mediaModelArray = [[NSMutableArray alloc] init];
                for (int i = 0; i < assets.count; i++) {
                    
                    [[TZImageManager manager] getOriginalPhotoWithAsset:assets[i] completion:^(UIImage *photo, NSDictionary *info) {//再次进行异步操作
                        
                        STChooseMediaModel *model = [[STChooseMediaModel alloc] init];
                        model.mediaType = STChooseMediaPhotoType;
                        model.coverImage = photo;
                        [mediaModelArray addObject:model];
                        
                        if (mediaModelArray.count == assets.count) {
                            
                            [self.imageArray addObjectsFromArray:mediaModelArray];
                            [self resetImageMediaView];
                        }
                    }];
                }

            } else {
                
                NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                for (int i = 0; i < photos.count; i++) {
                    STChooseMediaModel *model = [[STChooseMediaModel alloc] init];
                    model.mediaType = STChooseMediaPhotoType;
                    model.coverImage = photos[i];
                    [dataArray addObject:model];
                }
                [self.imageArray addObjectsFromArray:dataArray];
                [self resetImageMediaView];
            }
        }];
        
        [self.delegate presentViewController:imagePickerVc animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertControlller addAction:action_first];
    [alertControlller addAction:action_second];
    [alertControlller addAction:cancelAction];
    [self.delegate presentViewController:alertControlller animated:YES completion:nil];
}

- (void)resetImageMediaView {

    [self.mediaView_image reloadMediaViewWithModelArray:self.imageArray];
    [self setNeedsLayout];
    
    if ([self.delegate respondsToSelector:@selector(sendMediumChooseMediaChange:)]) {
        [self.delegate sendMediumChooseMediaChange:self];
    }
}

- (void)resetVideoMediaView {
    [self.mediaView_video reloadMediaViewWithModelArray:self.videoArray];
    [self setNeedsLayout];
    
    if ([self.delegate respondsToSelector:@selector(sendMediumChooseMediaChange:)]) {
        [self.delegate sendMediumChooseMediaChange:self];
    }
}

+ (CGFloat)heightSendMediumCell:(NSMutableArray <STChooseMediaModel *>*)imageArray videoArray:(NSMutableArray <STChooseMediaModel *>*)videoArray {
    return Margin + TextViewHeight + Margin + LabelHeight + Margin  +  [STChooseMediaView mediaViewHeight:videoArray mediaViewWidth:(SCREEN_WIDTH - 2 * Margin + 20) / 3.0f maxChooseMediaNum:1 maxRowChooseMediaNum:1] + Margin + LabelHeight + Margin + [STChooseMediaView mediaViewHeight:imageArray mediaViewWidth:SCREEN_WIDTH - 2 * Margin maxChooseMediaNum:3 maxRowChooseMediaNum:3] + Margin;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = CGRectMake(Margin * 3, Margin, SCREEN_WIDTH - 6 * Margin, TextViewHeight);
    
    self.showVideoLabel.frame = CGRectMake(Margin * 3, CGRectGetMaxY(self.textView.frame) + Margin, 150, LabelHeight);
    self.mediaView_video.frame = CGRectMake(Margin,CGRectGetMaxY(self.showVideoLabel.frame) + Margin,(self.width - 2 * Margin + 20) / 3.0f,[STChooseMediaView mediaViewHeight:self.videoArray mediaViewWidth:(self.width - 2 * Margin + 20) / 3.0f maxChooseMediaNum:1 maxRowChooseMediaNum:1]);
    
    self.showPhotoLabel.frame = CGRectMake(Margin * 3, CGRectGetMaxY(self.mediaView_video.frame) + Margin, 150, LabelHeight);
    self.mediaView_image.frame = CGRectMake(Margin,CGRectGetMaxY(self.showPhotoLabel.frame) + Margin,self.width - 2 * Margin,[STChooseMediaView mediaViewHeight:self.imageArray mediaViewWidth:SCREEN_WIDTH - 2 * Margin maxChooseMediaNum:3 maxRowChooseMediaNum:3]);
}

#pragma ---
#pragma mark --- STChooseMediaViewDelegate

- (void)chooseMediaView:(STChooseMediaView *)mediaView addActionIndex:(NSInteger)index {//点击
    
    if (mediaView == self.mediaView_image) {
        [self sendPhotoMessageToMedium];
    } else {
        [self sendVideoMessageToMedium];
    }
}

//点击index对应的cancelbutton
- (void)chooseMediaView:(STChooseMediaView *)mediaView didTapCancelButtonWithIndex:(NSInteger)index {
    
    if (mediaView == self.mediaView_image) {
        
        if (index < self.imageArray.count) {
            [self.imageArray removeObjectAtIndex:index];
            [self resetImageMediaView];
        }
        
    } else {
        
        if (index < self.videoArray.count) {
            [self.videoArray removeObjectAtIndex:index];
            [self resetVideoMediaView];
        }
    }
}

- (void)chooseMediaView:(STChooseMediaView *)mediaView didSelectWithIndex:(NSInteger)index {

    if (mediaView == self.mediaView_image) {
        
        STChooseMediaModel *model = self.imageArray[index];
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithIDMPhotoArray:[self getIDMPhotoArray]];
        browser.forceHideStatusBar = YES;
        browser.displayDoneButton = NO;
        browser.displayToolbar = YES;
        browser.autoHideInterface = false;
        browser.displayActionButton = NO;
        browser.displayArrowButton = YES;
        browser.displayCounterLabel = YES;
        browser.animationDuration = 1.0f;
        browser.disableVerticalSwipe = YES;
        browser.usePopAnimation = YES;
        [browser setInitialPageIndex:[self indexOfPhotoWithChooseMediaModel:model]];
//        browser.delegate = self;为了保存
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [browser.view addGestureRecognizer:tap];
        
        [self.delegate presentViewController:browser animated:YES completion:nil];
        self.browser = browser;
        
    } else {
        
        STChooseMediaModel *model = self.videoArray[index];
        AVPlayerViewController *controller = [[AVPlayerViewController alloc]  init];
        AVPlayerItem *item =  [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:model.videoURLString]];//改到这
        AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
        controller.player = player;
        [player play];
        [self.delegate presentViewController:controller animated:YES completion:nil];
    }
}

- (void)tapAction {
    [self.browser dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)getIDMPhotoArray {
    
    NSMutableArray *photoModelArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.imageArray.count;i++) {
        STChooseMediaModel *mediaModel = self.imageArray[i];
        IDMPhoto *photo = [IDMPhoto photoWithImage:mediaModel.coverImage];
        [photoModelArray addObject:photo];
    }
    return photoModelArray;
}

- (NSInteger)indexOfPhotoWithChooseMediaModel:(STChooseMediaModel *)mediaModel {
    
    int index = 0;
    for (int i = 0; i < self.imageArray.count; i++) {//目前只是以远程的URL来区分
        
        STChooseMediaModel *model = self.imageArray[i];
        if (mediaModel == model) {
            index = i;
        }
    }
    return index;
}

@end
