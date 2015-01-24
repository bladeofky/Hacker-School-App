//
//  AW_PeopleViewController.h
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_BatchHeaderView.h"

@class NXOAuth2Account;

@interface AW_PeopleViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, AW_BatchHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
