//
//  AW_MainViewController.h
//  Hacker School
//
//  Created by Alan Wang on 1/22/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//



#import <UIKit/UIKit.h>

extern NSString * const PEOPLE_VC_TAG;
extern NSString * const PROJECTS_VC_TAG;
extern NSString * const COMPANIES_VC_TAG;
extern NSString * const RESIDENTS_VC_TAG;
extern NSString * const BLOG_VC_TAG;

extern NSString * const COMMUNITY_VC_TAG;

extern NSString * const BOOKER_VC_TAG;
extern NSString * const GROUPS_VC_TAG;
extern NSString * const RECOMMEND_VC_TAG;
extern NSString * const USER_MANUAL_VC_TAG;
extern NSString * const SETTINGS_VC_TAG;


/**
 This is the parent view controller that will manage the center view controller (which may change depending on what task
 the user is currently executing (i.e. People, Community, Booker, etc.) and the slide out menu view controller. For more
 information on container view controllers, see: https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/CreatingCustomContainerViewControllers/CreatingCustomContainerViewControllers.html
 
 Because this view controller is always active, this will be a good place to make sure a user is always logged in, and to
 present the log in screen if they are not.
 */
@interface AW_MainViewController : UIViewController

/**
    Instantiates and animates the user menu bar sliding out from the left side of the screen.
    @brief Displays the slide out user menu.
 */
- (void)showUserMenu;

/**
    Animates the user menu bar sliding closed to the left side of the screen. Deallocates the user menu view controller.
 
    @brief Dismisses the user menu bar.
 */
- (void)dismissUserMenu;

/**
    Logs out the current user and modally presents the log in view controller.
 */
- (void)logout;

/**
    This method changes which view controller is in effect for the center view. It removes the previous view controller (which should dealloc it),
    instantiates and adds the new view controller based on which option is chosen. The @b option NSString is one of the global string constants
    defined at the top of the AW_MainViewController.h file.
 
    @brief Changes the view controller displayed in the center view depending on the option string provided.
 */
- (void)displayCenterControllerForOption:(NSString *)option;

@end
