//
//  UMLoginTool.h
//  MyFramework
//
//  Created by 吕山虎 on 2017/4/23.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

@interface UMLoginModel : NSObject
@property(nonatomic,copy) NSString * nickName;
@property(nonatomic,copy) NSString * sex;
@property(nonatomic,copy) NSString * avatar;
@property(nonatomic,copy) NSString * uid;
@property(nonatomic,copy) NSString * tokenType;
@property(nonatomic,copy) NSString * accessToken;
@property(nonatomic,copy) NSString * openId;
@property(nonatomic,copy) NSString * city;
@property(nonatomic,copy) NSString * gender;
@property(nonatomic,copy) NSString * province;
@property(nonatomic,copy) NSString * unionId;
@end
@interface UMLoginTool : NSObject

+(void)weixinLoginController:(UIViewController *)controllrer success:(void (^)(id success))success failed:(void (^)(id failed))failed;

+(void)QQLoginController:(UIViewController *)controllrer success:(void (^)(id success))success failed:(void (^)(id failed))failed;

+(void)SinaLoginController:(UIViewController *)controllrer success:(void (^)(id success))success failed:(void (^)(id failed))failed;
@end
