//
//  Contact.m
//  ContactBook
//
//  Created by hellovoidworld on 14/12/25.
//  Copyright (c) 2014年 hellovoidworld. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (instancetype) initWithDictionary:(NSDictionary *) dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

+ (instancetype) contactWithDictionary:(NSDictionary *) dict {
    return [[self alloc] initWithDictionary:dict];
}

+ (NSDictionary *) dictionaryWithContact:(Contact *) contact {
    return [contact dictionaryWithValuesForKeys: @[@"name", @"phone"]];
}

@end
