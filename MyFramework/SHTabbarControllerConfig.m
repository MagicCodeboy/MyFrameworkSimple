//
//  SHTabbarControllerConfig.m
//  MyFramework
//
//  Created by lalala on 2017/4/6.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "SHTabbarControllerConfig.h"

@interface SHBaseNavigationController : UINavigationController
@end
@implementation SHBaseNavigationController
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
#import "TheFirstViewController.h"
#import "TheSecondViewController.h"
#import "TheThirdViewController.h"
#import "PersonViewController.h"

@interface SHTabbarControllerConfig()
@property(nonatomic,readwrite,strong) CYLTabBarController * tabbarController;
@end
@implementation SHTabbarControllerConfig
-(CYLTabBarController *)tabbarController{
    if (_tabbarController == nil) {
        CYLTabBarController * tabbarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                                                    tabBarItemsAttributes:self.tabBarItemsAttributesForController];
        [self customizeTabBarAppearance:tabbarController];
        _tabbarController = tabbarController;
    }
    return _tabbarController;
}
-(NSArray *)viewControllers{
    TheFirstViewController * theFirstViewController = [[TheFirstViewController alloc]init];
    UIViewController * firstNavigationController = [[SHBaseNavigationController alloc]initWithRootViewController:theFirstViewController];
    TheSecondViewController * theSecondViewController = [[TheSecondViewController alloc]init];
    UIViewController * secondNavigationController = [[SHBaseNavigationController alloc]initWithRootViewController:theSecondViewController];
    TheThirdViewController * theThirdViewController = [[TheThirdViewController alloc]init];
    UIViewController * thirdNavigationController = [[SHBaseNavigationController alloc]initWithRootViewController:theThirdViewController];
    PersonViewController * personViewController = [[PersonViewController alloc]init];
    UIViewController * persontNavigationController = [[SHBaseNavigationController alloc]initWithRootViewController:personViewController];
    NSArray * viewControllers = @[
                                  firstNavigationController,
                                  secondNavigationController,
                                  thirdNavigationController,
                                  persontNavigationController
                                  ];
    
    return viewControllers;
}
-(NSArray *)tabBarItemsAttributesForController{
    NSDictionary * firstTabbarItemAttributes = @{
                                                  CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage:@"home_normal",
                                                 CYLTabBarItemSelectedImage:@"home_highlight"
                                                 };
    NSDictionary *secondTabBarItemsAttributes = @{
                                                CYLTabBarItemTitle : @"第二个",
                                                  CYLTabBarItemImage : @"mycity_normal",
                                                  CYLTabBarItemSelectedImage : @"mycity_highlight",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                CYLTabBarItemTitle : @"第三个",
                                                 CYLTabBarItemImage : @"message_normal",
                                                 CYLTabBarItemSelectedImage : @"message_highlight",
                                                 };
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"我的",
                                                  CYLTabBarItemImage : @"account_normal",
                                                  CYLTabBarItemSelectedImage : @"account_highlight"
                                                  };
    NSArray *tabBarItemsAttributes = @[
                                       firstTabbarItemAttributes,
                                       secondTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes,
                                       fourthTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}
#pragma mark -- tabbar的更多的设置
-(void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController{
#warning CUSTOMIZE YOUR TABBAR APPEARANCE
    //自定义tabbar的高度
    tabBarController.tabBarHeight = 49.f;
    //普通状态下的文字
    NSMutableDictionary * normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    //设置选中状态下的文字
    NSMutableDictionary * selectAttrs = [NSMutableDictionary dictionary];
    selectAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    //设置文字的属性
    UITabBarItem * tabbarItem = [UITabBarItem appearance];
    [tabbarItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabbarItem setTitleTextAttributes:selectAttrs forState:UIControlStateSelected];
    //tabbaritem 选中后的背景颜色
//    [self customizeTabBarSelectionIndicatorImage];
    //支持横竖屏的方法
//    [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    //设置tabbar阴影的图片
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    //设置背景图片
    UITabBar * tabbarAppearance = [UITabBar appearance];
    [tabbarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    //去除tabbar自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[[UIImage alloc]init]];
}
- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate {
    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
            NSLog(@"Landscape Left or Right !");
        } else if (orientation == UIDeviceOrientationPortrait) {
            NSLog(@"Landscape portrait!");
        }
        [self customizeTabBarSelectionIndicatorImage];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:CYLTabBarItemWidthDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:deviceOrientationDidChangeBlock];
}
-(void)customizeTabBarSelectionIndicatorImage{
    UITabBarController * tabbarController = [self cyl_tabBarController]?:[[UITabBarController alloc]init];
    CGFloat tabbarHeight = tabbarController.tabBar.frame.size.height;
    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabbarHeight);
    UITabBar * tabbar = [self cyl_tabBarController].tabBar?: [UITabBar appearance];
    [tabbar setSelectionIndicatorImage:
     [[self class] imageWithColor:[UIColor purpleColor]
                             size:selectionIndicatorImageSize]];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
