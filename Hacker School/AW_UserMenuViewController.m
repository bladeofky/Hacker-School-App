//
//  AW_UserMenuViewController.m
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_MainViewController.h"
#import "AW_UserMenuViewController.h"

#import "AW_Person.h"

@interface AW_UserMenuViewController ()

@property (nonatomic, strong) NSArray *tableViewData;

@end

@implementation AW_UserMenuViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // --- Set up table view ---
    self.tableView.tableHeaderView = [self userView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    /* Note: I have commented out some of the options, since they present web pages that are not optimized for mobile. I'm afraid
     Apple will reject the app because of them. */
    self.tableViewData = @[ // Browse
                            @[PEOPLE_VC_TAG,
                              // PROJECTS_VC_TAG,
                              COMPANIES_VC_TAG,
                              RESIDENTS_VC_TAG,
                              BLOG_VC_TAG],
                            // Connect
                            @[COMMUNITY_VC_TAG],
                            // Tools
                            @[// BOOKER_VC_TAG,
                              // GROUPS_VC_TAG,
                              RECOMMEND_VC_TAG,
                              USER_MANUAL_VC_TAG,
                              // SETTINGS_VC_TAG
                              ]
                            ];
    
    // --- Set up logout butotn ---
    [self.logoutButton addTarget:self.mainVC action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableViewData count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableViewData[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    cell.textLabel.text = self.tableViewData[section][row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    
    // Change selection color
    UIView *selectedBackgroundView = [[UIView alloc]init];
    selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.5 green:0.9 blue:0.5 alpha:0.5];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *sectionTitles = @[ @"Browse",
                                @"Connect",
                                @"Tools"];
    
    return sectionTitles[section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    [self.mainVC displayCenterControllerForOption:self.tableViewData[section][row]];
    [self.mainVC dismissUserMenu];
}

#pragma mark - View generators

- (UIView *)userView
{
    // Instantiate views
    UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 240)];
    
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
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[imageView(==150)]-20-[nameLabel]-20-|"
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
