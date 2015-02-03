//
//  AW_UserAccount.m
//  Hacker School
//
//  Created by Alan Wang on 1/29/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_UserAccount.h"
#import "AW_Person.h"

@implementation AW_UserAccount

+ (instancetype)currentUser
{
    static AW_UserAccount *currentUser;
    
    if (!currentUser) {
        
        currentUser = [[self alloc ]initPrivate];
    }
    
    return currentUser;
}

#pragma mark - Initializers
-(instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        NSString *path = [self personArchivePath];
        _person = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    
    return self;
}

-(instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use +[currentUser] instead"];
    
    return nil;
}

#pragma mark -

-(NXOAuth2Account *)account
{
    if ([[[NXOAuth2AccountStore sharedStore]accounts]count] == 0) {
        return nil;
    }
    return [[NXOAuth2AccountStore sharedStore]accounts][0];
}

#pragma mark -

-(void)downloadPersonInfo
{
    // --- Get current user data from API and set to self.currentUser ---
    [NXOAuth2Request performMethod:@"GET"
                        onResource:[NSURL URLWithString:@"https://www.hackerschool.com//api/v1/people/me"]
                   usingParameters:nil
                       withAccount:[self account]
               sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
                   // i.e. update progress indicator
               }
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                       if (responseData) {
                           self.person = [[AW_Person alloc]initWithHackerSchoolAPIData:responseData];
                       }
                       
                       if (error) {
                           NSLog(@"Error: %@", [error localizedDescription]);
                       }
                   }];
}

#pragma mark - Archiving methods

-(NSString *)personArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"user.archive"];
}

-(BOOL)saveCurrentUserInfo
{
    NSString *path = [self personArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.person toFile:path];
}

@end
