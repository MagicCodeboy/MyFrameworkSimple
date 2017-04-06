
//
//  SHPlusButtonSubClass.m
//  MyFramework
//
//  Created by lalala on 2017/4/6.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "SHPlusButtonSubClass.h"
#import "CYLTabBarController.h"

@interface SHPlusButtonSubClass()<UIActionSheetDelegate>{
    CGFloat _buttonImageHeight;
}
@end
@implementation SHPlusButtonSubClass

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}
//上下结构的button
-(void)layoutSubviews{
    [super layoutSubviews];
    //控件大小 间距大小
    // 注意：一定要根据项目中的图片去调整下面的0.7和0.9，Demo之所以这么设置，因为demo中的 plusButton 的 icon 不是正方形。
    CGFloat const imageViewEdgeWidth = self.bounds.size.width * 0.7;
    CGFloat const imageViewEdgeHeight = imageViewEdgeWidth * 0.9;
    
    CGFloat const centerOfView = self.bounds.size.width * 0.5;
    CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
    CGFloat const verticalMargin = (self.bounds.size.height - labelLineHeight - imageViewEdgeHeight) * 0.5;
    
    // imageView 和 titleLabel 中心的 Y 值
    CGFloat const centerOfImageView  = verticalMargin + imageViewEdgeHeight * 0.5;
    CGFloat const centerOfTitleLabel = imageViewEdgeHeight  + verticalMargin * 2 + labelLineHeight * 0.5 + 5;
    
    //imageView position 位置
    self.imageView.bounds = CGRectMake(0, 0, imageViewEdgeWidth, imageViewEdgeHeight);
    self.imageView.center = CGPointMake(centerOfView, centerOfImageView);
    
    //title position 位置
    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, labelLineHeight);
    self.titleLabel.center = CGPointMake(centerOfView, centerOfTitleLabel);
}
#pragma mark - CYLPlusButtonSubclassing Methods
//突出的圆形的带文字的中间的按钮
//+(id)plusButton{
//    SHPlusButtonSubClass * button = [[SHPlusButtonSubClass alloc]init];
//    UIImage * buttonImage = [UIImage imageNamed:@"post_normal"];
//    [button setImage:buttonImage forState:UIControlStateNormal];
//    [button setTitle:@"直播" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    
//    [button setTitle:@"选中" forState:UIControlStateSelected];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
//    
//    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
//    [button sizeToFit];
//    
//    [button addTarget:button action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    return button;
//}
/*
 *
 Create a custom UIButton without title and add it to the center of our tab bar
 *
 */
//中间不突出的按钮不带文字
+ (instancetype)plusButton
{
    
    UIImage *buttonImage = [UIImage imageNamed:@"zhiboanniu"];
    UIImage *highlightImage = [UIImage imageNamed:@"zhiboanniu"];
//    UIImage *iconImage = [UIImage imageNamed:@"tabbar_compose_icon_add"];
//    UIImage *highlightIconImage = [UIImage imageNamed:@"tabbar_compose_icon_add"];
    
    SHPlusButtonSubClass *button = [SHPlusButtonSubClass buttonWithType:UIButtonTypeCustom];
    
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//    [button setImage:iconImage forState:UIControlStateNormal];
//    [button setImage:highlightIconImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:button action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
//突出的中间按钮不带文字
//+ (id)plusButton
//{
//
//    UIImage *buttonImage = [UIImage imageNamed:@"hood.png"];
//    UIImage *highlightImage = [UIImage imageNamed:@"hood-selected.png"];
//
//    SHPlusButtonSubClass* button = [SHPlusButtonSubClass buttonWithType:UIButtonTypeCustom];
//
//    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
//    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
//    [button addTarget:button action:@selector(plusButtonClick) forControlEvents:UIControlEventTouchUpInside];
//
//    return button;
//}
//中间按钮的点击事件
-(void)plusButtonClick{
    CYLTabBarController * tabbarController = [self cyl_tabBarController];
    UIViewController * viewController = tabbarController.selectedViewController;
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"点击中间的按钮了", nil];
    [actionSheet showInView:viewController.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex = %@", @(buttonIndex));
}
#pragma mark - CYLPlusButtonSubclassing
//这段代码实现点击中间的按钮同其他的tabbar按钮的点击效果
//+ (UIViewController *)plusChildViewController {
//    UIViewController *plusChildViewController = [[UIViewController alloc] init];
//    plusChildViewController.view.backgroundColor = [UIColor redColor];
//    plusChildViewController.navigationItem.title = @"PlusChildViewController";
//    UIViewController *plusChildNavigationController = [[UINavigationController alloc]
//                                                   initWithRootViewController:plusChildViewController];
//    return plusChildNavigationController;
//}
//
//+ (NSUInteger)indexOfPlusButtonInTabBar {
//    return 4;
//}
//
//+ (BOOL)shouldSelectPlusChildViewController {
//    BOOL isSelected = CYLExternPlusButton.selected;
//    if (isSelected) {
//        NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), @"PlusButton is selected");
//    } else {
//        NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), @"PlusButton is not selected");
//    }
//    return YES;
//}
//若中间的按钮不需要突出 隐藏这段代码
//+ (CGFloat)multiplierOfTabBarHeight:(CGFloat)tabBarHeight {
//    return  0.3;
//}
//
//+ (CGFloat)constantOfPlusButtonCenterYOffsetForTabBarHeight:(CGFloat)tabBarHeight {
//    return  -10;
//}
@end
