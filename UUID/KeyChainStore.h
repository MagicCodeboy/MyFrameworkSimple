//
//  KeyChainStore.h
//  jinshanStrmear
//
//  Created by panhongliu on 16/7/30.
//  Copyright © 2016年 王森. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
