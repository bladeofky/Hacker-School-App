//
//  AW_UserAccount.h
//  Hacker School
//
//  Created by Alan Wang on 1/29/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXOAuth2.h"

@class AW_Person;

@interface AW_UserAccount : NSObject

+ (instancetype)currentUser;

- (NXOAuth2Account *)account;
- (void)downloadPersonInfo;
- (BOOL)saveCurrentUserInfo;

@property (nonatomic, strong) AW_Person *person;

@end
