//
//  userInfoViewController.m
//  30000天
//
//  Created by wei on 16/1/19.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "HZAreaPickerView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ZYQAssetPickerController.h"
#import "ZHPickView.h"
#import "HeadViewTableViewCell.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface UserInfoViewController () <UINavigationControllerDelegate,ZHPickViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)UserProfile *userProfile;

@property (nonatomic,strong)NSArray *titleArray;

@property (nonatomic,strong)ZHPickView *zpk;

@property (nonatomic,strong) UIImageView *portraitImageView;

@property (nonatomic,strong) UIImage * editorImage;

@property (nonatomic,copy) NSString *NickName;

@property (nonatomic,copy) NSString *Gender;

@property (nonatomic,copy) NSString *Birthday;

@property (nonatomic ,strong) UIBarButtonItem *saveButton;

@property (nonatomic ,strong) UIImage *copareImage;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"个人信息";
    
    self.saveButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonClick)];
    
    self.saveButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    [self.mainTable setDelegate:self];
    
    [self.mainTable setDataSource:self];
    
    _userProfile = [UserAccountHandler shareUserAccountHandler].userProfile;
    
    self.NickName = _userProfile.NickName;
    
    self.Gender = _userProfile.Gender;
    
    self.Birthday= _userProfile.Birthday;

    _titleArray = [NSArray arrayWithObjects:@"头像",@"昵称",@"性别",@"生日",nil];
    
}

- (void)saveButtonClick {

    [self showHUDWithContent:@"正在保存" animated:YES];
    
    //上传服务器
    [self.dataHandler postUpdateProfileWithUserID:_userProfile.UserID Password:_userProfile.LoginPassword loginName:_userProfile.LoginName NickName:_userProfile.NickName Gender:_userProfile.Gender Birthday:_userProfile.Birthday success:^(BOOL responseObject) {
        
        if (responseObject) {
            
            if (![self.editorImage isEqual:self.copareImage]) {
            
                [self shangchuantupian:self.editorImage];
                
            } else {
                
                [self hideHUD:YES];
                
                [self showToast:@"个人信息保存成功"];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        
    } failure:^(NSError *error) {
        
        [self hideHUD:YES];
        
        [self showToast:@"个人信息保存失败"];
    }];
    
    // 保存生日到本地文件，用于其他地方提取计算数值
    [[NSUserDefaults standardUserDefaults] setObject:[_userProfile.Birthday stringByAppendingString:@" 00:00:00"] forKey:@"UserBirthday"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma ---
#pragma mark --- UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 4;
        
    } else {
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 10;
    }
    
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return 105;
            
        } else {
            
            return 43;
        }
        
    } else {
        
        return 43;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 ) {
        
        if (indexPath.row == 0 ) {
            
            HeadViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadViewTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"HeadViewTableViewCell" owner:self options:nil] lastObject];
                
            }
            
            cell.headImageViewURLString = _userProfile.HeadImg;
            
            //给这连个判断条件赋值
            self.portraitImageView = cell.headImageView;

            self.editorImage = self.portraitImageView.image;
            
            self.copareImage = self.portraitImageView.image;
            
            return cell;
            
        } else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            
            if ( cell == nil ) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.textLabel.textColor = [UIColor blackColor];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
                
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                
                cell.detailTextLabel.textColor = RGBACOLOR(130, 130, 130, 1);
                
            }
            
            if ( indexPath.row == 1) {
                
                cell.detailTextLabel.text = _userProfile.NickName;
                
                cell.textLabel.text = @"昵称";
            
            } else if ( indexPath.row == 2) {
                
                cell.detailTextLabel.text = [_userProfile.Gender isEqualToString:@"1"] ? @"男" : @"女";
                
                cell.textLabel.text = @"性别";
                
            } else if ( indexPath.row == 3) {
                
                cell.detailTextLabel.text=_userProfile.Birthday;
                
                cell.textLabel.text = @"生日";
            }
            
            return cell;
            
        }
        
    } else if (indexPath.section == 1) {
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
        
        if ( cell == nil ) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TableViewCell"];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.textLabel.textColor = [UIColor blackColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
            
            cell.detailTextLabel.textColor = RGBACOLOR(130, 130, 130, 1);
            
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        
            cell.textLabel.text = @"账号";
    
            cell.detailTextLabel.text = _userProfile.LoginName;
        
        return cell;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 43)];
    
    [view setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    
    return view;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            [self editPortrait];
            
        }else if(indexPath.row == 1){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_userProfile.NickName message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            UITextField *textfile = [alert textFieldAtIndex:0];
            
            [textfile setText:_userProfile.NickName];
            
            [alert show];
            
        } else if(indexPath.row == 2) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择性别"message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女", nil];
            
            [alertView show];
            
        } else if(indexPath.row == 3) {
            
            NSString *currentDate = [UserAccountHandler shareUserAccountHandler].userProfile.Birthday;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy/MM/dd"];
            
            _zpk = [[ZHPickView alloc] initDatePickWithDate:[formatter dateFromString:currentDate] datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
            
            _zpk.delegate = self;
            
            [_zpk setMaxMinYer];
            
            [_zpk show];
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSIndexPath *indexpath = self.mainTable.indexPathForSelectedRow;

    if ( indexpath.section == 0 && buttonIndex != 0 ) {
        
        if (indexpath.row == 1 ) {
            
            UITextField *textfile = [alertView textFieldAtIndex:0];
            
            _userProfile.NickName = textfile.text;
        }
        if (indexpath.row == 2 ) {
            
            if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"男"]) {
                
                _userProfile.Gender = @"1";
                
            } else {
                
                _userProfile.Gender = @"0";
                
            }
        }

        [self.mainTable reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationLeft];
        //判断按钮是否可用
        [self judgeSaveButtonCanUse];
    }
    
}

