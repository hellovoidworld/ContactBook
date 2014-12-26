//
//  ContactListTableViewController.m
//  ContactBook
//
//  Created by hellovoidworld on 14/12/24.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import "ContactListTableViewController.h"
#import "AddViewController.h"
#import "ContactCell.h"
#import "Contact.h"
#import "EditViewController.h"
#import "MBProgressHUD+MJ.h"

@interface ContactListTableViewController () <UITableViewDataSource,UITableViewDelegate, UIActionSheetDelegate, AddViewControllerDelegate, EditViewControllerDelegate>

/** 联系人数组 */
@property(nonatomic, strong) NSArray *contacts;

/** 点击注销 */
- (IBAction)logout:(UIBarButtonItem *)sender;

@end

@implementation ContactListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置无系统自带分割线
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // 取出原来在storyboard中创建的“+”按钮
    UIBarButtonItem *addItem = self.navigationItem.rightBarButtonItem;
    
    // 创建一个“垃圾桶”按钮
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteCheck)];
    
    // 都放入到右边的状态栏
    self.navigationItem.rightBarButtonItems = @[deleteItem, addItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建cell
    ContactCell *cell = [ContactCell cellWithTableView:tableView];
    
    // 2.设置数据
    cell.contact = self.contacts[indexPath.row];
    
    return cell;
}

/**
 * 如果实现了这个方法，就自动实现了滑动删除功能
 * 点击了“删除”按钮就会调用
 * 实质是提交了一个编辑操作导致调用（删除/添加/编辑）
 * @param editingStyle 编辑行为
 * @param indexPath 操作行号
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 如果是删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 1.删除数据
        NSMutableArray *marray = [NSMutableArray arrayWithArray:self.contacts];
        [marray removeObjectAtIndex:indexPath.row];
        self.contacts = marray;
        
        // 2.刷新界面
//        [self.tableView reloadData];
        // 只删掉需要删除的一行，不必刷新所有数据
        // 使用这个方法，必须删除对应的模型数据，数量要对应
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        // 3.更改plist数据
        [self saveContactsDataToFile];
    }
}

/** 点击注销 */
- (IBAction)logout:(UIBarButtonItem *)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定要注销?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [sheet showInView:self.view];
}

#pragma mark - Segue相关
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // 取得目标控制器
    id controller = segue.destinationViewController;
    
    // 判断跳转目标
    if ([controller isKindOfClass:[AddViewController class]]) {
        // 如果是“添加联系人”
        AddViewController *addViewController = controller;
        addViewController.delegate = self;
    }
    
    if ([controller isKindOfClass:[EditViewController class]]) {
        // 如果是“查看/编辑联系人”
        EditViewController *editViewController = controller;
        
        // 取出数据
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        editViewController.contact = self.contacts[indexPath.row];
        
        // 设置代理
        editViewController.delegate = self;
    }
    
}

#pragma mark - ActionSheet delegate function
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0) return;
    
    // 弹出一个栈顶控制器，即本控制器，回到上一页
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AddViewController delegate function
/** 添加联系人后，更新联系人列表数据 */
- (void)addViewController:(AddViewController *)addViewController didAddedContact:(Contact *)contact {
    NSMutableArray *mcontacts = [NSMutableArray arrayWithArray:self.contacts];
    [mcontacts addObject:contact];
    self.contacts = mcontacts;
    
    // 保存数据到plist文件
    [self saveContactsDataToFile];
    
    // 刷新界面数据
    [self.tableView reloadData];
}

#pragma mark - EditViewController delegate function
/** “编辑联系人”的“保存”代理方法, 刷新数据 */
- (void)editViewController:(EditViewController *)editViewController didSavedContact:(Contact *)contact {
    // 保存数据
    [self saveContactsDataToFile];
    // 刷新数据
    [self.tableView reloadData];
}

#pragma mark - 加载、保存、读取数据
/** 保存联系人数据到plist */
- (void) saveContactsDataToFile {
    // 沙盒路径
    NSString *path = NSHomeDirectory();
    // Documents路径
    NSString *docPath = [path stringByAppendingPathComponent:@"Documents"];
    // plist文件路径
    NSString *filePath = [docPath stringByAppendingPathComponent:@"contacts.plist"];
    
    NSMutableArray *dictArray = [NSMutableArray array];
    for (Contact *contact in self.contacts) {
        // 将模型转换成字典进行存储
        NSDictionary *dict = [Contact dictionaryWithContact:contact];
        [dictArray addObject:dict];
    }
    [dictArray writeToFile:filePath atomically:YES];
    NSLog(@"save to : %@", filePath);
}


/** 加载数据 */
- (NSArray *) contacts {
    if (nil == _contacts) {
        // 沙盒路径
        NSString *path = NSHomeDirectory();
        // Documents路径
        NSString *docPath = [path stringByAppendingPathComponent:@"Documents"];
        // plist文件路径
        NSString *filePath = [docPath stringByAppendingPathComponent:@"contacts.plist"];
        
        // 如果plist文件不存在
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:filePath]) {
            _contacts = [NSArray array];
            return _contacts;
        }
        
        // 如果plist文件存在，开始读取
        NSArray *contacts = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *mcontacts = [NSMutableArray array];
        for (NSDictionary *dict in contacts) {
            Contact *contact = [Contact contactWithDictionary:dict];
            [mcontacts addObject:contact];
        }
        
        _contacts = mcontacts;
    }
    
    return _contacts;
}

// 点击状态栏按钮“垃圾桶”，使所有cell进入编辑状态或者退出编辑状态
- (void) deleteCheck {
//    self.tableView.editing = !self.tableView.editing;
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

// 改变编辑状态下的编辑按钮
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // 这里改为“添加”符号，需要自定义事件
        return UITableViewCellEditingStyleInsert;
    } else if (indexPath.row == 1) {
        // none就是什么都没有，没有作用
        return UITableViewCellEditingStyleNone;
    } else {
        // 默认就是“删除”
        return UITableViewCellEditingStyleDelete;
    }
}

@end
