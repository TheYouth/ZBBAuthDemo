//
//  ZBBLogInView.m
//  ZBBLoginDemo
//
//  Created by 张彬彬 on 15/05/2017.
//  Copyright © 2017 binbintyou. All rights reserved.
//

#import "ZBBLogInView.h"

// 第三方
#import <Masonry.h>

#import "ZBBAuthManager.h"


@interface ZBBLogInView ()<ZBBLogInDelegate,ZBBLogOutDelegate>

@property (nonatomic, strong) UIImageView* logoImageView;
@property (nonatomic, strong) UILabel* titleLable;
@property (nonatomic, strong) UITextField* usernameTextField;
@property (nonatomic, strong) UITextField* passwordTextField;
@property (nonatomic, strong) UIButton* getRegisterCodeButton; // TODO:自定义一个注册按钮
@property (nonatomic, strong) UIButton* switchLogInTypeButton;
@property (nonatomic, strong) UIButton* logInButton;
@property (nonatomic, strong) UIControl* readedButton;
@property (nonatomic, strong) UILabel* userProtcolLabel;
@property (nonatomic, strong) UIButton* weixinLogInButton;
@property (nonatomic, strong) UIButton* qqLogInButton;
@property (nonatomic, strong) UILabel* splitLineLabel;


@end

@implementation ZBBLogInView

#pragma mark - ♻️life cycle
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.logoImageView];
        [self addSubview:self.titleLable];
        [self addSubview:self.usernameTextField];
        [self addSubview:self.passwordTextField];
        [self addSubview:self.logInButton];
//        [self addSubview:self.readedButton];
//        [self addSubview:self.userProtcolLabel];
        [self addSubview:self.splitLineLabel];
        [self addSubview:self.weixinLogInButton];
        [self addSubview:self.qqLogInButton];
        
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(60);
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.centerX.equalTo(self);
        }];
        
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.logoImageView.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(200, 20));
            make.centerX.equalTo(self);
        }];

        [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLable.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(200, 40));
            make.centerX.equalTo(self);
        }];
        
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.usernameTextField.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(200, 40));
            make.centerX.equalTo(self);
        }];
        
        [self.logInButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordTextField.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(100, 40));
            make.centerX.equalTo(self);
        }];
        
        [self.splitLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.logInButton.mas_bottom).offset(100);
            make.left.equalTo(self.mas_left).offset(40);
            make.right.equalTo(self.mas_right).offset(-40);
            make.height.mas_equalTo(1);
        }];
        [self.weixinLogInButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.splitLineLabel.mas_bottom).offset(30);
            make.left.equalTo(self.mas_left).offset(100);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
            
        }];
        [self.qqLogInButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.weixinLogInButton.mas_top);
            make.right.equalTo(self.mas_right).offset(-100);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
    }
    
    return self;
}

#pragma mark - 🔒private

-(void)weixinLogRequest:(UIButton*)button{
    id<ZBBAuthDelegate> wcht = [ZBBAuthManager authManagerWithAuthPlatform:ZBBAuthPlatformWeChat];
    wcht.delegate = self;
    [wcht logIn];
}

-(void)qqLogRequest:(UIButton*)button{
    id<ZBBAuthDelegate> qq = [ZBBAuthManager authManagerWithAuthPlatform:ZBBAuthPlatformQQ];
    qq.delegate = self;
    [qq logIn];
}

#pragma mark - 🍐delegate
-(void)logInSuccessed{
    NSLog(@"logInSuccessed");
}

-(void)logInSuccessedWithUserInfo:(NSDictionary *)userInfo{
    NSLog(@"logInSuccessedWithUserInfo=%@",userInfo);
}

-(void)logInFailed{
    NSLog(@"logInFailed");
}

-(void)logInFailedWithError:(NSError *)error{
    NSLog(@"logInFailedWithError=%@",error);
}

#pragma mark - 🔄overwrite

#pragma mark - 🚪public

#pragma mark - ☸getter and setter

-(UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]init];
    }
    
    return _logoImageView;
}

-(UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.text = @"你是你读过的书";
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.backgroundColor = [UIColor redColor];
    }
    
    return _titleLable;
}

-(UITextField *)usernameTextField{
    if (!_usernameTextField) {
        _usernameTextField = [[UITextField alloc]init];
        _usernameTextField.placeholder = @"输入手机号\\邮箱";
        _usernameTextField.borderStyle = UITextBorderStyleBezel;
    }
    
    return _usernameTextField;
}

-(UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc]init];
        _passwordTextField.placeholder = @"输入验证码";
        _passwordTextField.rightView = self.getRegisterCodeButton;
        _passwordTextField.borderStyle = UITextBorderStyleBezel;
    }
    
    return _passwordTextField;
}

-(UIButton *)logInButton{
    if (!_logInButton) {
        _logInButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_logInButton setTitle:@"快速登入" forState:UIControlStateNormal];
    }
    return _logInButton;
}

-(UIControl *)readedButton{
    if (!_readedButton) {
        _readedButton = [[UIControl alloc]init];
    }
    
    return _readedButton;
}

-(UILabel *)userProtcolLabel{
    if (!_userProtcolLabel) {
        _userProtcolLabel = [[UILabel alloc]init];
        _userProtcolLabel.text = @"登录表示同意《用户协议》";
    }
    
    return _userProtcolLabel;
}

-(UILabel *)splitLineLabel{
    if (!_splitLineLabel) {
        _splitLineLabel = [[UILabel alloc]init];
        _splitLineLabel.backgroundColor = [UIColor grayColor];
    }
    
    return _splitLineLabel;
}

-(UIButton *)weixinLogInButton{
    if (!_weixinLogInButton) {
        _weixinLogInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weixinLogInButton  setImage:[UIImage imageNamed:@"bookShelf_wechat"]
                             forState:UIControlStateNormal];
        [_weixinLogInButton addTarget:self
                               action:@selector(weixinLogRequest:)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _weixinLogInButton;
}

-(UIButton *)qqLogInButton{
    if (!_qqLogInButton) {
        _qqLogInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qqLogInButton  setImage:[UIImage imageNamed:@"personal_head"]
                         forState:UIControlStateNormal];
        [_qqLogInButton addTarget:self
                           action:@selector(qqLogRequest:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _qqLogInButton;
}

@end











