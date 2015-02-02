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

@interface AW_PeopleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, AW_BatchHeaderViewDelegate, AW_BatchDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) AW_MainViewController *mainVC;

@end
