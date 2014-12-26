//
//  EditViewController.m
//  ContactBook
//
//  Created by hellovoidworld on 14/12/25.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import "EditViewController.h"
#import "Contact.h"

@interface EditViewController ()

/** 姓名 */
@property (weak, nonatomic) IBOutlet UITextField *nameText;

/** 电话 */
@property (weak, nonatomic) IBOutlet UITextField *phoneText;

/** “保存”按钮 */
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

/** 点击“保存” */
- (IBAction)save;

/** 点击“编辑”或"取消” */
- (IBAction)editOrCancel:(UIBarButtonItem *)sender;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 加载数据
    self.nameText.text = self.contact.name;
    self.phoneText.text = self.contact.phone;
    
    // 设置输入监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.nameText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.phoneText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/** 点击“保存” */
- (IBAction)save {
    // 1.退出导航栈，回到上一页
    [self.navigationController popViewControllerAnimated:YES];
    
    // 2.调用代理方法，通知“联系人列表”更改数据
    self.contact.name = self.nameText.text;
    self.contact.phone = self.phoneText.text;
    
    if ([self.delegate respondsToSelector:@selector(editViewController:didSavedContact:)]) {
        [self.delegate editViewController:self didSavedContact:self.contact];
    }
}

/** 点击“编辑”或"取消” */
- (IBAction)editOrCancel:(UIBarButtonItem *)sender {
    // 转变后的状态
    BOOL isChangedToEditMode = [sender.title isEqualToString:@"编辑"]? YES:NO;
    
    if (isChangedToEditMode) {
        // 点击"编辑"
        // 1.转变title
        sender.title = @"取消";
        
        // 2.转变编辑状态
        self.nameText.enabled = YES;
        self.phoneText.enabled = YES;
        self.saveButton.hidden = NO;
        
        // 获得输入焦点
        [self.nameText becomeFirstResponder];
    } else {
        // 点击“取消”
        // 1.转变title
        sender.title = @"编辑";
        
        // 2.转变编辑状态
        self.nameText.enabled = NO;
        self.phoneText.enabled = NO;
        self.saveButton.hidden = YES;
        
        // 3.还原数据
        self.nameText.text = self.contact.name;
        self.phoneText.text = self.contact.phone;
        
        // 4.退出键盘
        [self.view endEditing:YES];
    }
    
}

/** 消息监听事件 */
- (void) textChange {
    self.saveButton.enabled = self.nameText.text.length && self.phoneText.text.length;
}

@end
