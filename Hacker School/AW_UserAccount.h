//
//  AW_UserAccount.h
//  Hacker School
//
//  Created by Alan Wang on 1/29/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NXOAuth2.h"

@interface AW_UserAccount : NXOAuth2Account

+ (NXOAuth2Account *)currentUser;

@end
