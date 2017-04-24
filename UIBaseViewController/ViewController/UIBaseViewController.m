//
//  UIBaseViewController.m
//  MyFramework
//
//  Created by lalala on 2017/4/6.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "UIBaseViewController.h"
#import "UIViewController+WRBNavigationItemExtension.h"
#import "MBProgressHUD+LJ.h"
@interface UIBaseViewController ()

@end

@implementation UIBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //设置导航条背景颜色
    //[self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
-(void)setNavgationTitle:(NSString *)title{
    [self setTextTitleViewWithFrame:CGRectMake(0, 0, 60, 20) title:title fontSize:18];
}
-(void)setViewbackGroundColor:(UIColor *)color{
    if (color == nil) {
        color = UIColorFromRGB(0xf5f5f5);
    }
    self.view.backgroundColor = color;
}
-(void)addLeftBackBtn:(NSString *)btnImage frame:(CGRect)frame{
    __weak typeof(self) weakSelf = self;
    NSString * btnName;
    if (btnName == nil) {
         btnName = @"tabbar_discover_os7";
    } else {
        btnName = btnImage;
    }
    [self setLeftImageBarButtonItemWithFrame:frame image:btnName selectImage:nil action:^(WRBButton *button) {
        [weakSelf backBtn:button];
    }];
}
-(void)addBackBtn{
    __weak typeof(self) weakSelf = self;
    [self setLeftImageBarButtonItemWithFrame:CGRectMake(0, 0, 30, 30) image:@"tabbar_discover_os7" selectImage:nil action:^(WRBButton *button) {
        [weakSelf backBtn:button];
    }];
}
-(void)backBtn:(WRBButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addRightBtnWithframe:(CGRect)frame withImage:(NSString *)btnImg isHidden:(BOOL)isHidden{
    __weak typeof(self) weakSelf = self;
    NSString *btnName;
    if (btnImg==nil) {
        btnName=@"tabbar_discover_os7";
    } else {
        btnName=btnImg;
    }
    [self setRightImageBarButtonItemWithFrame:frame image:btnName selectImage:nil ishidden:isHidden action:^(WRBButton *button) {
        [weakSelf BtnRight:button];
    }];
}
-(void)addRightBtnWithFrame:(CGRect)frame withTitleName:(NSString *)name color:(UIColor *)titleColor{
    __weak typeof(self) weakSelf = self;
    [self setRightTextBarButtonItemWithFrame:frame title:name titleColor:titleColor backImage:nil selectBackImage:nil action:^(WRBButton *button) {
        [weakSelf BtnRight:button];
    }];
}
-(void)BtnRight:(WRBButton*)button{
    NSLog(@"我是右边的按钮，点我干哈");
}
- (void)addProgressHUD{
    [MBProgressHUD showMessage:@"正在加载"];
}
-(void)showWithStatus:(NSString *)statusLable{
    if (statusLable == nil) {
        [MBProgressHUD showMessage:@"正在加载"];
    } else {
        [MBProgressHUD showMessage:statusLable];
    }
}
-(void)removeStatuslable{
    [MBProgressHUD hideHUD];
}
-(void)showSuccess:(NSString *)success{
    if (success == nil) {
        [MBProgressHUD showSuccess:@"正在加载"];
    } else {
        [MBProgressHUD showSuccess:success];
    }
}
-(void)showFailed:(NSString *)failed{
    if (failed == nil) {
        [MBProgressHUD showError:@"加载失败"];
    } else {
        [MBProgressHUD showError:failed];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
