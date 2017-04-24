//
//  AppDelegate.m
//  MyFramework
//
//  Created by lalala on 2017/4/6.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "AppDelegate.h"
#import "SHTabbarControllerConfig.h"
#import "SHPlusButtonSubClass.h"
#import "Login_RegisViewController.h"

#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

+(AppDelegate *)shareDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setUMSociaLogin];
   
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self goLogin];
    
    MYLog(@"添加pch文件成功了");
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)goLogin{
    Login_RegisViewController * regisViewController = [[Login_RegisViewController alloc]init];
    self.window.rootViewController = regisViewController;
}
-(void)goMain{
    
    //移除uiwindow
    [self.window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.window.rootViewController = nil;
    [self.window removeFromSuperview];
    
    [self.window makeKeyAndVisible];
    
    [SHPlusButtonSubClass registerPlusButton];
    SHTabbarControllerConfig * tabbarControllerConfig = [[SHTabbarControllerConfig alloc]init];
    self.window.rootViewController = tabbarControllerConfig.tabbarController;
}
-(void)setUMSociaLogin{
    [UMSocialData setAppKey:@"58fb6b0e1061d26845000e03"];
    //是否打开我们SDK在控制台的输出后能看到相应的错误码
    [UMSocialData openLog:YES];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"930133636"
                                              secret:@"06eff32a7cb5628415e255bd776ee83d"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx521aaf688057bcf1" appSecret:@"c5b7f9a6b10aa7bde0c3380df26d77a5" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"1105320395" appKey:@"KEYry9YWPR4ObSojYvk" url:@"http://www.umeng.com/social"];
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [UMSocialSnsService handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"MyFramework"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
