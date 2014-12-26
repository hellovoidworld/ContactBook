//
//  LoginViewController.m
//  ContactBook
//
//  Created by hellovoidworld on 14/12/24.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD+MJ.h"

@interface LoginViewController ()
/** 账号输入框 */
@property (weak, nonatomic) IBOutlet UITextField *accountText;

/** 密码输入框 */
@property (weak, nonatomic) IBOutlet UITextField *pwdText;

/** 记住密码开关 */
@property (weak, nonatomic) IBOutlet UISwitch *keepPwd;

/** 自动登陆开关 */
@property (weak, nonatomic) IBOutlet UISwitch *autoLogin;

/** 登陆按钮 */
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

/** 点击登陆 */
- (IBAction)login;

/** 点击记住密码 */
- (IBAction)keepPwdSwitch;

/** 点击自动登陆 */
- (IBAction)autoLoginSwitch;

/** 自动登陆标识 */
@property(nonatomic, assign) BOOL stopAutoLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

/** 
 * 把初始化代码放在viewDidAppear
 * 让view完全呈现之后才进行自动登陆，否则拿不到view，hideHUD的时候会失效
 */
- (void)viewDidAppear:(BOOL)animated {
    // 设置登陆状态
    [self readLoginStatus];
    
    // 初始化登陆按钮状态
    if (!self.accountText.text.length || !self.pwdText.text.length) {
        self.loginButton.enabled = NO;
    }
    
    // 登陆按钮开始监听账号、密码输入框
    [self loginButtonListening];
}

- (void)viewDidDisappear:(BOOL)animated {
    // 当不是初次出现在屏幕上，禁止自动登陆
    self.stopAutoLogin = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/* 登陆按钮监听账号、密码输入框的通知
 * 只有当两者都有内容的时候才能激活登陆按钮
 */
- (void) loginButtonListening{
    // 监听账号输入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.accountText];
    
    // 监听密码输入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.pwdText];
}

// 记得要在自身被销毁的时候取消消息订阅
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 登陆按钮监听的触发事件
- (void) textChange {
    // 只有当账号、密码不为空的时候，才能使用登陆按钮
    self.loginButton.enabled = self.accountText.text.length && self.pwdText.text.length;
}


/** 点击登陆 */
- (IBAction)login {
    // 检测账号
    if (![self.accountText.text isEqualToString:@"hw"]) {
        [MBProgressHUD showError:@"账号不存在"];
        return;
    }
    
    // 检测密码
    if (![self.pwdText.text isEqualToString:@"123"]) {
        [MBProgressHUD showError:@"密码错误"];
        return;
    }
    
    // 登陆中，遮盖屏幕，禁止用户进行其他操作
    [MBProgressHUD showMessage:@"正在使劲登录中..."];
    
    // 模拟登陆过程，延迟跳转
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 移除遮盖
        [MBProgressHUD hideHUD];
        
        // 根据Segue ID 执行跳转
        [self performSegueWithIdentifier:@"contactList" sender:nil];
    });

    // 保存登陆状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.keepPwd.isOn forKey:@"keepPwd"];
    [defaults setBool:self.autoLogin.isOn forKey:@"autoLogin"];
    
    // 保存账号、密码信息
    if (self.keepPwd.isOn) {
        [defaults setObject:self.accountText.text forKey:@"account"];
        [defaults setObject:self.pwdText.text forKey:@"pwd"];
    }
}

/** 点击记住密码 */
- (IBAction)keepPwdSwitch {
    if (!self.keepPwd.isOn) {
        [self.autoLogin setOn:NO];
    }
}

/** 点击自动登陆 */
- (IBAction)autoLoginSwitch {
    if (self.autoLogin.isOn) {
        [self.keepPwd setOn:YES];
    }
}

/** 读取登陆状态 */
- (void) readLoginStatus {
    // 记住密码、自动登录开关状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.keepPwd.on = [defaults boolForKey:@"keepPwd"]? YES:NO; // 防止键值对为nil
    self.autoLogin.on = [defaults boolForKey:@"autoLogin"]? YES:NO;
    
    // 账号、密码
    if (self.keepPwd.isOn) {
        self.accountText.text = [defaults objectForKey:@"account"];
        self.pwdText.text = [defaults objectForKey:@"pwd"];
    }
    
    // 自动登陆
    if (!self.stopAutoLogin && self.autoLogin.isOn) {
        [self login];
    }
}
@end
