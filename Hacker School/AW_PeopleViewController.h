//
//  AW_PeopleViewController.h
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_BatchHeaderView.h"
#import "AW_BatchDelegate.h"

@class NXOAuth2Account, AW_MainViewController;

/**
    This view controller presents a table view, but uses it in a non-traditional way. The goal is to have a "drawer" effect where tapping on the
    batch name causes a "drawer" to slide down, displaying images of all the people in that batch. Tapping on the batch name again closes the "drawer."
    Tapping on a person's image navigates to a detail view of that person's information.
 
    When the view is loaded, information about all batches is loaded into memory (either downloaded, or unarchived). When a batch is tapped, information
    for EVERY ONE of that batch's people is loaded. The view controller displays a loading screen when downloading a batch's people from the web,
    and while formatting a person's information.
 
    The Reload button displayed on the right side of the navigation bar removes all batches (and people) from memory and re-downloads the list of batches from
    the Hacker School API. Batches and people currently loaded will be saved when the application moves to the background.
 
    @brief View controller to browse Hacker Schoolers. Analogous to the People page of the Hacker School website.
 */
@interface AW_PeopleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, AW_BatchHeaderViewDelegate, AW_BatchDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) AW_MainViewController *mainVC;

@end
