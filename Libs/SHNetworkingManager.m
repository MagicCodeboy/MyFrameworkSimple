//
//  SHNetworkingManager.m
//  MyFramework
//
//  Created by lalala on 2017/4/12.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "SHNetworkingManager.h"
#import "NSString+Cache.h"

/**
 *  是否开启https SSL 验证
 *
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
+(void)getNetworkRequestWithUrlString:(NSString *)urlString parameters:(id)parameters andHeader:(NSDictionary *)dict isCache:(BOOL)isCache succeed:(void (^)(id))succeed fail:(void (^)(NSString *))fail{
    
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

@end
