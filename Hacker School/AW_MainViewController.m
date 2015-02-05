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
#import "AW_PersonDetailViewController.h"
#import "AW_UserMenuViewController.h"
#import "AW_WebViewController.h"

#import "NXOAuth2.h"

#import "AW_UserAccount.h"
#import "AW_Person.h"

CGFloat const USER_MENU_WIDTH = 280.0;

NSString * const PEOPLE_VC_TAG = @"People";
NSString * const PROJECTS_VC_TAG = @"Projects";
NSString * const COMPANIES_VC_TAG = @"Companies";
NSString * const RESIDENTS_VC_TAG = @"Residents";
NSString * const BLOG_VC_TAG = @"Blog";

NSString * const COMMUNITY_VC_TAG = @"Community";

NSString * const BOOKER_VC_TAG = @"Booker";
NSString * const GROUPS_VC_TAG = @"Groups";
NSString * const RECOMMEND_VC_TAG = @"Recommend";
NSString * const USER_MANUAL_VC_TAG = @"User Manual";
NSString * const SETTINGS_VC_TAG = @"Settings";

@interface AW_MainViewController ()

@property (nonatomic, strong) AW_UserMenuViewController *userMenuVC;
@property (nonatomic, strong) UIViewController *centerVC;

@property (nonatomic, strong) UIView *overlay;

@property (nonatomic) BOOL isUserMenuShowing;
@property (nonatomic, weak) NSLayoutConstraint *menuPositionConstraint;

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
    else if ([option isEqualToString:PROJECTS_VC_TAG]) {
        [self displayCenterController:[self projectsViewController]];
    }
    else if ([option isEqualToString:COMPANIES_VC_TAG]) {
        [self displayCenterController:[self companiesViewController]];
    }
    else if ([option isEqualToString:RESIDENTS_VC_TAG]) {
        [self displayCenterController:[self residentsViewController]];
    }
    else if ([option isEqualToString:BLOG_VC_TAG]) {
        [self displayCenterController:[self blogViewController]];
    }
    
    else if ([option isEqualToString:COMMUNITY_VC_TAG]) {
        [self displayCenterController:[self communityViewController]];
    }
    
    else if ([option isEqualToString:BOOKER_VC_TAG]) {
        [self displayCenterController:[self bookerViewController]];
    }
    else if ([option isEqualToString:GROUPS_VC_TAG]) {
        [self displayCenterController:[self groupsViewController]];
    }
    else if ([option isEqualToString:RECOMMEND_VC_TAG]) {
        [self displayCenterController:[self recommendViewController]];
    }
    else if ([option isEqualToString:USER_MANUAL_VC_TAG]) {
        [self displayCenterController:[self userManualViewController]];
    }
    else if ([option isEqualToString:SETTINGS_VC_TAG]) {
        [self displayCenterController:[self settingsViewController]];
    }
    
    [self dismissUserMenu];
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
    
    [contentVC.view layoutIfNeeded];
    
    [self addChildViewController:contentVC];
    [contentVC didMoveToParentViewController:self];
    
    self.centerVC = contentVC;
}

#pragma mark - Browse Options
- (UIViewController *)peopleViewController
{
    AW_PeopleViewController *peopleVC = [[AW_PeopleViewController alloc]init];
    peopleVC.mainVC = self;
    UINavigationController *centerVC = [[UINavigationController alloc]initWithRootViewController:peopleVC];
    
    return centerVC;
}

- (UIViewController *)projectsViewController
{
    AW_WebViewController *webVC = [[AW_WebViewController alloc]init];
    webVC.mainVC = self;
    webVC.url = [NSURL URLWithString:@"https://www.hackerschool.com/projects"];
    webVC.navBarTitle = @"Projects";
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    
    return navVC;
}

- (UIViewController *)companiesViewController
{
    AW_WebViewController *webVC = [[AW_WebViewController alloc]init];
    webVC.mainVC = self;
    webVC.url = [NSURL URLWithString:@"https://www.hackerschool.com/companies"];
    webVC.navBarTitle = @"Companies";
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    
    return navVC;
}

- (UIViewController *)residentsViewController
{
    AW_WebViewController *webVC = [[AW_WebViewController alloc]init];
    webVC.mainVC = self;
    webVC.url = [NSURL URLWithString:@"https://www.hackerschool.com/residents"];
    webVC.navBarTitle = @"Residents";
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    
    return navVC;
}

- (UIViewController *)blogViewController
{
    AW_WebViewController *webVC = [[AW_WebViewController alloc]init];
    webVC.mainVC = self;
    webVC.url = [NSURL URLWithString:@"https://www.hackerschool.com/blog"];
    webVC.navBarTitle = @"Blog";
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    
    return navVC;
}

