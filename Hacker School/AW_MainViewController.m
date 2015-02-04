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
#import "AW_WebViewController.h"

#import "NXOAuth2.h"

#import "AW_UserAccount.h"
#import "AW_Person.h"

CGFloat const USER_MENU_WIDTH = 280.0;
NSString * const PEOPLE_VC_TAG = @"People";
NSString * const COMMUNITY_VC_TAG = @"Community";
NSString * const BOOKER_VC_TAG = @"Booker";
NSString * const RECOMMEND_VC_TAG = @"Recommend";

@interface AW_MainViewController ()

@property (nonatomic, strong) AW_UserMenuViewController *userMenuVC;
@property (nonatomic, strong) UIViewController *centerVC;

@property (nonatomic, strong) UIView *overlay;

@property (nonatomic) BOOL isUserMenuShowing;

@end

@implementation AW_MainViewController
#pragma mark - Accessors
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
    if (![[AW_UserAccount currentUser]account]) {
        [self showLoginVC];
    }
    else {
        // *** ANYTHING THAT HAPPENS INSIDE THIS ELSE IS GUARANTEED TO HAVE A USER ACCOUNT ***
        
        [[AW_UserAccount currentUser]downloadPersonInfo];
        
        // --- Set up center view ---
        self.centerVC = [self peopleViewController];
        [self displayCenterController:self.centerVC];
    }
}



#pragma mark - View Controller management
- (void)displayCenterControllerForOption:(NSString *)option
{
    // Remove previous center controller
    [self.centerVC.view removeFromSuperview];
    [self.centerVC removeFromParentViewController];
    
    // Present new center controller
    if ([option isEqualToString:PEOPLE_VC_TAG]) {
        [self displayCenterController:[self peopleViewController]];
    }
    else if ([option isEqualToString:COMMUNITY_VC_TAG]) {
        [self displayCenterController:[self communityViewController]];
    }
    else if ([option isEqualToString:BOOKER_VC_TAG]) {
        [self displayCenterController:[self bookerViewController]];
    }
    else if ([option isEqualToString:RECOMMEND_VC_TAG]) {
        [self displayCenterController:[self recommendViewController]];
    }
}

- (void)displayCenterController: (UIViewController *)contentVC
{
    contentVC.view.frame = self.view.frame;
    
    if (self.overlay) {
        // If user menu is open, add it underneath the menu
        [self.view insertSubview:contentVC.view belowSubview:self.overlay];
    }
    else {
        // Otherwise add the view on top
        [self.view addSubview:contentVC.view];
    }
    
    [self addChildViewController:contentVC];
    [contentVC didMoveToParentViewController:self];
    
    self.centerVC = contentVC;
}

#pragma mark - People VC
- (UIViewController *)peopleViewController
{
    AW_PeopleViewController *peopleVC = [[AW_PeopleViewController alloc]init];
    peopleVC.mainVC = self;
    UINavigationController *centerVC = [[UINavigationController alloc]initWithRootViewController:peopleVC];
    
    return centerVC;
}

#pragma mark - Community VC
- (UIViewController *)communityViewController
{
    AW_WebViewController *webVC = [[AW_WebViewController alloc]init];
    webVC.mainVC = self;
    webVC.url = [NSURL URLWithString:@"https://community.hackerschool.com/"];
    webVC.navBarTitle = @"Community";
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    
    return navVC;
}

#pragma mark - Booker VC
- (UIViewController *)bookerViewController
{
    AW_WebViewController *webVC = [[AW_WebViewController alloc]init];
    webVC.mainVC = self;
    webVC.url = [NSURL URLWithString:@"https://www.hackerschool.com/booker"];
    webVC.navBarTitle = @"Booker";
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    
    return navVC;
}

#pragma mark - Recommend VC
- (UIViewController *)recommendViewController
{
    AW_WebViewController *webVC = [[AW_WebViewController alloc]init];
    webVC.mainVC = self;
    webVC.url = [NSURL URLWithString:@"https://www.hackerschool.com/private/recommend"];
    webVC.navBarTitle = @"Recommend";
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    
    return navVC;
}

#pragma mark - User Menu

- (void)setupUserMenu
{
    // --- Set up left view ---
    self.userMenuVC = [[AW_UserMenuViewController alloc]init];
    self.userMenuVC.currentUser = [AW_UserAccount currentUser].person;
    self.userMenuVC.mainVC = self;
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dismissUserMenu)];
//    [self.userMenuVC.view addGestureRecognizer:panGestureRecognizer];
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

#pragma mark - Login
-(void)showLoginVC
{
    AW_LoginViewController *loginVC = [[AW_LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

#pragma mark - Logout

-(void)logout
{
    NSLog(@"Logging out");
    [[NXOAuth2AccountStore sharedStore] removeAccount: [[AW_UserAccount currentUser]account] ];
    [AW_UserAccount currentUser].person = nil;
    [self showLoginVC];
}

@end
