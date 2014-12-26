//
//  ContactCell.h
//  ContactBook
//
//  Created by hellovoidworld on 14/12/25.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact;
@interface ContactCell : UITableViewCell

/** 联系人数据 */
@property(nonatomic, strong) Contact *contact;

+ (instancetype) cellWithTableView:(UITableView *) tableView;

@end
