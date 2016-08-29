//
//  SearchVersionManager.m
//  30000day
//
//  Created by GuoJia on 16/5/13.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SearchVersionManager.h"
#import "STLocationMananger.h"
#import "STCoreDataHandler.h"
#import "STChooseItemManager.h"

#define AppCurrentVersion        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AppID                       @"1086080481"

@interface SearchTableVersion : NSObject

@property (nonatomic,strong) NSNumber *searchTableVersionId;
@property (nonatomic,copy) NSString *tableName;
@property (nonatomic,copy) NSString *version;

@end

@implementation SearchTableVersion

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        self.searchTableVersionId = value;
    }
}

#pragma mark --- NSCoding的协议
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if ([self init]) {
        
        _searchTableVersionId = [aDecoder decodeObjectForKey:@"searchTableVersionId"];
        _tableName = [aDecoder decodeObjectForKey:@"tableName"];
        _version = [aDecoder decodeObjectForKey:@"version"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.searchTableVersionId forKey:@"searchTableVersionId"];
    [aCoder encodeObject:self.tableName forKey:@"tableName"];
    [aCoder encodeObject:self.version forKey:@"version"];
}

@end

@interface SearchVersionManager ()
@property (nonatomic,assign) BOOL canLoadWeMediaInfoTypes;//是否可以下载自媒体类型,初始化是NO
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation SearchVersionManager {
    BOOL _isForce;//是否
}

static SearchVersionManager *manager;

+ (SearchVersionManager *)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SearchVersionManager alloc] init];
        manager.canLoadWeMediaInfoTypes = NO;
        //登录成功刷新
        [STNotificationCenter addObserver:manager selector:@selector(loadLoadWeMediaInfoTypes) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
    });
    return manager;
}

- (void)loadLoadWeMediaInfoTypes {//下载自媒体类型
    
    if (self.canLoadWeMediaInfoTypes) {//YES才能去下载
        
        [[STChooseItemManager shareManager] addChooseItemDataUserId:STUserAccountHandler.userProfile.userId success:^(BOOL success) {
            [self encodeDataObject:self.dataArray];
        } failure:^(NSError *error) {
            [self deleteDataObjectWithKey:[NSString stringWithUTF8String:object_getClassName(self)]];//移除重新在下载
        }];
    }
}

