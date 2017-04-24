//
//  SHNetworkingManager.m
//  MyFramework
//
//  Created by lalala on 2017/4/12.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "SHNetworkingManager.h"
#import "NSString+Cache.h"
#import "YYCache+Cache.h"
#import "UIView+Toast.h"
#import "MBProgressHUD+LJ.h"
#import <AdSupport/ASIdentifierManager.h>
/**
 *  是否开启https SSL 验证
 *  @return YES为开启，NO为关闭
 */
#define openHttpsSSL YES
typedef NS_ENUM(NSInteger, NetworkRequestType){
    NetworkRequestTypeGET,//GET请求
    NetworkRequestTypePOST,//POST请求
    NetworkRequestTypePUT,//PUT请求
    NetworkRequestTypeDELETE//DELETE请求
};
//网络状态，初始值为-1： 未知的网络状态
static NSInteger networkStatus = -1;
//缓存的路径
static inline NSString * cachePath(){
    return [NSString cachesPathString];
}
@implementation SHNetworkingManager
+(SHNetworkingManager *)shareManager{
    static SHNetworkingManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[SHNetworkingManager alloc]init];
        }
    });
    return manager;
}

#pragma mark  网络的判断
+(void)checkNetworkLinkStatus{
    //创建网络状态监测的管理者
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager manager];
    //监听改变
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        networkStatus = status;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NetworkLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NetworkLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NetworkLog(@"3G|4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NetworkLog(@"WiFi");
                break;
            default:
                break;
        }
    }];
    [reachability startMonitoring];
}
+(NSInteger)theNetworkLinkStatus{
    return networkStatus;
}
#pragma mark ---接口参数加密----
//创建package签名
/**
 *  接口参数加密
 *
 *  @param dict 参数
 *
 *  @return 返回时间和加密后的字符串字典
 */
+(NSDictionary *)createMD5Sign:(NSMutableDictionary *)dict{
    NSTimeInterval atime = [[NSDate date] timeIntervalSince1970];
    NSString * timeString = [NSString stringWithFormat:@"%.f",atime];
    NSMutableDictionary * resultDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [resultDict setObject:timeString forKey:@"timestamp"];
    //这里可以存储需要加密的参数
    
    NSMutableString * contentString = [NSMutableString string];
    NSArray * keys = [resultDict allKeys];
    //按照字母排序
    NSArray * sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    if (sortedArray) {
        for (NSString * category in sortedArray) {
            if (![StringWithFormat([resultDict objectForKey:category]) isEqualToString:@""]
                && ![StringWithFormat([resultDict objectForKey:category]) isEqualToString:@"key"]
                && ![[resultDict objectForKey:category] isKindOfClass:[NSData class]]) {
                [contentString appendFormat:@"%@=%@&",category,[resultDict objectForKey:category]];
            }
        }
    }
    //添加key字段
//    [contentString appendFormat:@"key=%@",spkey];
    //得到MD5 sign签名
    [contentString appendString:@"key=##########"];
    NSLog(@"查看加密前%@",contentString);
    NSString * md5String = [NSString networkingUrlString_md5:contentString];
    NSLog(@"查看加密后%@",md5String);
    //输出Debug Info
    return @{@"md5Str":md5String,@"timestamp":timeString};
}
#pragma mark ---HTTPS SSL验证---
//https ssl 验证
+(AFSecurityPolicy *)customSecurityPolicy{
    //先导入证书
    NSString * cerPath = [[NSBundle mainBundle] pathForResource:@"###########" ofType:@"cer"];//证书的路径
    NSData * cerData = [NSData dataWithContentsOfFile:cerPath];
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    //allowInvalidCertificates 是否允许无效的证书（自建的证书）,默认是NO
    //如果是自建的证书 需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = YES;
    NSSet * set = [NSSet setWithObjects:cerData, nil];
    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}
