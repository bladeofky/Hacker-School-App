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

/** @brief Returns a singleton representing the currently logged in user. 
    @return An AW_UserAccount singleton.*/
+ (instancetype)currentUser;

/** @brief The NXOAuth2Account of the current user ([[NXOAuth2AccountsStore sharedStore]accounts][0]) 
    @return NXOAuth2Account of current user
 */
- (NXOAuth2Account *)account;

/** 
 @brief Get the current user's information from the API.
 
 Sends an asynchronous request to the Hacker School API to retrieve the info for the current user. Creates an AW_Person and sets it
 to the @b person property.
 */
- (void)downloadPersonInfo;

/** @brief Archives the downloaded AW_Person for the current user. */
- (BOOL)saveCurrentUserInfo;

/** @brief Downloaded information about the current user. */
@property (nonatomic, strong) AW_Person *person;

@end