- (void)synchronizedDataFromServer {
    
    [SearchVersionManager sendSearchTableVersion:^(NSMutableArray *dataArray) {
        self.dataArray = dataArray;
        NSMutableArray *oldArray = [self decodeObject];
        
        if (oldArray.count == 0 || oldArray == nil || (![[STChooseItemManager shareManager] isSaveData])) {
            
//           1.同步省-城市-区、县的数据【暂时没这个功能，先注释】
//            [[STLocationMananger shareManager] synchronizedLocationDataFromServer];
            //2.下载健康因子
            [[STCoreDataHandler shareCoreDataHandler] synchronizedHealthyDataFromServer:^(BOOL isSuccess) {
                
                if (isSuccess) {//同步数据成功
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self encodeDataObject:dataArray];
                    });
                    
                } else {//同步数据错误
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self deleteDataObjectWithKey:[NSString stringWithUTF8String:object_getClassName(self)]];
                    });
                }
            }];
            //3.把flag设置成yes
            self.canLoadWeMediaInfoTypes = YES;
            
        } else {
 
            if (oldArray.count == dataArray.count) {
                
                for (int i = 0; i < oldArray.count; i++) {
                    
                    SearchTableVersion *oldVersion = oldArray[i];
                    SearchTableVersion *newVersion = dataArray[i];
                    
                    if (![oldVersion.version isEqualToString:newVersion.version] && [oldVersion.tableName isEqualToString:newVersion.tableName] && [oldVersion.searchTableVersionId isEqualToNumber:@1]) {//城市的表

//                        //同步省-城市-区、县的数据【暂时没这个功能，先注释】
//                        [[STLocationMananger shareManager] synchronizedLocationDataFromServer];
                        
                    } else if (![oldVersion.version isEqualToString:newVersion.version] && [oldVersion.tableName isEqualToString:newVersion.tableName] && [oldVersion.searchTableVersionId isEqualToNumber:@2]) {//健康因子
                        
                        [[STCoreDataHandler shareCoreDataHandler] synchronizedHealthyDataFromServer:^(BOOL isSuccess) {
                            
                            if (isSuccess) {//同步数据成功
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self encodeDataObject:dataArray];
                                });
                                
                            } else {//同步数据错误
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [self deleteDataObjectWithKey:[NSString stringWithUTF8String:object_getClassName(self)]];
                                });
                            }
                        }];
                        
                    } else if (![oldVersion.version isEqualToString:newVersion.version] && [oldVersion.tableName isEqualToString:newVersion.tableName] && [oldVersion.searchTableVersionId isEqualToNumber:@3]) {//自媒体的类型
                        
                        self.canLoadWeMediaInfoTypes = YES;//设置YES等着登录成功去下载自媒体类型(因为设置自媒体数据需要userId)
                    }
                }
                
            } else {
                
                [[STCoreDataHandler shareCoreDataHandler] synchronizedHealthyDataFromServer:^(BOOL isSuccess) {
                    
                    if (isSuccess) {//同步数据成功
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self encodeDataObject:dataArray];
                        });
                        
                    } else {//同步数据错误
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self deleteDataObjectWithKey:[NSString stringWithUTF8String:object_getClassName(self)]];
                        });
                    }
                }];
                
                self.canLoadWeMediaInfoTypes = YES;
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//*********************************获取后台数据表格跟新版本信息*************************/
+ (void)sendSearchTableVersion:(void (^)(NSMutableArray *dataArray))success
                       failure:(void (^)(NSError *error))failure {
    
    NSString *STAPI = ST_API_SERVER;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",STAPI,GET_SEARCHTABLEVERSIION]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    request.HTTPMethod = @"GET";
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (connectionError) {//链接出现问题
            
            failure(connectionError);
            
        } else {//链接没有问题
            
            NSError *localError = nil;
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&localError];
            
            if (localError == nil) {
                
                NSDictionary *recvDic = (NSDictionary *)parsedObject;
                
                if ([recvDic[@"code"] isEqualToNumber:@0]) {
                    
                    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                    NSArray *array = recvDic[@"value"];
                    
                    for (int i = 0; i < array.count; i++) {
                        
                        NSDictionary *dictionary = array[i];
                        SearchTableVersion *commentModel = [[SearchTableVersion alloc] init];
                        [commentModel setValuesForKeysWithDictionary:dictionary];
                        [dataArray addObject:commentModel];
                    }
                    
                    success(dataArray);
                    
                } else {
                    
                    NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                    failure(failureError);
                }
                
            } else {
                failure(localError);
            }
        }
    }];
}
//检查版本更新
- (void)checkVersion {//storeString	__NSCFString *	"http://121.196.223.175:8082/stapi/1.0/upgrade/getAppUpgradeInfo?curVersion=2.0.0&osType=ios"	0x00007f823210f230
    
    NSString *storeString = [NSString stringWithFormat:@"%@%@?curVersion=%@&osType=ios",ST_API_SERVER,ST_VERSION_MANAGER,AppCurrentVersion];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([dictionary[@"code"] isEqualToNumber:@0]) {
                    
                    NSDictionary *dataDictionary = dictionary[@"value"];
                    if (![Common isObjectNull:dataDictionary] && [dataDictionary isKindOfClass:[NSDictionary class]]) {
                        
                        NSString *currentAppStoreVersion = dataDictionary[@"toVersion"];
                        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
                        NSString *description = dataDictionary[@"description"];//新版本的描述
                        //status: f:强制 s:建议 n：不升级
                        if ([dataDictionary[@"status"] isEqualToString:@"s"]) {//建议升级
                            
                            _isForce = NO;//非强制的
                            BOOL flag = [Common readAppBoolDataForkey:[NSString stringWithFormat:@"%@_%@",KEY_UPDATE_NOTIFICATION_IS_REMIND,currentAppStoreVersion]];
                            
                            if (!flag) {//YES 表示
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"有新的版本"
                                                                                    message:[NSString stringWithFormat:@"%@有新版本可以更新喽，请更新至%@。\r\n    版本：%@", appName, currentAppStoreVersion,description]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"回头再说"
                                                                          otherButtonTitles:@"下载更新", nil];
                                [alertView show];
                                [Common saveAppBoolDataForKey:[NSString stringWithFormat:@"%@_%@",KEY_UPDATE_NOTIFICATION_IS_REMIND,currentAppStoreVersion] withObject:YES];
                            }
                            
                        } else if ([dataDictionary[@"status"] isEqualToString:@"f"]) {//强制升级
                            
                            _isForce = YES;
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"有新的版本"
                                                                                message:[NSString stringWithFormat:@"%@有新版本可以更新喽，请更新至%@。\r\n    版本：%@", appName, currentAppStoreVersion,description]
                                                                               delegate:self
                                                                      cancelButtonTitle:nil
                                                                      otherButtonTitles:@"下载更新", nil];
                            [alertView show];
                        }
                    }

                }
                
