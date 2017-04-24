//
//  Login_RegisViewController.m
//  MyFramework
//
//  Created by lalala on 2017/4/21.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "Login_RegisViewController.h"
#import "SDAutoLayout.h"
#import "RegisViewController.h"
#import "UMLoginTool.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"
@interface Login_RegisViewController ()
@property(nonatomic,strong) UIImageView * myAppIcon;
@property(nonatomic,strong) UIButton * qqLoginBtn;
@property(nonatomic,strong) UIButton * weChatBtn;
@property(nonatomic,strong) UIButton * weiBoBtn;
@property(nonatomic,strong) UIButton * phoneBtn;
@property(nonatomic,strong) UIView * contentView;//放置登录方式按钮的父视图
@property(nonatomic,strong) NSArray * buttonArray;//按钮存放的数组
@property(nonatomic,strong) RegisViewController * regisViewController;
@end

@implementation Login_RegisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}
-(void)configUI{
    _myAppIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _qqLoginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _weChatBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _weiBoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    _myAppIcon.image = [UIImage imageNamed:@"denglu－logo"];
    [self setButtonImageWithBtn:_qqLoginBtn image:@"dengluye_qq"];
     [self setButtonImageWithBtn:_weChatBtn image:@"dengluye_weixin"];
     [self setButtonImageWithBtn:_weiBoBtn image:@"dengluye_weibo"];
     [self setButtonImageWithBtn:_phoneBtn image:@"dengluye_shouji"];
    
    _qqLoginBtn.tag = 100;
    _weiBoBtn.tag = 101;
    _weChatBtn.tag = 102;
    _phoneBtn.tag = 103;
    [_qqLoginBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_weiBoBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_weChatBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_phoneBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
-(void)onClick:(UIButton *)sender{
    switch (sender.tag) {
        case 100://qq
        {
            [UMLoginTool QQLoginController:self success:^(id success) {
                NSLog(@"%@",success);
                [self goMainController];
            } failed:^(id failed) {
                [self.view makeToast:failed];
            }];
        }
            break;
        case 101://微博
        {
            [UMLoginTool SinaLoginController:self success:^(id success) {
                NSLog(@"%@",success);
                [self goMainController];
            } failed:^(id failed) {
                [self.view makeToast:failed];
            }];
        }
            break;
        case 102://微信
        {
            [UMLoginTool weixinLoginController:self success:^(id success) {
                NSLog(@"%@",success);
                 [self goMainController];
            } failed:^(id failed) {
                [self.view makeToast:failed];
            }];
        }
            break;
        case 103://手机
        {
            //点击手机登录 判断用户是否注册 跳转到不同的界面
            [self creatRegisView];
        }
            break;
        default:
            break;
    }
}
-(void)goMainController {
    [[AppDelegate shareDelegate] goMain];
}
-(void)creatRegisView {
    if (!_regisViewController) {
        UINavigationController * nagation = [[UINavigationController alloc]initWithRootViewController:[[RegisViewController alloc]init]];
//        [self.navigationController pushViewController:nagation animated:YES];
        nagation.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nagation animated:YES completion:nil];
    }
}
-(void)setButtonImageWithBtn:(UIButton *)btn image:(NSString *)image{
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
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



@end
