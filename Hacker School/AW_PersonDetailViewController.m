//
//  AW_PersonDetailViewController.m
//  Hacker School
//
//  Created by Alan Wang on 1/27/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_PersonDetailViewController.h"
#import "AW_Person.h"

@interface AW_PersonDetailViewController ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *contentView;

@end

@implementation AW_PersonDetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up scroll view
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    self.scrollView = scrollView;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];
    
    NSArray *scrollViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:@{@"scrollView":scrollView}];
    NSArray *scrollViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:@{@"scrollView":scrollView}];
    [self.view addConstraints:scrollViewHorizontalConstraints];
    [self.view addConstraints:scrollViewVerticalConstraints];
    
    // Set up content view
    UIView *contentView = [[UIView alloc]init];
    self.contentView = contentView;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:contentView];
    
    NSArray *contentViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:@{@"contentView":contentView}];
    NSLayoutConstraint *contentViewWidthConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:scrollView
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                 multiplier:1
                                                                                   constant:0];
    NSLayoutConstraint *contentViewTopConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                                attribute:NSLayoutAttributeTop
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:scrollView
                                                                                attribute:NSLayoutAttributeTop
                                                                               multiplier:1
                                                                                 constant:0];
    [scrollView addConstraints:contentViewHorizontalConstraints];
    [scrollView addConstraint:contentViewWidthConstraint];
    [scrollView addConstraint:contentViewTopConstraint];
    
    // Add basic info
    UIView *basicInfoView = [self createBasicInfoView];
    [contentView addSubview:basicInfoView];
    
    NSArray *basicInfoViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[basicInfoView]|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:@{@"basicInfoView":basicInfoView}];
    NSArray *basicInfoViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[basicInfoView(==230)]"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:@{@"basicInfoView":basicInfoView}];
    [contentView addConstraints:basicInfoViewHorizontalConstraints];
    [contentView addConstraints:basicInfoViewVerticalConstraints];
    
    // Add bioview
    UIView *bioView = [self createBioView];
    [contentView addSubview:bioView];
    
    NSArray *bioViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bioView]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:@{@"bioView":bioView}];
    NSArray *bioViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[basicInfoView]-20-[bioView]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:@{@"basicInfoView":basicInfoView,
                                                                                            @"bioView":bioView}];
    [contentView addConstraints:bioViewHorizontalConstraints];
    [contentView addConstraints:bioViewVerticalConstraints];
    
    // Test
    UIView *testHeaderView = [self createSectionHeaderWithString:@"test"];
    testHeaderView.frame = CGRectMake(0, 100, 320, 30);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:testHeaderView];

}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

#pragma mark - Create sections
- (UIView *)createBasicInfoView
{
    // This view includes an image of the person, first name, last name, and email
    
    // Instantiate views
    UIView *basicInfoView = [[UIView alloc]init];
    basicInfoView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:self.person.image];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [basicInfoView addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = [NSString stringWithFormat:@"%@ %@", self.person.firstName, self.person.lastName];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:36.0];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.minimumScaleFactor = 0.75;
    [basicInfoView addSubview:nameLabel];
    
    UILabel *emailLabel = [[UILabel alloc]init];
    emailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    emailLabel.text = self.person.email;
    emailLabel.textAlignment = NSTextAlignmentCenter;
    emailLabel.font = [UIFont fontWithName:@"HelventicaNeue" size:17.0];
    emailLabel.adjustsFontSizeToFitWidth = YES;
    emailLabel.minimumScaleFactor = 0.75;
    [basicInfoView addSubview:emailLabel];
    
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
    NSLayoutConstraint *emailLabelCenterXConstsraint = [NSLayoutConstraint constraintWithItem:emailLabel
                                                                                    attribute:NSLayoutAttributeCenterX
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:emailLabel.superview
                                                                                    attribute:NSLayoutAttributeCenterX
                                                                                   multiplier:1
                                                                                     constant:0];
    NSArray *imageViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView(==150)]"   //150 is the size of pic
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:@{@"imageView":imageView}];
    NSArray *nameLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[nameLabel]"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:@{@"nameLabel":nameLabel}];
    NSArray *emailLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[emailLabel]"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:@{@"emailLabel":emailLabel}];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(==150)]-[nameLabel]-[emailLabel(==20)]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"imageView":imageView,
                                                                                     @"nameLabel":nameLabel,
                                                                                     @"emailLabel":emailLabel}];
    
    [basicInfoView addConstraint:imageViewCenterXConstraint];
    [basicInfoView addConstraint:nameLabelCenterXConstraint];
    [basicInfoView addConstraint:emailLabelCenterXConstsraint];
    [basicInfoView addConstraints:imageViewHorizontalConstraints];
    [basicInfoView addConstraints:nameLabelHorizontalConstraints];
    [basicInfoView addConstraints:emailLabelHorizontalConstraints];
    [basicInfoView addConstraints:verticalConstraints];
    
    return basicInfoView;
}

- (UIView *)createBioView
{
    UIView *bioView = [[UIView alloc]init];
    bioView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create views
    UIView *headerView = [self createSectionHeaderWithString:@"Bio"];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [bioView addSubview:headerView];
    
    UILabel *bodyText = [[UILabel alloc]init];
    bodyText.translatesAutoresizingMaskIntoConstraints = NO;
    bodyText.text = self.person.bio;
    bodyText.adjustsFontSizeToFitWidth = NO;
    bodyText.numberOfLines = 0;
    [bioView addSubview:bodyText];
    
    // Create constraints
    NSArray *headerViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerView]|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:@{@"headerView":headerView}];
    NSArray *bodyTextHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[bodyText]-20-|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:@{@"bodyText":bodyText}];
    NSArray *verticalConstsraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerView(==30)]-[bodyText]|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:@{@"headerView":headerView,
                                                                                      @"bodyText":bodyText}];
    
    // Add constraints
    [bioView addConstraints:headerViewHorizontalConstraints];
    [bioView addConstraints:bodyTextHorizontalConstraints];
    [bioView addConstraints:verticalConstsraints];
    
    return bioView;
}

- (UIView *)createSectionHeaderWithString:(NSString *)title
{
    UIView *headerView = [[UIView alloc]init];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *titleCaps = [title uppercaseString];
    
    // Instantiate objects
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = titleCaps;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:lineView];
    
    // Set up constraints
    NSArray *titleLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[titleLabel]-20-|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:@{@"titleLabel":titleLabel}];
    NSArray *lineViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[lineView]-20-|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:@{@"lineView":lineView}];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]-4-[lineView(==1)]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"titleLabel":titleLabel,
                                                                                     @"lineView":lineView}];
    
    // Add constraints
    [headerView addConstraints:titleLabelHorizontalConstraints];
    [headerView addConstraints:lineViewHorizontalConstraints];
    [headerView addConstraints:verticalConstraints];
    
    return headerView;
}

@end