#pragma mark - Connect Options
- (UIViewController *)communityViewController
{
    AW_WebViewController *webVC = [[AW_WebViewController alloc]init];
    webVC.mainVC = self;
    webVC.url = [NSURL URLWithString:@"https://community.hackerschool.com/"];
    webVC.navBarTitle = @"Community";
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    
    return navVC;
}

#pragma mark - Tools Options
- (UIViewController *)bookerViewController
{
    AW_WebViewController *webVC = [[AW_WebViewController alloc]init];
    webVC.mainVC = self;
    webVC.url = [NSURL URLWithString:@"https://www.hackerschool.com/booker"];
    webVC.navBarTitle = @"Booker";
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    
    return navVC;
}

- (UIViewController *)groupsViewController
{
    AW_WebViewController *webVC = [[AW_WebViewController alloc]init];
    webVC.mainVC = self;
    webVC.url = [NSURL URLWithString:@"https://www.hackerschool.com/groups"];
    webVC.navBarTitle = @"Groups";
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    
    return navVC;
}

- (UIViewController *)recommendViewController
{
    AW_WebViewController *webVC = [[AW_WebViewController alloc]init];
    webVC.mainVC = self;
    webVC.url = [NSURL URLWithString:@"https://www.hackerschool.com/private/recommend"];
    webVC.navBarTitle = @"Recommend";
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    
    return navVC;
}

- (UIViewController *)userManualViewController
{
    AW_WebViewController *webVC = [[AW_WebViewController alloc]init];
    webVC.mainVC = self;
    webVC.url = [NSURL URLWithString:@"https://www.hackerschool.com/manual"];
    webVC.navBarTitle = @"User Manual";
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:webVC];
    
    return navVC;
}

- (UIViewController *)settingsViewController
{
    AW_WebViewController *webVC = [[AW_WebViewController alloc]init];
    webVC.mainVC = self;
    webVC.url = [NSURL URLWithString:@"https://www.hackerschool.com/settings"];
    webVC.navBarTitle = @"Settings";
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
    self.userMenuVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(dismissUserMenu)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.userMenuVC.view addGestureRecognizer:swipeGestureRecognizer];
    
    [self.view addSubview:self.userMenuVC.view];
    
    NSLayoutConstraint *menuBarWidthConstraint = [NSLayoutConstraint constraintWithItem:self.userMenuVC.view
                                                                              attribute:NSLayoutAttributeWidth
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:nil
                                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                                             multiplier:1
                                                                               constant:USER_MENU_WIDTH];
    NSLayoutConstraint *menuBarPositionConstraint = [NSLayoutConstraint constraintWithItem:self.userMenuVC.view
                                                                                 attribute:NSLayoutAttributeLeft
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.view
                                                                                 attribute:NSLayoutAttributeLeft
                                                                                multiplier:1
                                                                                  constant:-USER_MENU_WIDTH];
    NSArray *menuBarVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[userMenu]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:@{@"userMenu":self.userMenuVC.view}];
    [self.view addConstraint:menuBarWidthConstraint];
    [self.view addConstraint:menuBarPositionConstraint];
    [self.view addConstraints:menuBarVerticalConstraints];
    self.menuPositionConstraint = menuBarPositionConstraint;
    
    [self.view layoutIfNeeded]; // Layout menu bar off screen initially
    
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
    
    // Add overlay
    [self.view insertSubview:self.overlay belowSubview:self.userMenuVC.view];
    
    // Change menu position constraint
    self.menuPositionConstraint.constant = 0;

    // Animate user menu appearance
    [UIView animateWithDuration:.4
                     animations:^{
                         self.overlay.alpha = 0.5;
                         [self.view layoutIfNeeded];
                     }];
    
    // Add constraints to overview in case of screen rotation
    self.userMenuVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.overlay.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *overlayHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[overlay]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:@{@"overlay":self.overlay}];
    NSArray *overlayVeritcalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[overlay]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:@{@"overlay":self.overlay}];

    [self.view addConstraints:overlayHorizontalConstraints];
    [self.view addConstraints:overlayVeritcalConstraints];
    
    self.isUserMenuShowing = YES;
}

- (void)dismissUserMenu
{
    // Update position constraint
    self.menuPositionConstraint.constant = -USER_MENU_WIDTH;
    
    [UIView animateWithDuration:.4
                     animations:^{
                         self.overlay.alpha = 0;
                         [self.view layoutIfNeeded];
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