//                NSArray *versionsInAppStore = [[dictionary valueForKey:@"results"] valueForKey:@"version"];
//                
//                if (![versionsInAppStore count] ) { // No versions of app in AppStore
//                    return;
//                } else {
//                    
//                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
//                    NSString *firstString = [[kHarpyCurrentVersion componentsSeparatedByString:@"."] firstObject];//本地的
//                    NSString *secondeString = [[currentAppStoreVersion componentsSeparatedByString:@"."] firstObject];//appStore的
//                    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
//                    NSArray *stringArray = [[dictionary valueForKey:@"results"] valueForKey:@"releaseNotes"];//新版本的描述
//                
//                    if ([kHarpyCurrentVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
//                        
//                        if ([firstString isEqualToString:secondeString]) {//非强制
//                            
//                            _isForce = NO;//非强制的
//                            BOOL flag = [Common readAppBoolDataForkey:[NSString stringWithFormat:@"%@_%@",KEY_UPDATE_NOTIFICATION_IS_REMIND,secondeString]];
//                            if (!flag) {//YES 表示
//                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"有新的版本"
//                                                                                    message:[NSString stringWithFormat:@"%@有新版本可以更新喽，请更新至%@。\r\n    版本：%@", appName, currentAppStoreVersion,stringArray[0]]
//                                                                                   delegate:self
//                                                                          cancelButtonTitle:@"回头再说"
//                                                                          otherButtonTitles:@"下载更新", nil];
//                                [alertView show];
//                                [Common saveAppBoolDataForKey:[NSString stringWithFormat:@"%@_%@",KEY_UPDATE_NOTIFICATION_IS_REMIND,secondeString] withObject:YES];
//                            }
//                            
//                        } else {
//                            
//                            _isForce = YES;
//                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"有新的版本"
//                                                                                message:[NSString stringWithFormat:@"%@有新版本可以更新喽，请更新至%@。\r\n    版本：%@", appName, currentAppStoreVersion,stringArray[0]]
//                                                                               delegate:self
//                                                                      cancelButtonTitle:nil
//                                                                      otherButtonTitles:@"下载更新", nil];
//                            [alertView show];
//                        }
//                    }
//                }
            });
        }
    }];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (_isForce ) {
        
        NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", AppID];
        NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
        [[UIApplication sharedApplication] openURL:iTunesURL];
        
        //正在更新
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication].delegate window]];
        [[[UIApplication sharedApplication].delegate window] addSubview:HUD];
        HUD.labelText = @"请前往appStore更新";
        HUD.removeFromSuperViewOnHide = YES;
        [HUD show:YES];
        
    } else {
        
        if (buttonIndex == 1) {
            NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", AppID];
            NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
            [[UIApplication sharedApplication] openURL:iTunesURL];
        }
    }
}

- (void)dealloc {
    [STNotificationCenter removeObserver:self name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
}

@end
