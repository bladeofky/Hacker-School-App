//
//  AW_MainViewController.h
//  Hacker School
//
//  Created by Alan Wang on 1/22/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

/*
 This is the parent view controller that will manage the center view controller (which may change depending on what task
 the user is currently executing (i.e. People, Community, Booker, etc.) and the slide out menu view controller. For more
 information on container view controllers, see: https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/CreatingCustomContainerViewControllers/CreatingCustomContainerViewControllers.html
 
 Because this view controller is always active, this will be a good place to make sure a user is always logged in, and to
 present the log in screen if they are not.
 */

#import <UIKit/UIKit.h>

@interface AW_MainViewController : UIViewController

- (void)showUserMenu;
- (void)logout;

@end
