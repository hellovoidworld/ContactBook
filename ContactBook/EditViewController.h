//
//  EditViewController.h
//  ContactBook
//
//  Created by hellovoidworld on 14/12/25.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact, EditViewController;
/** 代理协议 */
@protocol EditViewControllerDelegate <NSObject>

@optional
- (void) editViewController:(EditViewController *) editViewController didSavedContact:(Contact *) contact;

@end

@interface EditViewController : UIViewController

/** 数据 */
@property(nonatomic, strong) Contact *contact;

/** 代理 */
@property(nonatomic, weak) id<EditViewControllerDelegate> delegate;

@end
