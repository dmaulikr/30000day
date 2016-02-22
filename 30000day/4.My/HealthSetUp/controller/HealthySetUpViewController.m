//
//  healthySetUpViewController.m
//  30000天
//
//  Created by wei on 16/1/27.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "HealthySetUpViewController.h"
#import "sys/utsname.h"
#import "HealthyTableViewCell.h"
#import "HZAreaPickerView.h"
#import "GetFactorModel.h"

@interface HealthySetUpViewController () <UITableViewDataSource,UITableViewDelegate,HZAreaPickerDelegate,QGPickerViewDelegate>

@property (nonatomic,strong) UserProfile *userProfile;

@property (strong, nonatomic) HZAreaPickerView *locatePicker;

@property (nonatomic,strong) NSIndexPath* clickindexpath;

@property (nonatomic,strong) NSMutableArray* Elements;//因素

@property (nonatomic,strong) NSMutableArray* Alternative;//选项

@property (nonatomic,strong)NSMutableArray* UserAlternative;//用户更新选项

@property (nonatomic,strong)NSMutableArray* DayArr;//天数

@property (nonatomic,strong)NSMutableArray* UserDayArr;//用户选择匹配天数

@property (nonatomic,strong)NSMutableArray* UserSelectSubResultsIndex;//用户选择项下标

@property (nonatomic,strong)NSMutableArray* UserElements;

@property (nonatomic,strong)NSMutableArray* nextSubResults;

@property (nonatomic,strong)NSMutableArray* nextSubFators;

@property (nonatomic,assign)NSInteger AvearageLife; //基数

@property (nonatomic,assign)CGFloat sumDay;//上次总天数

@property (nonatomic,strong)NSMutableArray* SubResultsString;

@property (nonatomic,assign)NSInteger cityDay;

@property (nonatomic , strong) NSMutableArray *getFactorArray;//从服务器获取到的健康因子

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HealthySetUpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"健康因素";
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveFactor)];
    
    self.navigationItem.rightBarButtonItem = barButton;
    
    _userProfile = [UserAccountHandler shareUserAccountHandler].userProfile;
    
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    //下载健康因素
    [self loadFactor];

}

//保存健康因素
- (void)saveFactor {
    
    
    
}

- (void)loadFactor {
    
    //获取所有的健康因子
    [self.dataHandler sendGetFactors:^(NSMutableArray *dataArray) {
       
        self.getFactorArray = dataArray;
        
        [self.tableView reloadData];
        
    } failure:^(LONetError *error) {
        
        [self showToast:error.error.userInfo[NSLocalizedDescriptionKey]];
        
    }];
}

//设置QGPickView,并显示QGPickView
- (void)setQGPickViewWith:(GetFactorModel *)factorModel indexPath:(NSIndexPath *)indexPath {
    
    QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
    
    picker.delegate = self;
    
    picker.titleText = factorModel.title;
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0;  i < factorModel.subFactorArray.count; i++) {
        
        NSString *title = [(SubFactorModel *)factorModel.subFactorArray[i] title];
        
        [array addObject:title];
    }
    
    //显示QGPickerView
    [picker showOnView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:array withArray:nil withArray:nil selectedTitle:factorModel.userSubFactorModel.title selectedTitle:nil selectedTitle:nil];
    
    [Common saveAppIntegerDataForKey:HEALTHSETINDICATE withObject:indexPath.row];
}

#pragma ---
#pragma mark --- QGPickerViewDelegate

- (void)didSelectPickView:(QGPickerView *)pickView  value:(NSString *)value indexOfPickerView:(NSInteger)index indexOfValue:(NSInteger)valueIndex {
    
    if (index == 1) {
    
        GetFactorModel *factorModel = self.getFactorArray[[Common readAppIntegerDataForKey:HEALTHSETINDICATE]];
        
        factorModel.userSubFactorModel.title = value;
        
        [self.tableView reloadData];
    }
}