#pragma mark --- ZHPickViewDelegate

- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    NSDateFormatter *datef = [[NSDateFormatter alloc] init];
    
    [datef setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    NSDate *now = [datef dateFromString:resultString];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: now];
    
    NSDate *localeDate = [now  dateByAddingTimeInterval: interval];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:localeDate];
    
    NSString *Birthday = [NSString stringWithFormat:@"%d/%d/%d",(int)[dateComponent year],(int)[dateComponent month],(int)[dateComponent day]];
    
    _userProfile.Birthday = Birthday;
    
    [self.mainTable reloadData];
    
    //判断保存按钮是否可用
    [self judgeSaveButtonCanUse];
}


- (void)shangchuantupian:(UIImage*)image {
    
    //第一步，创建URL
    NSString *URLString = @"http://116.254.206.7:12580/M/API/UploadPortrait?";//不需要传递参数
    
    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //第二步，创建请求
    
    //    2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    
    //设置请求体
    NSString *param = [NSString stringWithFormat:@"loginName=%@&loginPassword=%@&base64Photo=%@&photoExtName=%@",_userProfile.LoginName,_userProfile.LoginPassword,[self image2DataURL:image][1],[self image2DataURL:image][0]];
    
    //把拼接后的字符串转换为data，设置请求体
    NSData * postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"post"]; //指定请求方式
    
    [request setURL:URL]; //设置请求的地址
    
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLResponse * response;
    
    NSError * error;
    
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        //访问服务器失败进此方法
        NSLog(@"error : %@",[error localizedDescription]);
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [self hideHUD:YES];
            
            [self showToast:@"图片上传失败"];

        });
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //成功访问服务器，返回图片的URL
            NSLog(@"backData : %@",[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding]);
            
            _userProfile.HeadImg = [[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding];
            
            [UserAccountHandler shareUserAccountHandler].userProfile = _userProfile;
            
            [self hideHUD:YES];
            
            [self showToast:@"个人信息保存成功"];
            
            self.copareImage = self.editorImage;
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    }
}

// 判断图片后缀名的方法
- (BOOL)imageHasAlpha:(UIImage *)image {
    
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

// 把图片转换成base64位字符串，返回数组［0］：图片后缀名(.png/.jpeg)--［1］：base64位字符串
- (NSArray *) image2DataURL: (UIImage *) image {
    
    NSData *imageData = nil;
    
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        
        imageData = UIImagePNGRepresentation(image);
        
        mimeType = @".png";
        
    } else {
        
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        
        mimeType = @".jpeg";
    }
    
    NSString *baseStr = [imageData base64Encoding];
    
    // 转成base64位字符串之后要进行下面这一步替换，不然传到后台之后，加号等于号等一些特殊字符会变成空格，导致图片出问题
    NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)baseStr,NULL,CFSTR(":/?#[]@!$&’()*+,;="),kCFStringEncodingUTF8);
    
    NSArray *arr = [NSArray arrayWithObjects:mimeType,baseString, nil];
    
    return arr;
}

- (void)editPortrait {
    
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
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
    
    self.editorImage = image;
    
    //判断按钮是否可用
    [self judgeSaveButtonCanUse];
    
    self.portraitImageView.image = image;
    
    //保存图片到本地相册
    UIImageWriteToSavedPhotosAlbum(originImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//判断保存按钮是否可用
- (void)judgeSaveButtonCanUse {
    
    if ([self.NickName isEqualToString:_userProfile.NickName] &&
        [self.Gender isEqualToString:_userProfile.Gender] &&
        [self.Birthday isEqualToString:_userProfile.Birthday] && [self.editorImage isEqual:self.portraitImageView.image]) {
        
        self.saveButton.enabled = NO;
        
    } else {
        
        self.saveButton.enabled = YES;
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}

@end
