//
//  AW_MainViewController.m
//  Hacker School
//
//  Created by Alan Wang on 1/22/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_MainViewController.h"
#import "AW_LoginViewController.h"
#import "AW_PeopleViewController.h"

#import "NXOAuth2.h"

#import "AW_Person.h"

@interface AW_MainViewController ()

@property (nonatomic, strong) NXOAuth2Account *userAccount;
@property (nonatomic, strong) __block AW_Person *currentUser;

@property (nonatomic, strong) AW_PeopleViewController *peopleVC;
@property (nonatomic, strong) UIViewController *centerVC;

@end

@implementation AW_MainViewController
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
    NSLog(@"Current User: %@", _currentUser);
}

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Change default tintColor (for buttons and stuff) to green for Hacker School
    self.view.tintColor = [UIColor colorWithRed:0 green:0.9 blue:0 alpha:1.0];
    
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
        // *** ANYTHING THAT HAPPENS INSIDE THIS ELSE IS GUARANTEED TO HAVE A USER ACCOUNT ***
        
        // --- Get current user data from API and set to self.currentUser ---
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
        
        // --- Set up center view ---
        self.peopleVC = [[AW_PeopleViewController alloc]init];
        self.centerVC = [[UINavigationController alloc]initWithRootViewController:self.peopleVC];
        [self displayCenterController:self.centerVC];
    }
}

#pragma mark - View Controller management
- (void)displayCenterController: (UIViewController *)contentVC
{
    contentVC.view.frame = self.view.frame;
    [self.view addSubview:contentVC.view];
    [self addChildViewController:contentVC];
    [contentVC didMoveToParentViewController:self];
}



@end
