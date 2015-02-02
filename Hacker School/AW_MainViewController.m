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
#import "AW_UserMenuViewController.h"

#import "NXOAuth2.h"

#import "AW_UserAccount.h"
#import "AW_Person.h"

CGFloat const USER_MENU_WIDTH = 280.0;

@interface AW_MainViewController ()

@property (nonatomic, strong) __block AW_Person *currentUser;

@property (nonatomic, strong) AW_PeopleViewController *peopleVC;
@property (nonatomic, strong) AW_UserMenuViewController *userMenuVC;
@property (nonatomic, strong) UIViewController *centerVC;

@property (nonatomic, strong) UIView *overlay;

@property (nonatomic) BOOL isUserMenuShowing;

@end

@implementation AW_MainViewController
#pragma mark - Accessors
-(void)setCurrentUser:(AW_Person *)currentUser
{
    _currentUser = currentUser;
    NSLog(@"Current User: %@", _currentUser);
}

-(UIView *)overlay
{
    if (!_overlay) {
        _overlay = [[UIView alloc]initWithFrame:self.view.bounds];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissUserMenu)];
        [_overlay addGestureRecognizer:singleTap];
        _overlay.backgroundColor = [UIColor blackColor];
        _overlay.alpha = 0;
    }
    
    return _overlay;
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
    if (![AW_UserAccount currentUserAccount]) {
        AW_LoginViewController *loginVC = [[AW_LoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else {
        // *** ANYTHING THAT HAPPENS INSIDE THIS ELSE IS GUARANTEED TO HAVE A USER ACCOUNT ***
        
        // --- Get current user data from API and set to self.currentUser ---
        [NXOAuth2Request performMethod:@"GET"
                            onResource:[NSURL URLWithString:@"https://www.hackerschool.com//api/v1/people/me"]
                       usingParameters:nil
                           withAccount:[AW_UserAccount currentUserAccount]
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
        self.peopleVC.mainVC = self;
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

- (void)setupUserMenu
{
    // --- Set up left view ---
    self.userMenuVC = [[AW_UserMenuViewController alloc]init];
    self.userMenuVC.currentUser = self.currentUser;
    self.userMenuVC.view.frame = CGRectMake(-USER_MENU_WIDTH, 0, USER_MENU_WIDTH, self.view.bounds.size.height);
    
    [self.view addSubview:self.userMenuVC.view];
    
    [self addChildViewController:self.userMenuVC];
    [self.userMenuVC didMoveToParentViewController:self];
}

- (void)tearDownUserMenu
{
    [self.userMenuVC.view removeFromSuperview];
    [self.userMenuVC removeFromParentViewController];
    self.userMenuVC = nil;
}

- (void)showUserMenu
{
    [self setupUserMenu];
    
    [self.view insertSubview:self.overlay belowSubview:self.userMenuVC.view];
    
    [UIView animateWithDuration:.5
                     animations:^{
                         self.overlay.alpha = 0.5;
                         self.userMenuVC.view.frame = CGRectOffset(self.userMenuVC.view.frame, USER_MENU_WIDTH, 0);
                     }];
    self.isUserMenuShowing = YES;
}

- (void)dismissUserMenu
{
    [UIView animateWithDuration:.5
                     animations:^{
                         self.overlay.alpha = 0;
                         self.userMenuVC.view.frame = CGRectOffset(self.userMenuVC.view.frame, -USER_MENU_WIDTH, 0);
                     }
                     completion:^(BOOL finished) {
                         [self.overlay removeFromSuperview];
                         self.overlay = nil;
                         [self tearDownUserMenu];
                     }];
    
    self.isUserMenuShowing = NO;
}

@end
