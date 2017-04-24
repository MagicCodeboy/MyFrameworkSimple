//
//  UMLoginTool.m
//  MyFramework
//
//  Created by 吕山虎 on 2017/4/23.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "UMLoginTool.h"
#import "UUID.h"
#import "WeiboUser.h"
@implementation UMLoginTool
+(void)weixinLoginController:(UIViewController *)controllrer success:(void (^)(id))success failed:(void (^)(id))failed{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(controllrer,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            if (snsAccount.userName == nil) {
                [dic setObject:@"" forKey:@"nickName"];
            }
            else{
                [dic setObject:snsAccount.userName forKey:@"nickName"];
                
            }
            if (snsAccount.iconURL == nil) {
                [dic setObject:@"" forKey:@"avatar"];
            }
            else{
                [dic setObject:snsAccount.iconURL forKey:@"avatar"];
                
            }
            
            
            if ([(response.thirdPlatformUserProfile[@"sex"])isEqualToString:@"0"]) {
                [dic setObject:@"0" forKey:@"sex"];
                
            }
            else if ([(response.thirdPlatformUserProfile[@"sex"])isEqualToString:@"1"])
            {
                [dic setObject:@"1" forKey:@"sex"];
                
            }
            else{
                [dic setObject:@"-1" forKey:@"sex"];
                
            }
            
            NSString * uuid= [UUID getUUID];
            
            [dic setObject:uuid forKey:@"deviceId"];
            
            
            [dic setObject:@"" forKey:@"uid"];
            [dic setObject:@"2" forKey:@"tokenType"];
            [dic setObject:snsAccount.accessToken forKey:@"accessToken"];
            [dic setObject:snsAccount.usid forKey:@"openId"];
            [dic setObject:snsAccount.unionId forKey:@"unionId"];
            NSLog(@"微信字典：%@",dic);
            
            success(dic);
        }
    });
}
+(void)SinaLoginController:(UIViewController *)controllrer success:(void (^)(id))success failed:(void (^)(id))failed{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(controllrer,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            NSMutableDictionary  *dic=@{}.mutableCopy;
            [dic setObject:snsAccount.iconURL	 forKey:@"avatar"];
            NSString *sex=@"-1";
            WeiboUser *weiboUsers=response.thirdPlatformUserProfile;
            
            NSLog(@"======%@",weiboUsers.gender);
            
            
            if ([weiboUsers.gender isEqualToString:@"f"]) {
                sex=@"0";
            }
            else if ([weiboUsers.gender isEqualToString:@"m"])
            {
                sex=@"1";
            }
            else
            {
                sex=@"-1";
            }
            
            
            NSString * uuid= [UUID getUUID];
            
            [dic setObject:uuid forKey:@"deviceId"];
            
            [dic setObject:sex forKey:@"sex"];
            [dic setObject:@"" forKey:@"uid"];
            [dic setObject:@"1" forKey:@"tokenType"];
            [dic setObject:snsAccount.usid forKey:@"accessToken"];
            if (snsAccount.userName == nil) {
                [dic setObject:@"" forKey:@"nickName"];
            }
            
            else{
                [dic setObject:snsAccount.userName forKey:@"nickName"];
            }
            
            [dic setObject:snsAccount.usid forKey:@"openId"];
            NSLog(@"QQ字典：%@",dic);
            
            success(dic);
        } else {
            failed(@"授权失败");
        }
    });
}
+(void)QQLoginController:(UIViewController *)controllrer success:(void (^)(id))success failed:(void (^)(id))failed{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(controllrer,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            NSMutableDictionary  *dic=@{}.mutableCopy;
            [dic setObject:snsAccount.iconURL	 forKey:@"avatar"];
            NSString *sex=nil;
            
            
            
            if ([response.thirdPlatformUserProfile[@"gender"] isEqualToString:@"男"]) {
                sex=@"1";
            }
            
            
            else if ([response.thirdPlatformUserProfile[@"gender"] isEqualToString:@"女"])
                
            {
                sex=@"0";
                
            }
            
            else
            {
                sex=@"-1";
                
            }
            NSString * uuid= [UUID getUUID];
            
            [dic setObject:uuid forKey:@"deviceId"];
            
            [dic setObject:sex forKey:@"sex"];
            [dic setObject:@"" forKey:@"uid"];
            [dic setObject:@"3" forKey:@"tokenType"];
            [dic setObject:snsAccount.usid forKey:@"accessToken"];
            if (response.thirdPlatformUserProfile[@"nickname"] == nil) {
                [dic setObject:@"" forKey:@"nickName"];
            }
            
            else{
                [dic setObject:response.thirdPlatformUserProfile[@"nickname"] forKey:@"nickName"];
            }
            
            [dic setObject:snsAccount.usid forKey:@"openId"];
            NSLog(@"QQ字典：%@",dic);
            
            success(dic);

        } else {
            failed(@"授权失败");
        }
    });
}
@end
