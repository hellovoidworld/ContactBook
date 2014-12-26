//
//  AddViewController.m
//  ContactBook
//
//  Created by hellovoidworld on 14/12/25.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import "AddViewController.h"
#import "Contact.h"

@interface AddViewController ()
/** 姓名 */
@property (weak, nonatomic) IBOutlet UITextField *nameText;

/** 电话 */
@property (weak, nonatomic) IBOutlet UITextField *phoneText;

/** 添加按钮 */
@property (weak, nonatomic) IBOutlet UIButton *addButton;


/** 点击添加按钮 */
- (IBAction)add;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置“添加”按钮的激活状态
    self.addButton.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.nameText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.phoneText];
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

// 等界面完全显示完毕，再弹出键盘
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 将焦点放在“姓名”输入框
    [self.nameText becomeFirstResponder];
}

- (void)dealloc {
    // 取消订阅消息监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 姓名、电话文本编辑消息处理 
 * 只有当姓名、电话不为空的时候才能使用“添加”按钮
 */
- (void) textChange {
    self.addButton.enabled = self.nameText.text.length && self.phoneText.text.length;
}

/** 点击添加按钮 */
- (IBAction)add {
    // 1.关闭当前控制器
    [self.navigationController popViewControllerAnimated:YES];
    
    // 2.使用模型传递数据给上一个控制器(ContactListViewController)，使用代理通知数据更新
    Contact *contact = [[Contact alloc] init];
    contact.name = self.nameText.text;
    contact.phone = self.phoneText.text;
    
    if ([self.delegate respondsToSelector:@selector(addViewController:didAddedContact:)]) {
        [self.delegate addViewController:self didAddedContact:contact];
    }
}
@end
