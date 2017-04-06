//
//  MBProgressHUD+LJ.m
//  lntuApp
//
//  Created by 李杰 on 14-9-18.
//  Copyright (c) 2014年 PUPBOSS. All rights reserved.
//

#import "MBProgressHUD+LJ.h"
@implementation MBProgressHUD (LJ)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil)
        view = [[UIApplication sharedApplication].windows lastObject];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 0.9秒之后再消失
    [hud hide:YES afterDelay:0.9];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view {
    
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    
    if (view == nil)
        
        view = [[UIApplication sharedApplication].windows lastObject];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    
    
    return hud;
}

+ (void)setGifWithMBProgress:(NSString *)string toView:(UIView *)view
{
    
   [self showMessage:string toView:view];

//    以前的动画
//    //提示成功
//    MBProgressHUD *newhud = [[MBProgressHUD alloc] initWithView:view];
//    newhud.userInteractionEnabled = NO;
//    newhud.color = [UIColor clearColor];//这儿表示无背景
//    /*!
//     *  @author WS, 15-11-26 15:11:52
//     *
//     *  是否显示遮罩
//     */
//    newhud.dimBackground = NO;
//    [view addSubview:newhud];
//    newhud.labelText = string;
//    /*!
//     *  @author WS, 15-11-26 15:11:05
//     *
//     *  字体颜色
//     */
//    newhud.labelColor=UIColorFromRGB(0x53cac3);
//    newhud.labelFont=[UIFont systemFontOfSize:14];
//    
//    newhud.mode = MBProgressHUDModeCustomView;
//    
//    /*!
//     *  @author WS, 15-11-26 15:11:32
//     *
//     *  如果修改动画图片就在这里修改
//     */
//    UIImage *images=[UIImage sd_animatedGIFNamed:@"pika"];
//    
//    newhud.customView = [[UIImageView alloc] initWithImage:images];
//    [newhud show:YES];
    
}



+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view];
}
@end
