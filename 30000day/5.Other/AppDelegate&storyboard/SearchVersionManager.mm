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

#define kHarpyCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]
#define kHarpyAppID                 @"1086080481"

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
    
    if ([self init]) {
        
        self.searchTableVersionId = [aDecoder decodeObjectForKey:@"searchTableVersionId"];
        self.tableName = [aDecoder decodeObjectForKey:@"tableName"];
        self.version = [aDecoder decodeObjectForKey:@"version"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.searchTableVersionId forKey:@"searchTableVersionId"];
    
    [aCoder encodeObject:self.tableName forKey:@"tableName"];
    
    [aCoder encodeObject:self.version forKey:@"version"];
}

@end

@implementation SearchVersionManager {
    BOOL _isForce;//是否
}

static SearchVersionManager *manager;

+ (SearchVersionManager *)shareManager {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[SearchVersionManager alloc] init];
    });
    
    return manager;
}

- (void)synchronizedDataFromServer {
    
    [SearchVersionManager sendSearchTableVersion:^(NSMutableArray *dataArray) {
        
        NSMutableArray *oldArray = [self decodeObject];
        
        if (oldArray.count == 0 || oldArray == nil) {
            
//            同步省-城市-区、县的数据【暂时没这个功能，先注释】
//            [[STLocationMananger shareManager] synchronizedLocationDataFromServer];
            
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

- (void)checkVersion {
    // Asynchronously query iTunes AppStore for publically available version
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kHarpyAppID];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                
                if ( ![versionsInAppStore count] ) { // No versions of app in AppStore
                    return;
                } else {
                    
                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                    NSString *firstString = [[kHarpyCurrentVersion componentsSeparatedByString:@"."] firstObject];//本地的
                    NSString *secondeString = [[currentAppStoreVersion componentsSeparatedByString:@"."] firstObject];//appStore的
                    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
                    if ([kHarpyCurrentVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedDescending) {
                        
                        if ([firstString isEqualToString:secondeString]) {//强制
                            
                            _isForce = YES;
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"有新的版本"
                                                                                message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.", appName, currentAppStoreVersion]
                                                                               delegate:self
                                                                      cancelButtonTitle:nil
                                                                      otherButtonTitles:@"下载更新", nil];
                            [alertView show];
                        
                        } else {
                            
                            _isForce = NO;//非强制的
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"有新的版本"
                                                                                message:[NSString stringWithFormat:@"A new version of %@ is available. Please update to version %@ now.", appName, currentAppStoreVersion]
                                                                               delegate:self
                                                                      cancelButtonTitle:@"回头再说"
                                                                      otherButtonTitles:@"下载更新", nil];
                            [alertView show];
                        }
                    }
                }
            });
        }
    }];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (_isForce ) {
        
        NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
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
            NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
            NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
            [[UIApplication sharedApplication] openURL:iTunesURL];
        }
    }
}

@end
