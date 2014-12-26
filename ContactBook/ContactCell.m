//
//  ContactCell.m
//  ContactBook
//
//  Created by hellovoidworld on 14/12/25.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import "ContactCell.h"
#import "Contact.h"

@interface ContactCell()

@property(nonatomic, weak) UIView *divideLine;

@end

@implementation ContactCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype) cellWithTableView:(UITableView *) tableView {
    // cell ID 要在storyboard中设置好
    static NSString *ID = @"contactCell";
    // 先从缓存池寻找，如果找不到就从storyboard中创建一个
    return [tableView dequeueReusableCellWithIdentifier:ID];
}

/**
 * 如果cell是通过storyboard或者xib创建，不会调用此方法
 * 如果使用代码创建cell，才会调用这个方法来初始化cell
 */
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    NSLog(@"initWithStyle");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}


/** 加载数据 */
- (void) setContact:(Contact *)contact {
    _contact = contact;
    
    self.textLabel.text = contact.name;
    self.detailTextLabel.text = contact.phone;
}

/**
 * 如果cell是通过storyboard或者xib创建，创建完毕会调用这个方法
 * 可以在这里初始化cell
 */
- (void) awakeFromNib {
    // 自定义一个分割线
    UIView *divideLine = [[UIView alloc] init];
    [divideLine setBackgroundColor:[UIColor blackColor]];
    [divideLine setAlpha:0.2];
    [self.contentView addSubview:divideLine];
    self.divideLine = divideLine;
}

/**
 * 在此方法中，cell的frame确定被初始化完成，可以再这里初始化其子控件的frame
 */
- (void)layoutSubviews {
    // 切记调用父类方法!
    [super layoutSubviews];
    
    CGFloat lineHeight = 1;
    CGFloat lineWidth = self.frame.size.width;
    CGFloat lineX = 0;
    CGFloat lineY = self.frame.size.height - 1;
    
    self.divideLine.frame = CGRectMake(lineX, lineY, lineWidth, lineHeight);
}

@end
