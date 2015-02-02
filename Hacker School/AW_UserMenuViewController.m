//
//  AW_UserMenuViewController.m
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_UserMenuViewController.h"

#import "AW_Person.h"

@interface AW_UserMenuViewController ()


@end

@implementation AW_UserMenuViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.tableHeaderView = [self userView];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UITableViewDelegate

#pragma mark - View generators

- (UIView *)userView
{
    // Instantiate views
    UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 220)];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:self.currentUser.image];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [userView addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = [NSString stringWithFormat:@"Welcome, %@", self.currentUser.firstName];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.minimumScaleFactor = 0.75;
    [userView addSubview:nameLabel];
    
    // Add constraints
    NSLayoutConstraint *imageViewCenterXConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:imageView.superview
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                 multiplier:1
                                                                                   constant:0];
    NSLayoutConstraint *nameLabelCenterXConstraint = [NSLayoutConstraint constraintWithItem:nameLabel
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:nameLabel.superview
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                 multiplier:1
                                                                                   constant:0];
    NSArray *imageViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView(==150)]"   //150 is the size of pic
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:@{@"imageView":imageView}];
    NSArray *nameLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[nameLabel]"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:@{@"nameLabel":nameLabel}];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[imageView(==150)]-[nameLabel]-20-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"imageView":imageView,
                                                                                     @"nameLabel":nameLabel}];
    
    [userView addConstraint:imageViewCenterXConstraint];
    [userView addConstraint:nameLabelCenterXConstraint];
    [userView addConstraints:imageViewHorizontalConstraints];
    [userView addConstraints:nameLabelHorizontalConstraints];
    [userView addConstraints:verticalConstraints];
    
    return userView;

}

@end
