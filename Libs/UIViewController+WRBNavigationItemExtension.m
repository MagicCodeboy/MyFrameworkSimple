//
//  UIViewController+WRBNavigationItemExtension.m
//  WeChat
//
//  Created by lsh on 15/8/24.
//  Copyright (c) 2015年 lsh. All rights reserved.
//

#import "UIViewController+WRBNavigationItemExtension.h"
#import "WRBButton.h"

@implementation UIViewController (WRBNavigationItemExtension)

/** 设置导航条背景 */
-(void)setNavigationBarBackgroundImage:(NSString *)image
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:image] forBarMetrics:UIBarMetricsDefault];
}

/** 设置导航条中间标题 */
/** 文字标题 */
-(id)setTextTitleViewWithFrame:(CGRect)frame
                         title:(NSString *)titile
                      fontSize:(int)size
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = titile;
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor blackColor];
    
    
        label.font = [UIFont systemFontOfSize:18];
    
    self.navigationItem.titleView = label;
    return label;
}
/** 图片标题 */
-(id)setImageTitleViewWithFrame:(CGRect)frame
                          image:(NSString *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:image];
    imageView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = imageView;
    return imageView;
}
/** 选项卡标题 */
-(id)setSegmentTitleViewWithItems:(NSArray *)items
{
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:items];
    segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segment;
    return segment;
}
/** 加入自定义标题 */

/** 设置导航条左边按钮 */
/** 既有图标又有文字的左边按钮 */
-(id)setLeftBarButtonItemWithFrame:(CGRect)frame
                             title:(NSString *)titile
                        titleColor:(UIColor *)titleColor
                             image:(NSString *)image
                       imageInsets:(UIEdgeInsets)insets
                         backImage:(NSString *)backImage
                   selectBackImage:(NSString *)selectBackImage
                            action:(void(^)(WRBButton *button))action
{
    
    
    WRBButton *leftButton = [WRBButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = frame;
    [leftButton setTitle:titile forState:UIControlStateNormal];
    [leftButton setTitleColor:titleColor forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets = insets;
    [leftButton setBackgroundImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:selectBackImage] forState:UIControlStateHighlighted];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    leftButton.action = action;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    return leftButton;
}
/** 只有图片的左边按钮 */
-(id)setLeftImageBarButtonItemWithFrame:(CGRect)frame
                                  image:(NSString *)image
                            selectImage:(NSString *)selectImage
                                 action:(void(^)(WRBButton *button))action
{
    WRBButton *leftButton = [WRBButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = frame;
    [leftButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];
    leftButton.action = action;
//    leftButton.backgroundColor=[UIColor redColor];

    
    //    leftButton.imageEdgeInsets = insets;
    //解决系统默认占位
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //iOS7设置-16，iOS6设置-6
    spacer.width = -11;
    
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItems=@[spacer,leftBarButtonItem];
    return leftButton;
}

/** 只有文字的左边按钮 */
-(id)setLeftTextBarButtonItemWithFrame:(CGRect)frame
                                 title:(NSString *)titile
                            titleColor:(UIColor *)titleColor
                             backImage:(NSString *)backImage
                       selectBackImage:(NSString *)selectBackImage
                                action:(void(^)(WRBButton *button))action
{
    WRBButton *leftButton = [WRBButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = frame;
    
    [leftButton setTitle:titile forState:UIControlStateNormal];
    [leftButton setTitleColor:titleColor forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [leftButton setBackgroundImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:selectBackImage] forState:UIControlStateHighlighted];
    leftButton.action = action;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    return leftButton;
}


/** 设置导航条右边按钮 */
/** 既有图标又有文字的右边按钮 */
-(id)setRightBarButtonItemWithFrame:(CGRect)frame
                              title:(NSString *)titile
                         titleColor:(UIColor *)titleColor
                              image:(NSString *)image
                        imageInsets:(UIEdgeInsets)insets
                          backImage:(NSString *)backImage
                    selectBackImage:(NSString *)selectBackImage
                             action:(void(^)(WRBButton *button))action
{
    WRBButton *rightButton = [WRBButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = frame;
    [rightButton setTitle:titile forState:UIControlStateNormal];
    [rightButton setTitleColor:titleColor forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets = insets;
    [rightButton setBackgroundImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:selectBackImage] forState:UIControlStateHighlighted];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    rightButton.action = action;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    return rightButton;
}

/** 只有图片的右边按钮 */
-(id)setRightImageBarButtonItemWithFrame:(CGRect)frame
                                   image:(NSString *)image
                             selectImage:(NSString *)selectImage
                                 ishidden:(BOOL)hidden action:(void(^)(WRBButton *button))action 
{
    WRBButton *rightButton = [WRBButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = frame;
    [rightButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];
    rightButton.action = action;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIView *badgeView=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rightButton.frame)-3, rightButton.frame.origin.y+3, 9, 9)];
    badgeView.backgroundColor=[UIColor redColor];
    badgeView.layer.cornerRadius=badgeView.frame.size.height/2;
    badgeView.layer.masksToBounds=YES;
    badgeView.hidden=hidden;
    [rightButton addSubview:badgeView];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    return rightButton;
}

/** 只有文字的右边按钮 */
-(id)setRightTextBarButtonItemWithFrame:(CGRect)frame
                                  title:(NSString *)titile
                             titleColor:(UIColor *)titleColor
                              backImage:(NSString *)backImage
                        selectBackImage:(NSString *)selectBackImage
                                 action:(void(^)(WRBButton *button))action
{
    WRBButton *rightButton = [WRBButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = frame;
    [rightButton setTitle:titile forState:UIControlStateNormal];
    [rightButton setTitleColor:titleColor forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setBackgroundImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:selectBackImage] forState:UIControlStateHighlighted];
    rightButton.titleLabel.textAlignment=NSTextAlignmentRight;
    rightButton.action = action;
    //    leftButton.imageEdgeInsets = insets;
    //解决系统默认占位
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //iOS7设置-16，iOS6设置-6
    spacer.width = -6;

    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItems = @[spacer,rightBarButtonItem];
    return rightButton;
}

@end