//初始化加载plist数据
-(void)ElementplistData {
    
    //因素
    NSString* ElementPath = [[NSBundle mainBundle]pathForResource:@"Element" ofType:@"plist"];
    self.Elements = [[NSMutableArray alloc]initWithContentsOfFile:ElementPath];
    
    //选项
    NSString *AlternativePath = [[NSBundle mainBundle]pathForResource:@"ElementAlternative" ofType:@"plist"];
    
    self.Alternative = [[NSMutableArray alloc]initWithContentsOfFile:AlternativePath];
    
    //用户选项项
    self.UserAlternative = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",
                          @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",
                          @"",@"",@"",@"",@"",@"",@"", nil];
    //用户加减的因素
    self.UserElements = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",
                       @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",
                       @"",@"",@"",@"",@"",@"",@"", nil];
    
    
    //    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //    if ([userDefaults objectForKey:@"UserAlternative"]) {
    //        [self.UserAlternative removeAllObjects];
    //        [self.UserAlternative addObjectsFromArray:[userDefaults objectForKey:@"UserAlternative"]];
    //
    ////        self.UserAlternative =(NSMutableArray *) [userDefaults objectForKey:@"UserAlternative"];
    //    }
    
    //天数计算
    NSString *Day = [[NSBundle mainBundle]pathForResource:@"Day" ofType:@"plist"];
    
    self.DayArr = [[NSMutableArray alloc]initWithContentsOfFile:Day];
    
    //用户选择匹配天数
    self.UserDayArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",
                     @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",
                     @"",@"",@"",@"",@"",@"",@"", nil];
}

