//
//  AW_UserMenuViewController.h
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AW_Person;

@interface AW_UserMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AW_Person *currentUser;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
