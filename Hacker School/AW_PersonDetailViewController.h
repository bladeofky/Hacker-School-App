//
//  AW_PersonDetailViewController.h
//  Hacker School
//
//  Created by Alan Wang on 1/27/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AW_Person;

/**
    This view controller displays a detailed view of an AW_Person's information, including his/her image, full name, contact information, skills,
    projects, bio, and other links.
 */
@interface AW_PersonDetailViewController : UIViewController

@property (nonatomic, strong) AW_Person *person;    ///< The person whose information is being displayed.

@end
