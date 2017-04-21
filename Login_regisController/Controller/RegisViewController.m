//
//  RegisViewController.m
//  MyFramework
//
//  Created by lalala on 2017/4/21.
//  Copyright © 2017年 lsh. All rights reserved.
//

#import "RegisViewController.h"
#import "SDAutoLayout.h"
@interface RegisViewController ()
@property(nonatomic,strong) UITextField * phoneTextField;
@property(nonatomic,strong) UITextField * passWordTextField;
@property(nonatomic,strong) UIButton * getVerificationCodeBtn;
@property(nonatomic,strong) UITextField * verificationCodeTextField;
@property(nonatomic,strong) UIButton * completeBtn;
@property(nonatomic,strong) UILabel * agreeMentlabel;
@end

@implementation RegisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}
//布局注册页面
-(void)configUI{
    _phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    _phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
    _phoneTextField.placeholder = @"请输入你的电话号码";
    _phoneTextField.backgroundColor = [UIColor whiteColor];
    _passWordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    _passWordTextField.backgroundColor = [UIColor whiteColor];
    _passWordTextField.placeholder = @"请设置你的密码";
    _passWordTextField.borderStyle = UITextBorderStyleBezel;
    _verificationCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    _verificationCodeTextField.backgroundColor = [UIColor whiteColor];
    _verificationCodeTextField.placeholder = @"请输入获取到的验证码";
    _verificationCodeTextField.borderStyle = UITextBorderStyleLine;
    _getVerificationCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    _getVerificationCodeBtn.backgroundColor = [UIColor orangeColor];
    [_getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerificationCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _completeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    _completeBtn.backgroundColor = [UIColor orangeColor];
    [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_completeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _agreeMentlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
    _agreeMentlabel.backgroundColor = [UIColor orangeColor];
    _agreeMentlabel.text = @"点击完成表示你同意《###协议》";
    _agreeMentlabel.textAlignment = NSTextAlignmentCenter;
    _agreeMentlabel.textColor = [UIColor whiteColor];
    _agreeMentlabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:_phoneTextField];
    [self.view addSubview:_verificationCodeTextField];
    [self.view addSubview:_passWordTextField];
    [self.view addSubview:_getVerificationCodeBtn];
    [self.view addSubview:_completeBtn];
    [self.view addSubview:_agreeMentlabel];
    [self setLayOutSubViews];
}
//开始布局页面
-(void)setLayOutSubViews{
    _phoneTextField.sd_layout.leftSpaceToView(self.view, 15).rightSpaceToView(self.view, 0).topSpaceToView(self.view, 64).heightIs(50);
    _passWordTextField.sd_layout.leftEqualToView(_phoneTextField).rightEqualToView(_phoneTextField).heightIs(50).topSpaceToView(_verificationCodeTextField, 0);
    _getVerificationCodeBtn.sd_layout.leftSpaceToView(_verificationCodeTextField, 10).rightSpaceToView(self.view, 10).centerYEqualToView(_verificationCodeTextField);
    [_getVerificationCodeBtn setupAutoSizeWithHorizontalPadding:5 buttonHeight:35];
    _verificationCodeTextField.sd_layout.leftEqualToView(_phoneTextField).topSpaceToView(_phoneTextField, 0).heightIs(50).rightSpaceToView(_getVerificationCodeBtn, 10);
    _completeBtn.sd_layout.centerXEqualToView(_passWordTextField).heightIs(50).widthIs(200).topSpaceToView(_passWordTextField, 20);
    _agreeMentlabel.sd_layout.centerXEqualToView(_completeBtn).heightIs(24).topSpaceToView(_completeBtn, 10);
    [_agreeMentlabel setSingleLineAutoResizeWithMaxWidth:180];
    
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
