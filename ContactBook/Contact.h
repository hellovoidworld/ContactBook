//
//  Contact.h
//  ContactBook
//
//  Created by hellovoidworld on 14/12/25.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *phone;

- (instancetype) initWithDictionary:(NSDictionary *) dict;
+ (instancetype) contactWithDictionary:(NSDictionary *) dict;

+ (NSDictionary *) dictionaryWithContact:(Contact *) contact;

@end