#pragma mark ---网络请求AFHTTPSessionManager-----
+(AFHTTPSessionManager *)getRequestManagerWithDic:(NSDictionary *)dic{
    return [self getRequestManagerWithDic:dic andHeader:nil];
}
+(AFHTTPSessionManager *)getRequestManagerWithDic:(NSDictionary *)dic andHeader:(NSDictionary *)dict{
    NSMutableDictionary * paramterDict = [NSMutableDictionary dictionaryWithDictionary:dic];
    //返回加密后的字典
//    NSDictionary * resultDictionary = [self createMD5Sign:paramterDict];
    //设置基本的URL
    AFHTTPSessionManager * manager = [[AFHTTPSessionManager manager]initWithBaseURL:[NSURL URLWithString:HTTPClientBaseURLString]];
    AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
    //json传送方式 去掉<null>
    response.removesKeysWithNullValues = YES;
    manager.responseSerializer = response;
//    //添加请求头参数
//    if (dict != nil) {
//        NSArray * keys = [dict allKeys];
//        for (NSString * string in keys) {
//            [manager.requestSerializer setValue:dict[string] forHTTPHeaderField:string];
//        }
//    }
//    //广告标识符
//    NSString * adid = [[[ASIdentifierManager sharedManager] advertisingIdentifier]UUIDString];
//    [[YYCache shareCache] setObject:adid forKey:@"MYIDFA"];
//    NSString * myBundleID = [NSString getBundleID];
//    
//    [manager.requestSerializer setValue:adid forHTTPHeaderField:@"MYIDFA"];
//    [manager.requestSerializer setValue:myBundleID forHTTPHeaderField:@"channel"];
//    [manager.requestSerializer setValue:resultDictionary[@"md5Str"] forHTTPHeaderField:@"verify"];
//    [manager.requestSerializer setValue:resultDictionary[@"timestamp"] forHTTPHeaderField:@"timestamp"];
//    [manager.requestSerializer setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"version"];
//    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"platform"];
    NSLog(@"header=%@",manager.requestSerializer.HTTPRequestHeaders);
    
    //请求超时的限定
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //判断是否需要HTTPS SSL验证
    if (openHttpsSSL) {
        //[manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html", nil];
    //返回默认类型JSON
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return manager;
}
#pragma mark ---请求方式----
#pragma mark ---GET请求---
+(void)getNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters andHeader:(NSDictionary *)dict isCache:(BOOL)isCache succeed:(void (^)(id))succeed fail:(void (^)(NSString *))fail{
    [self requestType:NetworkRequestTypeGET url:urlString parameters:parameters andHeader:dict isCache:isCache cacheTime:0.0 succeed:succeed fail:fail];
}
+(void)getNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters isCache:(BOOL)isCache succeed:(void (^)(id))succeed fialed:(void (^)(NSString *))fail{
    [self requestType:NetworkRequestTypeGET url:urlString parameters:parameters isCache:isCache cacheTime:0.0 succeed:succeed fail:fail];
}
+(void)getNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters cacheTime:(float)time succeed:(void (^)(id))succeed failed:(void (^)(NSString *))fail{
    [self requestType:NetworkRequestTypeGET url:urlString parameters:parameters isCache:YES cacheTime:time succeed:succeed fail:fail];
}
#pragma mark ---POST请求---
+(void)postNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters isCache:(BOOL)isCache succeed:(void (^)(id))succeed fail:(void (^)(NSString *))fail{
    [self requestType:NetworkRequestTypePOST url:urlString parameters:parameters isCache:isCache cacheTime:0.0 succeed:succeed fail:fail];
}
#pragma mark -- POST请求 <含缓存时间> --
+ (void)postCacheRequestWithUrlString:(NSString *)urlString parameters:(id)parameters cacheTime:(float)time succeed:(void(^)(id data))succeed fail:(void(^)(NSString *error))fail{
    [self requestType:NetworkRequestTypePOST url:urlString parameters:parameters isCache:YES cacheTime:time succeed:succeed fail:fail];
}
#pragma mark --PUT请求--
+(void)putRequestWithUrlString:(NSString *)urlString parameters:(id)parameters succeed:(void (^)(id))succeed fail:(void (^)(NSString *))fail{
    [self requestType:NetworkRequestTypePUT url:urlString parameters:parameters isCache:NO cacheTime:0.0 succeed:succeed fail:fail];
}
#pragma mark --DELETE请求---
+(void)deleteRequestWithUrlString:(NSString *)urlString parameters:(id)parameters succeed:(void (^)(id))succeed fail:(void (^)(NSString *))fail{
    [self requestType:NetworkRequestTypeDELETE url:urlString parameters:parameters isCache:NO cacheTime:0.0 succeed:succeed fail:fail];
}

#pragma mark ----网络请求----
/**
 *  网络请求
 *
 *  @param type       请求类型，get请求/Post请求
 *  @param urlString  请求地址字符串
 *  @param parameters 请求参数
 *  @param isCache    是否缓存
 *  @param time       缓存时间
 *  @param succeed    请求成功回调
 *  @param fail       请求失败回调
 */
+(void)requestType:(NetworkRequestType)type url:(NSString *)urlString parameters:(id)parameters isCache:(BOOL)isCache cacheTime:(float)time succeed:(void(^)(id data))succeed fail:(void(^)(NSString *error))fail{
    [self requestType:type url:urlString parameters:parameters andHeader:nil isCache:isCache cacheTime:time succeed:succeed fail:fail];
}
/**
 *  网络请求
 *
 *  @param type       请求类型，get请求/Post请求
 *  @param urlString  请求地址字符串
 *  @param parameters 请求参数
 *  @param dict       请求头
 *  @param isCache    是否缓存
 *  @param time       缓存时间
 *  @param succeed    请求成功回调
 *  @param fail       请求失败回调
 */
+(void)requestType:(NetworkRequestType)type url:(NSString *)urlString parameters:(id)parameters andHeader:(NSDictionary *)dict isCache:(BOOL)isCache cacheTime:(float)time succeed:(void(^)(id data))succeed fail:(void(^)(NSString *error))fail{
    NSString * key = [self cacheKey:urlString params:parameters];
    //    // 判断网址是否加载过，如果没有加载过 在执行网络请求成功时，将请求时间和网址存入UserDefaults，value为时间date、Key为网址
    //    if ([CacheDefaults objectForKey:key]) {
    ////        // 如果UserDefaults存过网址，判断本地数据是否存在
    //        id cacheData = [self cahceResponseWithURL:urlString parameters:parameters];
    //        if (cacheData) {
    //            // 如果本地数据存在，读取本地数据，解析并返回给首页
    //            id dict = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    //            if (succeed) {
    //                succeed(dict);
    //            }
    //            // 判断存储时间，如果在规定直接之内，直接return，否则将继续执行网络请求
    //            if (time) {
    //                NSDate *oldDate = [CacheDefaults objectForKey:key];
    //                float cacheTime = [[NSString stringNowTimeDifferenceWith:[NSString stringWithDate:oldDate]] floatValue];
    //                if (cacheTime < time) {
    //                    return;
    //                }
    //            }
    //        }
    //    }
    //   }else{
    // 判断是否开启缓存
    
    if (isCache) {
        id cacheData = [self cacheResponseWithURL:urlString parameters:parameters];
        if (cacheData) {
            id dict = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
            if (succeed) {
                if ([StringWithFormat(dict[@"status"]) isEqualToString:@"1"]) {
                    succeed(dict);
                } else if ([StringWithFormat(dict[@"status"]) isEqualToString:@"-1"]){
                    //请求状态为-1时的操作 可以用来作为账号异地登录的判断
                } else {
                    if ([dict[@"message"] isKindOfClass:[NSNull class]]) {
                        fail(@"加载错误");
                    } else {
                        [KeyWindow makeToast:dict[@"message"]];
                        fail(dict[@"message"]);
                    }
                }
            }
        }
    }
    AFHTTPSessionManager * manager = [self getRequestManagerWithDic:parameters andHeader:dict];
    NSLog(@"\n\n请求路径%@ 和参数%@\n\n",urlString,parameters);
    if (type == NetworkRequestTypeGET) {
         //GET请求
        [manager GET:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功 加入缓存 解析数据
            [MBProgressHUD hideAllHUDsForView:[self activityViewController ].view animated:YES];
            if (isCache) {
                if (time > 0.0) {
                    [CacheDefaults setObject:[NSDate date] forKey:key];
                }
                [self cacheResponseObject:responseObject urlString:urlString parameters:parameters];
            }
            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求路径%@\n结果：%@",urlString,dict);
            if (succeed) {
                if ([StringWithFormat(dict[@"status"]) isEqualToString:@"1"]) {
                    succeed(dict);
                } else if ([StringWithFormat(dict[@"status"]) isEqualToString:@"-1"]) {
                    //请求状态为-1时的操作 可以用来作为账号异地登录的判断
                } else {
                    if ([SHNetworkingManager shareManager].isReturnResponseObject) {
                        succeed(dict);
                        [SHNetworkingManager shareManager].isReturnResponseObject = NO;
                    }
                    if ([dict[@"message"] isKindOfClass:[NSNull class]] || [dict isKindOfClass:[NSNull class]] || [StringWithFormat(dict) isEqualToString:@"(null)"]) {
                        [KeyWindow makeToast:@"请求失败"];
                        fail(@"加载失败");
                    } else {
                        if (![dict[@"message"] isEqualToString:@""]) {
                            [KeyWindow makeToast:dict[@"message"]];
                            fail(dict[@"message"]);
                        }
                    }
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            NSLog(@"错误信息：%@ \n描述%@",error,[error localizedDescription]);
            NSString * errorStr = [error localizedDescription];
            errorStr = ([self theNetworkLinkStatus] == 0) ? ErrorNotReachable : errorStr;
            if (fail) {
                [MainWindow makeToast:@"数据加载失败"];
                fail(errorStr);
            }
        }];
    } else if (type == NetworkRequestTypePOST) {
        [manager POST:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            //请求的进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功 加入缓存 解析数据
            if (isCache) {
                if (time > 0.0) {
                    [CacheDefaults setValue:responseObject forKey:key];
                }
                [self cacheResponseObject:responseObject urlString:urlString parameters:parameters];
            }
            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
            NSLog(@"\n\n打印总数据\n\n%@",dict);
            if (succeed) {
                if ([StringWithFormat(dict[@"status"]) isEqualToString:@"1"]) {
                    succeed(dict);
                } else if ([StringWithFormat(dict[@"status"]) isEqualToString:@"-1"]){
                    //请求状态为-1时的操作 可以用来作为账号异地登录的判断
                } else {
                    if ([dict[@"message"] isKindOfClass:[NSNull class]]) {
                        fail(@"加载错误");
                    } else {
                        [KeyWindow makeToast:dict[@"message"]];
                        fail(dict[@"message"]);
                    }
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"错误信息：%@ \n描述%@",error,[error localizedDescription]);
            NSString * errorStr = [error localizedDescription];
            errorStr = ([self theNetworkLinkStatus] == 0) ? ErrorNotReachable : errorStr;
            if (fail) {
                [MainWindow makeToast:@"数据加载失败"];
                fail(errorStr);
            }
        }];
    } else if (type == NetworkRequestTypePUT) {
        [manager PUT:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
            if ([StringWithFormat(dict[@"status"]) isEqualToString:@"1"]) {
                succeed(dict);
            } else if ([StringWithFormat(dict[@"status"]) isEqualToString:@"-1"]) {
                //请求状态为-1时的操作 可以用来作为账号异地登录的判断
            } else {
                if ([dict[@"message"] isKindOfClass:[NSNull class]]) {
                    fail(@"加载错误");
                } else {
                    if (![dict[@"message"] isEqualToString:@""]) {
                        [KeyWindow makeToast:dict[@"message"]];
                        fail(dict[@"message"]);
                    }
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString * errorStr = [error localizedDescription];
            errorStr = ([self theNetworkLinkStatus] == 0) ? ErrorNotReachable : errorStr;
            if (fail) {
                [MainWindow makeToast:@"数据加载失败"];
                fail(errorStr);
            }
        }];
    } else if (type == NetworkRequestTypeDELETE) {
        [manager DELETE:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
            if ([StringWithFormat(dict[@"status"]) isEqualToString:@"1"]) {
                succeed(dict);
            } else if ([StringWithFormat(dict[@"status"]) isEqualToString:@"-1"]) {
                //请求状态为-1时的操作 可以用来作为账号异地登录的判断
            } else {
                if ([dict[@"message"] isKindOfClass:[NSNull class]]) {
                    fail(@"加载错误");
                } else {
                    if (![dict[@"message"] isEqualToString:@""]) {
                        [KeyWindow makeToast:dict[@"message"]];
                        fail(dict[@"message"]);
                    }
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString * errorStr = [error localizedDescription];
            errorStr = ([self theNetworkLinkStatus] == 0) ? ErrorNotReachable : errorStr;
            if (fail) {
                [MainWindow makeToast:@"数据加载失败"];
                fail(errorStr);
            }
        }];
    }
}
#pragma mark -- 上传图片 --
+(void)uploadWithURLString:(NSString *)URLString parameters:(id)parameters model:(CLImageModel *)model progress:(void (^)(float, float))progress succeed:(void (^)(id))succeed fail:(void (^)(NSString *))fail{
    AFHTTPSessionManager * manager = [self getRequestManagerWithDic:parameters];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        NSData * imageData = UIImageJPEGRepresentation(model.image, 1);
        NSString * imageFileName = model.imageName;
        if (imageFileName == nil || ![imageFileName isKindOfClass:[NSString class]] || imageFileName.length == 0) {
             //如果文件名为空 以时间命名文件名
            imageFileName = [NSString imageFileName];
        }
        [formData appendPartWithFileData:imageData name:model.field fileName:imageFileName mimeType:[NSString imageFieldType]];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        float uploadKB = uploadProgress.completedUnitCount/1024.0;
        float grossKB = uploadProgress.totalUnitCount/1024.0;
        if (progress) {
            progress(uploadKB,grossKB);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * weatherDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"上传图片解析%@",weatherDic);
        if ([StringWithFormat(weatherDic[@"status"]) isEqualToString:@"1"]) {
            if (succeed) {
                succeed(weatherDic);
            }
        } else if ([StringWithFormat(weatherDic[@"status"]) isEqualToString:@"-1"]) {
            //请求状态为-1时的操作 可以用来作为账号异地登录的判断
        } else {
            [MainWindow makeToast:weatherDic[@"message"]];
            fail(@"网络请求错误");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString * errorStr = [error localizedDescription];
        errorStr = ([self theNetworkLinkStatus] == 0) ? ErrorNotReachable : errorStr;
        if (fail) {
            [MainWindow makeToast:@"数据加载失败"];
            fail(errorStr);
        }
    }];
}
#pragma mark --上传多张图片--
+(void)uploadWithURLString:(NSString *)URLString parameters:(id)parameters array:(NSArray *)array progress:(void (^)(float, float))progress succeed:(void (^)(id))succeed fail:(void (^)(NSString *))fail{
    AFHTTPSessionManager * manager = [self getRequestManagerWithDic:parameters];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    //判断需要上传的图片的数量 这里判断是否够三张图片
    if (array.count >= 3) {
        CLImageModel * modelOne = array[0];
        CLImageModel * modelTwo = array[1];
        CLImageModel * modelThree = array[2];
        [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
            NSData * imageDataOne = UIImageJPEGRepresentation(modelOne.image, 0.9);
            NSString * imageFileName = modelOne.imageName;
            NSData * imageDataTwo = UIImageJPEGRepresentation(modelTwo.image, 0.9);
            NSString * imageFileNameTwo = modelTwo.imageName;
            NSData * imageDataThree = UIImageJPEGRepresentation(modelThree.image, 0.9);
            NSString * imageFileNameThree = modelThree.imageName;
            if (imageFileName == nil || ![imageFileName isKindOfClass:[NSString class]] || imageFileName.length == 0) {
                //如果文件名为空 以时间命名文件名
                imageFileName = [NSString imageFileName];
                imageFileNameTwo = [NSString imageFileName];
                imageFileNameThree = [NSString imageFileName];
            }
            [formData appendPartWithFileData:imageDataOne name:modelOne.field fileName:imageFileName mimeType:[NSString imageFieldType]];
            [formData appendPartWithFileData:imageDataTwo name:modelTwo.field fileName:imageFileNameTwo mimeType:[NSString imageFieldType]];
            [formData appendPartWithFileData:imageDataThree name:modelThree.field fileName:imageFileNameThree mimeType:[NSString imageFieldType]];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            float uploadKB = uploadProgress.completedUnitCount/1024.0;
            float grossKB = uploadProgress.totalUnitCount/1024.0;
            NSLog(@"ddddddd%f",uploadKB);
            if (progress) {
                progress(uploadKB,grossKB);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary * weatherDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"上传多张图片解析%@",weatherDic);
            if ([StringWithFormat(weatherDic[@"status"]) isEqualToString:@"1"]) {
                if (succeed) {
                    succeed(weatherDic);
                }
            } else if ([StringWithFormat(weatherDic[@"status"]) isEqualToString:@"-1"]) {
                //请求状态为-1时的操作 可以用来作为账号异地登录的判断
            } else {
                [MainWindow makeToast:weatherDic[@"message"]];
                fail(@"网络请求错误");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSString * errorStr = [error localizedDescription];
            errorStr = ([self theNetworkLinkStatus] == 0) ? ErrorNotReachable : errorStr;
            if (fail) {
                [MainWindow makeToast:@"数据加载失败"];
                fail(errorStr);
            }
        }];
    }
}
#pragma makr ---缓存处理----
/**
 *  缓存文件夹下某地址的文件名，及UserDefaulets中的key值
 *
 *  @param urlString 请求地址
 *  @param params    请求参数
 *
 *  @return 返回一个MD5加密后的字符串
 */
+(NSString *)cacheKey:(NSString *)urlString params:(id)params{
    NSString * absoluteURL = [NSString generateGETAbsoluteURL:urlString params:params];
    NSString * key = [NSString networkingUrlString_md5:absoluteURL];
    return key;
}
/**
 *  读取缓存
 *
 *  @param url    请求地址
 *  @param params 拼接的参数
 *
 *  @return 数据data
 */
+(id)cacheResponseWithURL:(NSString *)url parameters:(id)params{
    id cacheData = nil;
    if (url) {
         //读取本地的缓存
        NSString * key = [self cacheKey:url params:params];
        NSString * path = [cachePath() stringByAppendingPathComponent:key];
        NSData * data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
        }
    }
    return cacheData;
}
/**
 *  添加缓存
 *
 *  @param responseObject 请求成功数据
 *  @param urlString      请求地址
 *  @param params         拼接的参数
 */
+ (void)cacheResponseObject:(id)responseObject urlString:(NSString *)urlString parameters:(id)params {
    NSString * key = [self cacheKey:urlString params:params];
    NSString * path = [cachePath() stringByAppendingPathComponent:key];
    [self deleteFileWithPath:path];
    BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:responseObject attributes:nil];
    if (isOk) {
        NetworkLog(@"cache file success: %@\n",path);
    } else {
        NetworkLog(@"cache file error:%@\n",path);
    }
}
//清空缓存
+(void)cleraCaches{
    //删除CacheDefaults中的存放时间和地址的键值对，并删除cache文件夹
    NSString * directorPath = cachePath();
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:directorPath]) {
        NSEnumerator * childFilesEnumerator = [[manager subpathsAtPath:directorPath]objectEnumerator];
        NSString * key;
        while ((key = [childFilesEnumerator nextObject])!= nil) {
            NetworkLog(@"remove_key == %@",key);
            [CacheDefaults removeObjectForKey:key];
        }
    }
    if ([manager fileExistsAtPath:directorPath isDirectory:nil]) {
        NSError * error = nil;
        [manager removeItemAtPath:directorPath error:&error];
        if (error) {
            NetworkLog(@"clear caches error:%@",error);
        } else {
            NetworkLog(@"clear caches success");
        }
    }
}
//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少KB
+ (float)getCacheFileSize{
    NSString *folderPath = cachePath();
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/1024.0;
}

/**
 *  判断文件是否已经存在，若存在删除
 *
 *  @param path 文件路径
 */
+ (void)deleteFileWithPath:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exist = [fm fileExistsAtPath:url.path];
    NSError *err;
    if (exist) {
        [fm removeItemAtURL:url error:&err];
        NetworkLog(@"file deleted success");
        if (err) {
            NetworkLog(@"file remove error, %@", err.localizedDescription );
        }
    } else {
        NetworkLog(@"no file by that name");
    }
}
#pragma mark - 查找当前活动窗口
+(UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}

@end