#pragma mark -查询以前设置的健康因素选项
- (void)loadHealthy {
    
//    //先提取   如果没有就初始化数组
//    
//    NSArray *ar = [[NSUserDefaults standardUserDefaults] objectForKey:self.userProfile.LoginName];
//    
//    self.UserAlternative = [NSMutableArray arrayWithArray:ar];
//    
//    if (self.UserAlternative == nil || self.UserAlternative.count == 0) {
//        
//        //用户选项
//        self.UserAlternative=[[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",
//                              @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",
//                              @"",@"",@"",@"",@"",@"",@"", nil];
//    }
//    
//    NSString * URLString = @"http://116.254.206.7:12580/M/API/GetLatestUserLifeStatDetails?";
//    
//    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSString * postString = [NSString stringWithFormat:@"howManyDays=%d&userID=%@&loginname=%@&loginpassword=%@",1,_userProfile.UserID,_userProfile.LoginName,_userProfile.LoginPassword];
//    
//    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    
//    [request setHTTPMethod:@"post"];
//    
//    [request setURL:URL];
//    
//    [request setHTTPBody:postData];
//    
//    NSURLResponse * response;
//    NSError * error;
//    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if (error) {
//        NSLog(@"error : %@",[error localizedDescription]);
//    }else{
//        NSArray* backDataArr=[NSJSONSerialization JSONObjectWithData:backData options:NSJSONReadingAllowFragments error:&error];
//        NSDictionary* backDataDic=backDataArr[0];
//        if (backDataDic!=nil) {
//            
//            CGFloat sumDay=[backDataDic[@"TotalLife"] floatValue];
//            NSMutableArray* SubFators =[NSMutableArray arrayWithArray:[backDataDic[@"SubFators"] componentsSeparatedByString:@","]];
//            NSMutableArray* SubResults =[NSMutableArray arrayWithArray:[backDataDic[@"SubResults"] componentsSeparatedByString:@","]];
//            NSMutableArray* SubResultsString=[NSMutableArray arrayWithArray:[backDataDic[@"SubResultsString"] componentsSeparatedByString:@","]];
//            if (SubResultsString==nil) {
//                SubResultsString=[[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",
//                                  @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",
//                                  @"",@"",@"",@"",@"",@"",@"", nil];
//            }
//            CGFloat AvearageLife=[[SubResults lastObject] floatValue];
//            
//            //因素以及值
//            self.nextSubResults = SubResults;
//            
//            //健康因素数据为0
//            self.nextSubResults[self.nextSubResults.count-3] = @"0";
//            
//            self.nextSubResults[self.nextSubResults.count-4] = @"0";
//            
//            self.nextSubResults[self.nextSubResults.count-5] = @"0";
//            
//            self.nextSubResults[self.nextSubResults.count-6] = @"0";
//            
//            self.nextSubFators = SubFators;
//            
//            //总天数
//            self.sumDay = sumDay;
//            
//            self.SubResultsString = SubResultsString;
//            
//            //基数
//            self.AvearageLife = AvearageLife;
//            
//            self.cityDay = [SubResults[0] integerValue];
//        }
//    }
    
    //ElementsStr=[ElementsStr stringByAppendingString:[NSString stringWithFormat:@"pm25,StepCount,FloorCount,ExerciseDistance,AvearageLife"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.getFactorArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *healthyIdentifier = @"HealthyTableViewCell";

    HealthyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:healthyIdentifier];
    
    if (cell == nil) {
    
        cell = [[[NSBundle mainBundle] loadNibNamed:healthyIdentifier owner:self options:nil] lastObject];
    }
    
    GetFactorModel *factorModel = self.getFactorArray[indexPath.row];
    
    cell.cellIndexPath = indexPath;
    
    cell.factorModel = factorModel;
    
    //如果用户有选择设置健康因子，那么就要显示该健康因子,如果用户没有选择健康因子，那么要显示设置
    [cell.setButton setTitle:[Common isObjectNull:factorModel.userSubFactorModel.title] ? @"设置" : factorModel.userSubFactorModel.title  forState:UIControlStateNormal];
    
    //按钮点击回调
    [cell setSetButtonClick:^(NSIndexPath *cellIndexPath) {
        
//        [self cancelLocatePicker];
//        
//        self.clickindexpath = cellIndexPath;
//        
//        if (cellIndexPath.section == 0) {
//            
//            if (cellIndexPath.row == 0) {
//                
//                [self cancelLocatePicker];
//                
//                self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity delegate:self];
//                
//                [self.locatePicker showInView:self.view];
//                
//            } else {
//                
//                [self alertView:self.Alternative[cellIndexPath.row] title:self.Elements[cellIndexPath.row]];
//            }
//        }
        
        [self setQGPickViewWith:self.getFactorArray[cellIndexPath.row] indexPath:indexPath];
        
    }];

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self cancelLocatePicker];
}


- (void)alertView:(NSArray*)btntitlearr title:(NSString*)titlestring {
    
    UIAlertView *alert;
    
    switch (btntitlearr.count) {
            
        case 2:
            
            alert=[[UIAlertView alloc]initWithTitle:titlestring message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:btntitlearr[0], btntitlearr[1],nil];
            
            break;
            
        case 3:
            
            alert=[[UIAlertView alloc]initWithTitle:titlestring message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:btntitlearr[0], btntitlearr[1],btntitlearr[2],nil];
            
            break;
            
        case 4:
            alert=[[UIAlertView alloc]initWithTitle:titlestring message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:btntitlearr[0], btntitlearr[1],btntitlearr[2],btntitlearr[3],nil];
            break;
        case 5:
            alert=[[UIAlertView alloc]initWithTitle:titlestring message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:btntitlearr[0], btntitlearr[1],btntitlearr[2],btntitlearr[3],btntitlearr[4],nil];
            break;
        case 6:
            alert=[[UIAlertView alloc]initWithTitle:titlestring message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:btntitlearr[0], btntitlearr[1],btntitlearr[2],btntitlearr[3],btntitlearr[4],btntitlearr[5],nil];
            break;
        default:
            break;
    }
    [alert show];
    
}
#pragma mark--设置选项
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (buttonIndex==0){
            self.UserSelectSubResultsIndex[self.clickindexpath.row]=@"";
            self.UserDayArr[self.clickindexpath.row]=@"0";
            self.UserElements[self.clickindexpath.row]=@"";
            self.UserAlternative[self.clickindexpath.row]=@"";
            [self.tableView reloadRowsAtIndexPaths:@[self.clickindexpath] withRowAnimation:UITableViewRowAnimationMiddle];
        }else{
            NSString* UserSelectSubResultsIndexString=[NSString stringWithFormat:@"%ld.%ld",(long)self.clickindexpath.row,(long)buttonIndex];
            self.UserSelectSubResultsIndex[self.clickindexpath.row]=UserSelectSubResultsIndexString;
            self.UserElements[self.clickindexpath.row]=self.Elements[self.clickindexpath.row];
            self.UserAlternative[self.clickindexpath.row]=[alertView buttonTitleAtIndex:buttonIndex];
            self.UserDayArr[self.clickindexpath.row]=self.DayArr[self.clickindexpath.row][buttonIndex-1];
            [self.tableView reloadRowsAtIndexPaths:@[self.clickindexpath] withRowAnimation:UITableViewRowAnimationMiddle];
        }
}



