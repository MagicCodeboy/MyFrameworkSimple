//
//  YYCache+Cache.m
//  jinshanStrmear
//
//  Created by Mac Pro on 16/6/12.
//  Copyright © 2016年 王森. All rights reserved.
//

#import "YYCache+Cache.h"
NSString * const CacheName = @"yyCacheMenuPanth";

@implementation YYCache (Cache)
+(YYCache *)shareCache
{
    static YYCache*cache=nil;
    NSString *mypanth=  [NSString stringWithFormat:@"%@/Preferences/mydata",[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       cache = [[YYCache alloc] initWithPath:mypanth];
       
    });
    return cache;
    
}

@end
