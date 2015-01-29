//
//  AW_UserAccount.m
//  Hacker School
//
//  Created by Alan Wang on 1/29/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_UserAccount.h"

@implementation AW_UserAccount

+ (instancetype)currentUser
{
    AW_UserAccount *userAccount;
    
    NSArray *accounts = [[NXOAuth2AccountStore sharedStore] accounts];
    
    if ([accounts count] > 0) {
        userAccount = accounts[0];
    }
    else {
        userAccount = nil;
    }
    
    return userAccount;
}

@end
