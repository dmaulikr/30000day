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

@interface UserInfoViewController () <UINavigationControllerDelegate,QGPickerViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)NSArray *titleArray;

@property (nonatomic,strong) UIImageView *portraitImageView;

@property (nonatomic,strong) UIImage * editorImage;

@property (nonatomic,copy) NSString *NickName;

@property (nonatomic,copy) NSNumber *gender;

@property (nonatomic,copy) NSString *lastBirthdayString;//程序刚进来保存的上次生日用来对比的

@property (nonatomic,copy) NSString *currentChooseBirthdayString;//每次点击生日选择该字符串都会被置空

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
 
    self.NickName = STUserAccountHandler.userProfile.nickName;
    
    self.gender = STUserAccountHandler.userProfile.gender;
    
    self.lastBirthdayString = STUserAccountHandler.userProfile.birthday;
    
    _titleArray = [NSArray arrayWithObjects:@"头像",@"昵称",@"性别",@"生日",nil];
    
}

- (void)saveButtonClick {

    [self showHUDWithContent:@"正在保存" animated:YES];
    
    //上传服务器
    [self.dataHandler sendUpdateUserInformationWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] nickName:STUserAccountHandler.userProfile.nickName gender:STUserAccountHandler.userProfile.gender birthday:STUserAccountHandler.userProfile.birthday headImageUrlString:STUserAccountHandler.userProfile.headImg success:^(BOOL success) {
        
//        if (![self.editorImage isEqual:self.copareImage]) {
//            
//            [self shangchuantupian:self.editorImage];
//            
//        } else {
//
//        }
        
        [self hideHUD:YES];
        
        [self showToast:@"个人信息保存成功"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(LONetError *error) {
        
        [self hideHUD:YES];
        
        [self showToast:@"个人信息保存失败"];
    }];

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
            
            cell.headImageViewURLString = STUserAccountHandler.userProfile.headImg;
            
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
                
                cell.detailTextLabel.text = STUserAccountHandler.userProfile.nickName;
                
                cell.textLabel.text = @"昵称";
            
            } else if ( indexPath.row == 2) {
                
                cell.detailTextLabel.text = [STUserAccountHandler.userProfile.gender isEqual:@1] ? @"男" : @"女";
                
                cell.textLabel.text = @"性别";
                
            } else if ( indexPath.row == 3) {
                
                cell.detailTextLabel.text= STUserAccountHandler.userProfile.birthday;
                
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
    
            cell.detailTextLabel.text = STUserAccountHandler.userProfile.userName;
        
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
            
            [self chooseActionSheet];
            
        }else if(indexPath.row == 1){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:STUserAccountHandler.userProfile.nickName message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            UITextField *textfile = [alert textFieldAtIndex:0];
            
            [textfile setText:STUserAccountHandler.userProfile.nickName];
            
            [alert show];
            
        } else if(indexPath.row == 2) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择性别"message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女", nil];
            
            [alertView show];
            
        } else if(indexPath.row == 3) {
            
            [self chooseBirthday];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


//选择生日
- (void)chooseBirthday {

    [self.view endEditing:YES];

    QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];

    picker.delegate = self;

    picker.titleText = @"生日选择";

    self.currentChooseBirthdayString = @"";

    //3.赋值
    [Common getYearArrayMonthArrayDayArray:^(NSMutableArray *yearArray, NSMutableArray *monthArray, NSMutableArray *dayArray) {

        NSArray *dateArray = [[Common getCurrentDateString] componentsSeparatedByString:@"-"];

        NSString *monthStr = dateArray[1];

        NSString *dayStr = dateArray[2];

        if (monthStr.length == 2 && [[monthStr substringToIndex:1] isEqualToString:@"0"]) {

            monthStr = [NSString stringWithFormat:@"%@月",[monthStr substringFromIndex:1]];

        } else {

            monthStr = [NSString stringWithFormat:@"%@月",monthStr];
        }

        if (dayStr.length == 2 && [[dayStr substringToIndex:1] isEqualToString:@"0"]) {

            dayStr = [NSString stringWithFormat:@"%@日",[dayStr substringFromIndex:1]];

        } else {

            dayStr = [NSString stringWithFormat:@"%@日",dayStr];
        }

        //显示QGPickerView
        [picker showOnView:[UIApplication sharedApplication].keyWindow withPickerViewNum:3 withArray:yearArray withArray:monthArray withArray:dayArray selectedTitle:[NSString stringWithFormat:@"%@年",dateArray[0]] selectedTitle:monthStr selectedTitle:dayStr];

    }];

}

#pragma mark -- QGPickerViewDelegate

- (void)didSelectPickView:(QGPickerView *)pickView value:(NSString *)value indexOfPickerView:(NSInteger)index indexOfValue:(NSInteger)valueIndex {

    self.currentChooseBirthdayString = [self.currentChooseBirthdayString stringByAppendingString:value];

    if (index == 3) {

        NSArray *array  = [self.currentChooseBirthdayString componentsSeparatedByString:@"年"];

        NSArray *array_second = [(NSString *)array[1] componentsSeparatedByString:@"月"];

        NSArray *array_third = [(NSString *)array_second[1] componentsSeparatedByString:@"日"];

        self.currentChooseBirthdayString = [NSString stringWithFormat:@"%@-%@-%@",array[0],[self addZeroWithString:array_second[0]],[self addZeroWithString:array_third[0]]];
        
        STUserAccountHandler.userProfile.birthday = self.currentChooseBirthdayString;
        
        [self.tableView reloadData];
        
        //判断保存按钮是否可用
        [self judgeSaveButtonCanUse];

    }
}

- (NSString *)addZeroWithString:(NSString *)string {

    if ([string length] == 1) {

        return string = [NSString stringWithFormat:@"0%@",string];

    } else {

        return string;
    }
}

#pragma mark --- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSIndexPath *indexpath = self.tableView.indexPathForSelectedRow;

    if ( indexpath.section == 0 && buttonIndex != 0 ) {
        
        if (indexpath.row == 1 ) {
            
            UITextField *textfile = [alertView textFieldAtIndex:0];
            
            STUserAccountHandler.userProfile.nickName = textfile.text;
        }
        if (indexpath.row == 2 ) {
            
            if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"男"]) {
                
                STUserAccountHandler.userProfile.gender = @1;
                
            } else {
                
                STUserAccountHandler.userProfile.gender = @0;
                
            }
        }

        [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
        
        //判断按钮是否可用
        [self judgeSaveButtonCanUse];
    }
    
}

- (void)chooseActionSheet {
    
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


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    
    if (!error) {
        
        message = @"成功保存到相册";
        
    } else {
        
        message = [error description];
    }
}

//判断保存按钮是否可用
- (void)judgeSaveButtonCanUse {
    
    if ([self.NickName isEqualToString:STUserAccountHandler.userProfile.nickName] &&
        [self.gender isEqual:STUserAccountHandler.userProfile.gender] &&
        [self.lastBirthdayString isEqualToString:STUserAccountHandler.userProfile.birthday] && [self.editorImage isEqual:self.portraitImageView.image]) {
        
        self.saveButton.enabled = NO;
        
    } else {
        
        self.saveButton.enabled = YES;
    }
}


@end
