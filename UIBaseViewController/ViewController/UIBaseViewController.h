//
//  UIBaseViewController.h
//  MyFramework
//
//  Created by lalala on 2017/4/6.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRBButton.h"
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface UIBaseViewController : UIViewController
//设置头部的标题
-(void)setNavgationTitle:(NSString *)title;
//设置背景颜色
-(void)setViewbackGroundColor:(UIColor *)color;
//添加左侧的按钮
-(void)addLeftBackBtn:(NSString *)btnImage frame:(CGRect)frame;
//添加返回按钮
-(void)addBackBtn;
//返回按钮的点击事件
-(void)backBtn:(WRBButton *)button;
////添加导航栏的右侧的按钮
-(void)addRightBtnWithframe:(CGRect)frame withImage:(NSString *)btnImg isHidden:(BOOL)isHidden;
//添加导航栏的右侧的只有文字的按钮
-(void)addRightBtnWithFrame:(CGRect)frame withTitleName:(NSString *)name color:(UIColor *)titleColor;
//右侧按钮的点击事件
-(void)BtnRight:(WRBButton*)button;
//添加默认提示框
- (void)addProgressHUD;
/**
 *  显示加载框
 *
 *  @param statusLable 显示加载的文字 不写为空
 */
-(void)showWithStatus:(NSString *)statusLable;
//删除提示文字
-(void)removeStatuslable;
/**
 *  显示成功的提示框
 *
 *  @param success 提示文字
 */
-(void)showSuccess:(NSString *)success;
/**
 *  网络请求失败提示框
 *
 *  @param failed 请求失败的提示文字
 */
-(void)showFailed:(NSString *)failed;
@end
