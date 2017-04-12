//
//  SHNetworking.h
//  MyFramework
//
//  Created by lalala on 2017/4/12.
//  Copyright © 2017年 lsh. All rights reserved.
//

#ifndef SHNetworking_h
#define SHNetworking_h

/*
 基于AFNetworking3.1.0二次封装
 */
#import "AFNetworking.h"

#import "CLImageModel.h"
#import "NSString+CLTools.h"

//重写NSLog,Debug模式下打印日志和当前行数
#ifdef DEBUG
#define NetworkLog(s, ... ) NSLog( @"[%@ line:%d]=> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define NetworkLog(s, ... )
#endif

#define CacheDefaults [NSUserDefaults standardUserDefaults]

// 网络缓存文件夹名
#define NetworkCache @"NetworkCache"

#define ErrorNotReachable @"网络不给力"

#endif /* SHNetworking_h */
