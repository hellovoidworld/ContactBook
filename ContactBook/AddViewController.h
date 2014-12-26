//
//  AddViewController.h
//  ContactBook
//
//  Created by hellovoidworld on 14/12/25.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddViewController, Contact;
@protocol AddViewControllerDelegate <NSObject>

@optional
- (void) addViewController:(AddViewController *) addViewController didAddedContact: (Contact *) contact;

@end

@interface AddViewController : UIViewController

/** 代理 */
@property(nonatomic, weak) id<AddViewControllerDelegate> delegate;

@end
