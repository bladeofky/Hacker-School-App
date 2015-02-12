//
//  AW_UserMenuViewController.h
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AW_Person, AW_MainViewController;

/**
    The view controller is composed primarily of a table view. This table view displays the current user's picture and name in its header,
    and the navigation options as cells. Tapping on a cell calls the AW_MainViewController to switch to the appropriate view controller.
    A logout button is also provided.
 
    @brief This view controller manages the slide out user menu used to navigate the app.
 */
@interface AW_UserMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) AW_MainViewController *mainVC;      ///< Weak reference to main view controller in order to invoke public methods.
@property (nonatomic, strong) AW_Person *currentUser;           ///< The AW_Person data for the current user. We need this for the image and name.

@property (weak, nonatomic) IBOutlet UITableView *tableView;    ///< Primary component of the user menu's view. Displays user information and options.
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;    ///< Button to log out.

@end
