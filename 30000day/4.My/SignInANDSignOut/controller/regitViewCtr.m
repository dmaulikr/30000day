//
//  regitViewCtr.m
//  30000天
//
//  Created by wei on 15/11/19.
//  Copyright © 2015年 wei. All rights reserved.
//

#import "regitViewCtr.h"

#define IdentityCount 60
#define INTERVAL_KEYBOARD 100

@interface regitViewCtr () {
    int gaodu;//记录当前view的高度是不是负数
}

@property (nonatomic,copy) NSString *cityName;

@property (nonatomic) NSTimer *timer;

@property (nonatomic) CGRect newFream;// 当前view的位置，用于记录 弹出键盘的时候使用

@property (nonatomic,strong)UISwipeGestureRecognizer *RightSwipeGestureRecognizer;

@property (strong,nonatomic)CLLocationManager *locationManager;

@property (nonatomic,assign)CGRect selectedTextFieldRect;

@end

@implementation regitViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"闪电注册";
    
    self.passwordTextSubView.layer.borderWidth = 1.0;
    
    self.passwordTextSubView.layer.borderColor = [UIColor colorWithRed:214.0/255 green:214.0/255.0 blue:214.0/255 alpha:1.0].CGColor;
    
    self.niceNameTextSubView.layer.borderWidth = 1.0;
    
    self.niceNameTextSubView.layer.borderColor=[UIColor colorWithRed:214.0/255 green:214.0/255.0 blue:214.0/255 alpha:1.0].CGColor;
    
    self.submitBtn.layer.cornerRadius=6;
    
    self.submitBtn.layer.masksToBounds=YES;
    
    [self startLocation];//开启定位
    
    _newFream = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    _userNickNameTxt.delegate = self;
    
    self.submitBtn.layer.borderWidth=0.5;
    
    self.submitBtn.layer.borderColor=[UIColor colorWithRed:181.0/255 green:181.0/255 blue:181.0/255 alpha:1.0].CGColor;
    
    [self.userNameTxt setDelegate:self];
    
    [self.userPwdTxt setDelegate:self];
    
    [self.ConfirmPasswordTxt setDelegate:self];
    
    [self.userNickNameTxt setDelegate:self];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


#pragma mark - 注册验证
- (IBAction)regitF:(UIButton *)sender {
    
    if( [_userPwdTxt.text isEqualToString:@""] ) {
        
        [self showToast:@"密码不能为空"];
        
        return;
    }
    
    if ([_userNameTxt.text isEqualToString:@""]){
        
        [self showToast:@"账户不能为空"];
        
        return;
        
    }
    
   if (![_userPwdTxt.text isEqualToString:_ConfirmPasswordTxt.text]){
        
        [self showToast:@"密码不一致，请重新确认"];
        
        return;
    }
    
    [self registerUser];
}

#pragma mark - 注册
- (void)registerUser {
    
    //调用注册接口
    [self.dataHandler postRegesiterWithPassword:_userPwdTxt.text
                                    phoneNumber:_PhoneNumber
                                       nickName:_userNickNameTxt.text
                                      loginName:_userNameTxt.text
                                        success:^(id responseObject) {
                                           
                                            //保存健康因素
                                            [self.dataHandler postUpdateHealthDataWithPassword:self.userPwdTxt.text loginName:self.userNameTxt.text cityName:self.cityName success:^(BOOL sucess) {
                                                
                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                                
                                                [alert setTag:1];
                                                
                                                [alert show];
                                                
                                            } failure:^(NSError *error) {
                                                
                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册失败" message:[error localizedDescription] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                                
                                                [alert show];
                                                
                                            }];
                                        }
     
                                        failure:^(NSError *error) {
                                            
                                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"注册失败" message:[error localizedDescription] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                            [alert show];
                                            
                                        }];
    
}

#pragma mark - alertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        
        if (buttonIndex == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - 定位
-(void)startLocation{
    
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init] ;
        
        self.locationManager.delegate = self;
        
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        
        _locationManager.distanceFilter=100;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)[_locationManager requestWhenInUseAuthorization];
    }else{
        
        //提示用户无法进行定位操作  Product
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"开启定位功能可获取当地平均寿命哦"
                                                          delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        return;
    }
    
    [_locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    //如果调用已经一次，不再执行
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error) {
        
        if (array.count > 0){
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //将获得的所有信息显示到label上
            NSString *city = placemark.locality;
            
            NSLog(@"%@",city);
            
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
            self.cityName = city;
            
        } else if (error == nil && [array count] == 0) {
            
            NSLog(@"No results were returned.");
            
        } else if (error != nil) {
            
            NSLog(@"An error occurred = %@", error);
            
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
    
}


#pragma mark - 文本框开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.selectedTextFieldRect=textField.frame;
    
}

#pragma mark - 键盘return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - 点击空白处收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.userNameTxt resignFirstResponder];
    
    [self.userPwdTxt resignFirstResponder];
    
    [self.ConfirmPasswordTxt resignFirstResponder];
    
    [self.userNickNameTxt resignFirstResponder];
}

#pragma mark - 当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)notification {
    
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (self.selectedTextFieldRect.origin.y+self.selectedTextFieldRect.size.height+INTERVAL_KEYBOARD) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

#pragma mark - 当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    // 键盘动画时间
    double duration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        
        return NO;
        
    }
    
    return  YES;
}

#pragma mark - 视图消失时释放通知
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
