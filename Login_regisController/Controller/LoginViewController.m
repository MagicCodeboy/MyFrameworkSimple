//
//  LoginViewController.m
//  MyFramework
//
//  Created by lalala on 2017/4/21.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "LoginViewController.h"
#import "SDAutoLayout.h"
#import "AppDelegate.h"
@interface LoginViewController ()
@property(nonatomic,strong) UITextField * phoneTextField;
@property(nonatomic,strong) UITextField * passwordTextField;
@property(nonatomic,strong) UIButton * loginBtn;
@property(nonatomic,strong) UIButton * forgetPasswordBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}
-(void)configUI{
    [self setNavgationTitle:@"登录"];
    [self addBackBtn];
    
    _passwordTextField = [[UITextField alloc]init];
    _phoneTextField = [[UITextField alloc]init];
    _loginBtn = [[UIButton alloc]init];
    _forgetPasswordBtn = [[UIButton alloc]init];
    _passwordTextField.borderStyle = UITextBorderStyleBezel;
    _phoneTextField.borderStyle = UITextBorderStyleBezel;
    _loginBtn.backgroundColor = [UIColor orangeColor];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_forgetPasswordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [_forgetPasswordBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
    [_forgetPasswordBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    _forgetPasswordBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _passwordTextField.placeholder = @"请输入你的密码";
    _phoneTextField.placeholder = @"请输入你的手机号码";
    
    [self.view addSubview:_phoneTextField];
    [self.view addSubview:_passwordTextField];
    [self.view addSubview:_loginBtn];
    [self.view addSubview:_forgetPasswordBtn];
    [self layOUtSubVIews];
}
-(void)layOUtSubVIews{
    _phoneTextField.sd_layout.leftSpaceToView(self.view, 15).rightSpaceToView(self.view, 0).topSpaceToView(self.view, 64).heightIs(50);
    _passwordTextField.sd_layout.leftSpaceToView(self.view, 15).rightSpaceToView(self.view, 0).topSpaceToView(_phoneTextField, 0).heightIs(50);
    _forgetPasswordBtn.sd_layout.leftEqualToView(_phoneTextField).topSpaceToView(_passwordTextField,5).heightIs(20).widthIs(70);
    _loginBtn.sd_layout.centerXEqualToView(self.view).topSpaceToView(_passwordTextField,40).widthIs(150).heightIs(50);
}
//点击登录按钮
-(void)onLogin{
    [[AppDelegate shareDelegate] goMain];
}
//忘记密码页面
-(void)forgetPassword{
    
}
-(void)backBtn:(WRBButton *)button{
    [self.navigationController popViewControllerAnimated:NO];
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
