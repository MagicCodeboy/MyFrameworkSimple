//
//  Login_RegisViewController.m
//  MyFramework
//
//  Created by lalala on 2017/4/21.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "Login_RegisViewController.h"
#import "SDAutoLayout.h"
@interface Login_RegisViewController ()
@property(nonatomic,strong) UIImageView * myAppIcon;
@property(nonatomic,strong) UIButton * qqLoginBtn;
@property(nonatomic,strong) UIButton * weChatBtn;
@property(nonatomic,strong) UIButton * weiBoBtn;
@property(nonatomic,strong) UIButton * phoneBtn;
@property(nonatomic,strong) UIView * contentView;//放置登录方式按钮的父视图
@property(nonatomic,strong) NSArray * buttonArray;//按钮存放的数组
@end

@implementation Login_RegisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}
-(void)configUI{
    _myAppIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _myAppIcon.backgroundColor = [UIColor redColor];
    _qqLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _qqLoginBtn.backgroundColor = [UIColor orangeColor];
    _weChatBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _weChatBtn.backgroundColor = [UIColor orangeColor];
    _weiBoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _weiBoBtn.backgroundColor = [UIColor orangeColor];
    _phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _phoneBtn.backgroundColor = [UIColor orangeColor];
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    
    [self.view addSubview:_myAppIcon];
    [self.view addSubview:_contentView];
    //实际应用中需要判断是否存在微信API 添加不同的按钮 判断按钮是否添加到contentview上
    [_contentView addSubview:_qqLoginBtn];
    [_contentView addSubview:_weiBoBtn];
    [_contentView addSubview:_weChatBtn];
    [_contentView addSubview:_phoneBtn];
    _buttonArray = @[_qqLoginBtn,_weiBoBtn,_weChatBtn,_phoneBtn];
    
    [self setSubviewsLayOut];
}
//布局页面
-(void)setSubviewsLayOut{
    _myAppIcon.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view, 100).widthIs(100).heightEqualToWidth();
    //实际应用中需要根据实际情况 给contentView设置不同的width
    _contentView.sd_layout.centerXEqualToView(self.view).bottomSpaceToView(self.view, 50).heightIs(100).widthIs(_buttonArray.count * 50 + 20);
    [_contentView setupAutoMarginFlowItems:_buttonArray withPerRowItemsCount:_buttonArray.count itemWidth:50 verticalMargin:5 verticalEdgeInset:5 horizontalEdgeInset:0];
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
