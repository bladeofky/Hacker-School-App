//
//  AW_UserMenuViewController.m
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_UserMenuViewController.h"
#import "AW_LoginViewController.h"

#import "NXOAuth2.h"

#import "AW_Person.h"

@interface AW_UserMenuViewController () <AW_PersonDelegate>

@property (nonatomic, strong) NXOAuth2Account *userAccount;
@property (nonatomic, strong) __block AW_Person *currentUser;

@end

@implementation AW_UserMenuViewController
#pragma mark - Accessors
-(NXOAuth2Account *)userAccount
{
    if (!_userAccount) {
        NSArray *accounts = [[NXOAuth2AccountStore sharedStore] accounts];
        
        if ([accounts count] > 0) {
            _userAccount = accounts[0];
        }
        else {
            _userAccount = nil;
        }
    }
    
    return _userAccount;
}

-(void)setCurrentUser:(AW_Person *)currentUser
{
    _currentUser = currentUser;
    _currentUser.delegate = self;

    // Refresh view
    [self.view setNeedsDisplay];
}

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    // --- Present Login Screen If No Current User ---
    // TODO: Possibly move this into the - (void)applicationDidBecomeActive:(UIApplication *)application method of the App Delegate
    if (!self.userAccount) {
        AW_LoginViewController *loginVC = [[AW_LoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else {
        // --- Get information about current logged in user ---
        [NXOAuth2Request performMethod:@"GET"
                            onResource:[NSURL URLWithString:@"https://www.hackerschool.com//api/v1/people/me"]
                       usingParameters:nil
                           withAccount:self.userAccount
                   sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
                       // i.e. update progress indicator
                   }
                       responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                           if (responseData) {
                               self.currentUser = [[AW_Person alloc]initWithHackerSchoolAPIData:responseData];
                           }
                           
                           if (error) {
                               NSLog(@"Error: %@", [error localizedDescription]);
                           }
                       }];
        
    }
}

#pragma mark - AW_PersonDelegate
-(void)person:(AW_Person *)person didDownloadImage:(UIImage *)image
{
    NSLog(@"%@",self.currentUser);
}

@end