- (void)preservation {
    
//    NSInteger s=0;
//    CGFloat resultsDay=0;//总加减天数
//    CGFloat toDayAvearageLife=0;
//    CGFloat toDaySumDay=0;
//    
//    //NSString* sumHealthy=[[NSString alloc]init];//加减值
//    //NSString* sumUsera=[[NSString alloc]init];//加减因素
//    NSDate *  senddate=[NSDate date];//当前时间
//    for (int i=0; i<self.UserDayArr.count; i++) {
//        
//        if (![self.UserDayArr[i] isEqualToString:@""]) {
//            if ([[self.UserDayArr[i] substringToIndex:1] isEqualToString:@"-"]) {
//                resultsDay=resultsDay-[self.UserDayArr[i] substringFromIndex:1].floatValue;
//            }else{
//                resultsDay=resultsDay+[self.UserDayArr[i] substringFromIndex:1].floatValue;
//            }
//            
//            self.nextSubResults[i]=self.UserDayArr[i];
//            //CGFloat x=[self.UserDayArr[i] floatValue];
//            //sumHealthy=[sumHealthy stringByAppendingFormat:@"%@,",self.UserDayArr[i]];
//            //sumUsera=[sumUsera stringByAppendingFormat:@"%@,",self.UserElements[i]];
//        }else{
//            s=s+1;
//        }
//        
//    }
//    
//    NSMutableArray* SubResults =[NSMutableArray arrayWithArray:[self.UserAlternative[0] componentsSeparatedByString:@"."]];
//    
//    NSString *cick = SubResults[0];
//    
//    if (cick!=nil && ![cick isEqualToString:@""]) {
//        NSString* ProvinceLifeExpectancyMan=[[NSBundle mainBundle]pathForResource:@"ProvinceLifeExpectancyMan" ofType:@"plist"];
//        NSDictionary* citydic=[[NSDictionary alloc]initWithContentsOfFile:ProvinceLifeExpectancyMan];
//        NSInteger yeardate=[citydic[cick] integerValue];
//        NSInteger AvearageLife=[self AverageLifeToDay:yeardate];
//        if (AvearageLife>0) {
//            //self.UserDayArr[0]=[NSString stringWithFormat:@"%ld",(long)AvearageLife];
//            self.nextSubResults[0]=[NSString stringWithFormat:@"%ld",(long)AvearageLife];
//            NSInteger avg=AvearageLife-self.cityDay;
//            self.AvearageLife=self.AvearageLife+avg;
//            self.sumDay=self.sumDay+avg;
//        }
//    }
//    
//    toDayAvearageLife=self.AvearageLife+resultsDay;
//    self.AvearageLife=self.AvearageLife+(toDayAvearageLife-self.AvearageLife);
//    
//    toDaySumDay=self.sumDay+resultsDay;
//    self.sumDay=self.sumDay+(toDaySumDay-self.sumDay);
//    
//    
//    self.nextSubResults[self.nextSubResults.count-1]=[NSString stringWithFormat:@"%ld",(long)self.AvearageLife];
//    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//    NSInteger status = 0;
//    
//    if ([userDefaults objectForKey:_userProfile.LoginName]) {
//        NSMutableArray * tempArr = [[NSMutableArray alloc]init];
//        [tempArr addObjectsFromArray:[userDefaults objectForKey:_userProfile.LoginName]];
//        
//        if ([self.UserAlternative isEqualToArray:tempArr]) {
//            status = 1;
//        }
//    }
//    if (s==self.UserDayArr.count || status==1 ){
//        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您没修改任何因素" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }else{
//        //        if (sumHealthy.length) {
//        //            sumHealthy=[sumHealthy substringToIndex:sumHealthy.length-1];
//        //        }
//        //        if (sumUsera.length) {
//        //            sumUsera=[sumUsera substringToIndex:sumUsera.length-1];
//        //        }
//        //        sumHealthy=[sumHealthy substringToIndex:sumHealthy.length-1];
//        //        sumUsera=[sumUsera substringToIndex:sumUsera.length-1];
//        
//        
//        NSString* nextSubResultsString=@"";
//        NSString* nextSubFatorsString=@"";
//        
//        for (int i=0; i<self.nextSubResults.count; i++) {
//            if (i==0) {
//                nextSubResultsString=[nextSubResultsString stringByAppendingFormat:@"%@",self.nextSubResults[i]];
//                nextSubFatorsString=[nextSubFatorsString stringByAppendingFormat:@"%@",self.nextSubFators[i]];
//            }else{
//                nextSubResultsString=[nextSubResultsString stringByAppendingFormat:@",%@",self.nextSubResults[i]];
//                nextSubFatorsString=[nextSubFatorsString stringByAppendingFormat:@",%@",self.nextSubFators[i]];
//            }
//        }
//        
//        
//        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//        [dateformatter setDateFormat:@"yyyy-MM-dd"];
//        NSString* locationString=[dateformatter stringFromDate:senddate];
//        
//        NSString *URLString=@"http://116.254.206.7:12580/M/API/WriteUserLifeForEachDay?";
//        NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
//        
//        NSString *param=[NSString stringWithFormat:@"loginName=%@&loginPassword=%@&sumDay=%lf&result=%@&date=%@&subFators=%@&subResults=%@",_userProfile.LoginName,_userProfile.LoginPassword,self.sumDay,[NSString stringWithFormat:@"%.2lf",resultsDay],locationString,nextSubFatorsString,nextSubResultsString];
//        
//        //把拼接后的字符串转换为data，设置请求体
//        NSData * postData = [param dataUsingEncoding:NSUTF8StringEncoding];
//        [request setHTTPMethod:@"post"]; //指定请求方式
//        [request setURL:URL]; //设置请求的地址
//        [request setHTTPBody:postData];  //设置请求的参数
//        NSURLResponse * response;
//        NSError * error;
//        NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//        
//        if (error) {
//            NSLog(@"error : %@",[error localizedDescription]);
//        }else{
//            if ([[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding] intValue]==1) {
//                [[NSUserDefaults standardUserDefaults] setObject:self.UserAlternative forKey:self.userProfile.LoginName];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"健康因素保存成功。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alert show];
//            }else{
//                NSString* errorstring=[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding];
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"保存失败" message:errorstring delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alert show];
//            }
//        }
//    }

}


//计算平均寿命的天数
-(NSInteger)AverageLifeToDay:(NSInteger)today{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:[self day:today]];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}

//现在时间减去平均寿命
-(NSDate *)day:(NSInteger)today{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    components.year=components.year-today;
    NSString* newdate=[NSString stringWithFormat:@"%ld-%ld-%ld",(long)components.year,(long)components.month,(long)components.day];
    
    NSDateFormatter* date=[[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate* returndate=[date dateFromString:newdate];
    return returndate;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
}

- (void)cancelLocatePicker{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
