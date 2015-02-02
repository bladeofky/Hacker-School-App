//
//  AW_PersonDetailViewController.m
//  Hacker School
//
//  Created by Alan Wang on 1/27/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_PersonDetailViewController.h"
#import "AW_Batch.h"
#import "AW_Person.h"
#import "AW_Project.h"
#import "AW_Link.h"

@interface AW_PersonDetailViewController () <UITextViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *contentView;

// We need the following 4 weak properties in order to know what button we pressed in our UIButtonDelegate
@property (nonatomic, weak) UIButton *phoneButton;
@property (nonatomic, weak) UIButton *emailButton;
@property (nonatomic, weak) UIButton *githubButton;
@property (nonatomic, weak) UIButton *twitterButton;

@end

@implementation AW_PersonDetailViewController

#pragma mark - Accessors

#pragma mark - Intializers

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // --- Set up Navigation bar ---
    if (self.person.isFaculty) {
        self.navigationItem.title = @"Faculty";
    }
    else if (self.person.isHackerSchooler) {
        self.navigationItem.title = @"Student";
    }
    
    
    // ---- Set up scroll view ---
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    self.scrollView = scrollView;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
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
    
    // --- Set up content view ---
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
    
    UIView *previousView;
    
    // --- Add basic info ---
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
    
    // --- Add contact buttons ---
    UIView *contactView = [self createContactView];
    [contentView addSubview:contactView];
    
    NSLayoutConstraint *contactViewHorizontalConstraints = [NSLayoutConstraint constraintWithItem:contactView
                                                                                        attribute:NSLayoutAttributeCenterX
                                                                                        relatedBy:NSLayoutRelationEqual
                                                                                           toItem:contactView.superview
                                                                                        attribute:NSLayoutAttributeCenterX
                                                                                       multiplier:1
                                                                                         constant:0];
    NSArray *contactViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[basicInfoView]-20-[contactView]"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:@{@"basicInfoView":basicInfoView,
                                                                                                @"contactView":contactView}];
    [contentView addConstraint:contactViewHorizontalConstraints];
    [contentView addConstraints:contactViewVerticalConstraints];
    
    previousView = contactView;
    
    // --- Add skillsView if not empty ---
    if (![self.person.skills isEqual:@[]]) {
        UIView *skillsView = [self createSkillsView];
        [contentView addSubview:skillsView];
        
        NSArray *skillsViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[skillsView]|"
                                                                                           options:0
                                                                                           metrics:nil
                                                                                             views:@{@"skillsView":skillsView}];
        NSArray *skillsViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousView]-20-[skillsView]"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:@{@"previousView":previousView,
                                                                                                   @"skillsView":skillsView}];
        [contentView addConstraints:skillsViewHorizontalConstraints];
        [contentView addConstraints:skillsViewVerticalConstraints];
        
        previousView = skillsView;
    }

    // --- Add projectsView if not empty ---
    if (![self.person.projects isEqual:@[]]) {
        UIView *projectsView = [self createProjectsView];
        [contentView addSubview:projectsView];
        
        NSArray *projectsViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[projectsView]|"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:@{@"projectsView":projectsView}];
        NSArray *projectsViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousView]-20-[projectsView]"
                                                                                           options:0
                                                                                           metrics:nil
                                                                                             views:@{@"previousView":previousView,
                                                                                                     @"projectsView":projectsView}];
        [contentView addConstraints:projectsViewHorizontalConstraints];
        [contentView addConstraints:projectsViewVerticalConstraints];
        
        previousView = projectsView;
    }
    
    // --- Add bioview if not empty ---
    if (![self.person.bio isEqualToString:@""]) {
        UIView *bioView = [self createBioView];
        [contentView addSubview:bioView];
        
        NSArray *bioViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bioView]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:@{@"bioView":bioView}];
        NSArray *bioViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousView]-20-[bioView]"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:@{@"previousView":previousView,
                                                                                                @"bioView":bioView}];
        [contentView addConstraints:bioViewHorizontalConstraints];
        [contentView addConstraints:bioViewVerticalConstraints];
        
        previousView = bioView;
    }
    
    // --- Add links view ---
    if (![self.person.links isEqual:@[]]) {
        UIView *linksView = [self createLinksView];
        [contentView addSubview:linksView];
        
        NSArray *linksViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[linksView]|"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:@{@"linksView":linksView}];
        NSArray *linksViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousView]-20-[linksView]"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:@{@"previousView":previousView,
                                                                                                  @"linksView":linksView}];
        
        [contentView addConstraints:linksViewHorizontalConstraints];
        [contentView addConstraints:linksViewVerticalConstraints];
        
        previousView = linksView;
    }
    
    // Add bottom constraint
    NSArray *bottomConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousView]-(20)-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{@"previousView":previousView}];
    [contentView addConstraints:bottomConstraint];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // After autolayout has laid out views, set scroll view content size
    self.scrollView.contentSize = self.contentView.bounds.size;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // This is required to reset the scroll view's content size upon screen rotation
    [self viewWillLayoutSubviews];
    [self.view layoutSubviews];
    [self viewDidLayoutSubviews];
}

#pragma mark - Create sections
- (UIView *)createBasicInfoView
{
    // This view includes an image of the person, first name, last name, and batch
    
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
    
    UILabel *batchLabel = [[UILabel alloc]init];
    batchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    batchLabel.text = self.person.batch.apiName;
    batchLabel.textAlignment = NSTextAlignmentCenter;
    batchLabel.font = [UIFont fontWithName:@"HelventicaNeue" size:17.0];
    batchLabel.adjustsFontSizeToFitWidth = YES;
    batchLabel.minimumScaleFactor = 0.75;
    [basicInfoView addSubview:batchLabel];
    
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
    NSLayoutConstraint *emailLabelCenterXConstsraint = [NSLayoutConstraint constraintWithItem:batchLabel
                                                                                    attribute:NSLayoutAttributeCenterX
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:batchLabel.superview
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
    NSArray *emailLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[batchLabel]"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:@{@"batchLabel":batchLabel}];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(==150)]-[nameLabel]-[batchLabel(==20)]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"imageView":imageView,
                                                                                     @"nameLabel":nameLabel,
                                                                                     @"batchLabel":batchLabel}];
    
    [basicInfoView addConstraint:imageViewCenterXConstraint];
    [basicInfoView addConstraint:nameLabelCenterXConstraint];
    [basicInfoView addConstraint:emailLabelCenterXConstsraint];
    [basicInfoView addConstraints:imageViewHorizontalConstraints];
    [basicInfoView addConstraints:nameLabelHorizontalConstraints];
    [basicInfoView addConstraints:emailLabelHorizontalConstraints];
    [basicInfoView addConstraints:verticalConstraints];
    
    return basicInfoView;
}

- (UIView *)createContactView
{
    UIView *contactView = [[UIView alloc]init];
    contactView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create icon buttons
    UIButton *phoneButton = [[UIButton alloc]init];
    phoneButton.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *phoneIcon = [[UIImage imageNamed:@"PhoneIcon.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [phoneButton setImage:phoneIcon forState:UIControlStateNormal];
    phoneButton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [phoneButton addTarget:self action:@selector(didPressContactButton:) forControlEvents:UIControlEventTouchUpInside];
    self.phoneButton = phoneButton;
    [contactView addSubview:phoneButton];
    
    UIButton *emailButton = [[UIButton alloc]init];
    emailButton.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *emailIcon = [[UIImage imageNamed:@"EmailIcon.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [emailButton setImage:emailIcon forState:UIControlStateNormal];
    [emailButton addTarget:self action:@selector(didPressContactButton:) forControlEvents:UIControlEventTouchUpInside];
    self.emailButton = emailButton;
    [contactView addSubview:emailButton];
    
    UIButton *githubButton = [[UIButton alloc]init];
    githubButton.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *githubIcon = [[UIImage imageNamed:@"GithubIcon.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [githubButton setImage:githubIcon forState:UIControlStateNormal];
    githubButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    [githubButton addTarget:self action:@selector(didPressContactButton:) forControlEvents:UIControlEventTouchUpInside];
    self.githubButton = githubButton;
    [contactView addSubview:githubButton];
    
    UIButton *twitterButton = [[UIButton alloc]init];
    twitterButton.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *twitterIcon = [[UIImage imageNamed:@"TwitterIcon.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [twitterButton setImage:twitterIcon forState:UIControlStateNormal];
    [twitterButton addTarget:self action:@selector(didPressContactButton:) forControlEvents:UIControlEventTouchUpInside];
    self.twitterButton = twitterButton;
    [contactView addSubview:twitterButton];
    
    // Disable inactive buttons
    if ([self.person.phoneNumber isKindOfClass:[NSNull class]] || [self.person.phoneNumber isEqualToString:@""]) {
        phoneButton.enabled = NO;
        phoneButton.alpha = 0.5;
    }
    if ([self.person.email isKindOfClass:[NSNull class]] || [self.person.email isEqualToString:@""]) {
        emailButton.enabled = NO;
        emailButton.alpha = 0.5;
    }
    if ([self.person.githubUserName isKindOfClass:[NSNull class]] || [self.person.githubUserName isEqualToString:@""]) {
        githubButton.enabled = NO;
        githubButton.alpha = 0.5;
    }
    if ([self.person.twitterUserName isKindOfClass:[NSNull class]] || [self.person.twitterUserName isEqualToString:@""]) {
        twitterButton.enabled = NO;
        twitterButton.alpha = 0.5;
    }
    
    // Add autolayout constraints
    NSDictionary *views = @{@"phoneButton":phoneButton,
                            @"emailButton":emailButton,
                            @"githubButton":githubButton,
                            @"twitterButton":twitterButton};
    
    NSArray *buttonsHorizontalConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[phoneButton(==44)]-20-[emailButton(==44)]-20-[githubButton(==44)]-20-[twitterButton(==44)]|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:views];
    NSArray *phoneButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[phoneButton(==44)]|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:views];
    NSArray *emailButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[emailButton(==44)]|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:views];
    NSArray *githubButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[githubButton(==44)]|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:views];
    NSArray *twitterButtonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[twitterButton(==44)]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:views];
    [contactView addConstraints:buttonsHorizontalConstraint];
    [contactView addConstraints:phoneButtonVerticalConstraints];
    [contactView addConstraints:emailButtonVerticalConstraints];
    [contactView addConstraints:githubButtonVerticalConstraints];
    [contactView addConstraints:twitterButtonVerticalConstraints];
    
    return contactView;
}

- (UIView *)createSkillsView
{
    UIView *skillsView = [[UIView alloc]init];
    skillsView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create views
    UIView *headerView = [self createSectionHeaderWithString:@"Skills"];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [skillsView addSubview:headerView];
    
    UITextView *bodyText = [[UITextView alloc]init];
    bodyText.translatesAutoresizingMaskIntoConstraints = NO;
    bodyText.text = self.person.bio;
    bodyText.scrollEnabled = NO;
    bodyText.editable = NO;
    bodyText.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
    [skillsView addSubview:bodyText];
    
    // Generate text
    NSMutableString *bodyTextString = [[NSMutableString alloc]init];
    for (NSString *skillString in self.person.skills) {
        [bodyTextString appendString:[NSString stringWithFormat:@"\u2022 %@\n", skillString]];
    }
    bodyText.text = [bodyTextString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
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
    [skillsView addConstraints:headerViewHorizontalConstraints];
    [skillsView addConstraints:bodyTextHorizontalConstraints];
    [skillsView addConstraints:verticalConstsraints];
    
    return skillsView;
}

- (UIView *)createProjectsView
{
    UIView *projectsView = [[UIView alloc]init];
    projectsView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // --- Set up header view ---
    UIView *headerView = [self createSectionHeaderWithString:@"Projects"];
    [projectsView addSubview:headerView];
    
    NSArray *headerViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerView]|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:@{@"headerView":headerView}];
    NSArray *headerViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerView(==30)]"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:@{@"headerView":headerView}];
    [projectsView addConstraints:headerViewHorizontalConstraints];
    [projectsView addConstraints:headerViewVerticalConstraints];
    
    // --- Set up project views ---
    if ([self.person.projects count] != 0) {
        // There are projects
        // Add the first project
        UIView *firstProjectView = [self createProjectViewWithProject:self.person.projects[0]];
        [projectsView addSubview:firstProjectView];
        
        NSArray *firstProjectViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[firstProjectView]|"
                                                                                                 options:0
                                                                                                 metrics:nil
                                                                                                   views:@{@"firstProjectView":firstProjectView}];
        NSArray *firstProjectViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[headerView]-[firstProjectView]"
                                                                                               options:0
                                                                                               metrics:nil
                                                                                                 views:@{@"headerView":headerView,
                                                                                                         @"firstProjectView":firstProjectView}];
        [projectsView addConstraints:firstProjectViewHorizontalConstraints];
        [projectsView addConstraints:firstProjectViewVerticalConstraints];
        
        UIView *previousProjectView = firstProjectView;
        
        if ([self.person.projects count] > 1) {
            // There are more projects. Add them iteratively.
            
            for (int index = 1; index < [self.person.projects count]; index++) {
                AW_Project *nextProject = self.person.projects[index];
                UIView *nextProjectView = [self createProjectViewWithProject:nextProject];
                [projectsView addSubview:nextProjectView];
                
                NSArray *nextProjectHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nextProjectView]|"
                                                                                                    options:0
                                                                                                    metrics:nil
                                                                                                      views:@{@"nextProjectView":nextProjectView}];
                NSArray *nextProjectVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousProjectView]-16-[nextProjectView]"
                                                                                                  options:0
                                                                                                  metrics:nil
                                                                                                    views:@{@"previousProjectView":previousProjectView,
                                                                                                            @"nextProjectView":nextProjectView}];
                [projectsView addConstraints:nextProjectHorizontalConstraints];
                [projectsView addConstraints:nextProjectVerticalConstraints];
                
                previousProjectView = nextProjectView; // Update reference
                
            } //  end for projects
        } // end if there are more than 1 projects
        
        // Add the final constraint to bottom of superview
        NSArray *finalProjectBottomConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousProjectView]|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:@{@"previousProjectView":previousProjectView}];
        [projectsView addConstraints:finalProjectBottomConstraints];
    } // end if there are projects
    
    else {
        // Constrain bottom of header view to bottom of superview (since there are no projects)
        NSArray *headerViewBottomConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[headerView]|"
                                                                                      options:0
                                                                                      metrics:nil
                                                                                        views:@{@"headerView":headerView}];
        [projectsView addConstraints:headerViewBottomConstraint];
    } // end else if there are no projects
    
    return projectsView;
}

- (UIView *)createBioView
{
    UIView *bioView = [[UIView alloc]init];
    bioView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create views
    UIView *headerView = [self createSectionHeaderWithString:@"Bio"];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [bioView addSubview:headerView];
    
    UITextView *bodyText = [[UITextView alloc]init];
    bodyText.scrollEnabled = NO;
    bodyText.editable = NO;
    bodyText.translatesAutoresizingMaskIntoConstraints = NO;

    if (!self.person.bioFormmated) {
        [self.person formatBio];    // Can only be done on the main thread
    }
    bodyText.attributedText = self.person.bioFormmated;
    
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

- (UIView *)createLinksView
{
    UIView *linksView = [[UIView alloc]init];
    linksView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create header view
    UIView *headerView = [self createSectionHeaderWithString:@"Other Links"];
    [linksView addSubview:headerView];
    
    NSArray *headerViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerView]|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:@{@"headerView":headerView}];
    NSArray *headerViewTopConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerView]"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"headerView":headerView}];
    [linksView addConstraints:headerViewHorizontalConstraints];
    [linksView addConstraints:headerViewTopConstraint];
    
    UIView *previousView = headerView;
    
    // Add links
    for (AW_Link *link in self.person.links) {
        UITextView *linkTextView = [[UITextView alloc]init];
        linkTextView.translatesAutoresizingMaskIntoConstraints = NO;
        linkTextView.scrollEnabled = NO;
        linkTextView.editable = NO;
        [linksView addSubview:linkTextView];
        
        NSDictionary *attributes = @{NSLinkAttributeName:link.url,
                                     NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]};
        NSAttributedString *title = [[NSAttributedString alloc]initWithString:link.title attributes:attributes];
        linkTextView.attributedText = title;
        
        // Add constraints
        NSArray *linkTextViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[linkTextView]"
                                                                                             options:0
                                                                                             metrics:nil
                                                                                               views:@{@"linkTextView":linkTextView}];
        NSArray *linkTextViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousView]-[linkTextView]"
                                                                                           options:0
                                                                                           metrics:nil
                                                                                             views:@{@"previousView":previousView,
                                                                                                     @"linkTextView":linkTextView}];
        [linksView addConstraints:linkTextViewHorizontalConstraints];
        [linksView addConstraints:linkTextViewVerticalConstraints];
        
        previousView = linkTextView;
    }
    
    // Add final constraint
    NSArray *finalBottomConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousView]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:@{@"previousView":previousView}];
    [linksView addConstraints:finalBottomConstraint];
    
    return linksView;
}

#pragma mark - Helper methods
- (UIView *)createProjectViewWithProject:(AW_Project *)project
{
    UIView *projectView = [[UIView alloc]init];
    projectView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create title label
    UITextView *titleLabel = [[UITextView alloc]init];
    titleLabel.editable = NO;
    titleLabel.scrollEnabled = NO;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc]initWithString:project.title];
    [titleAttributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:project.urlString] range:NSMakeRange(0, titleAttributedString.length)];
    titleLabel.attributedText = titleAttributedString;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    [projectView addSubview:titleLabel];
    
    // Create body text
    UITextView *bodyText = [[UITextView alloc]init];
    bodyText.delegate = self;
    bodyText.translatesAutoresizingMaskIntoConstraints = NO;
    bodyText.scrollEnabled = NO;
    bodyText.editable = NO;

    if (!project.projectDescriptionFormatted) {
        [project formatProjectDescription];
    }
    bodyText.attributedText = project.projectDescriptionFormatted;
    [projectView addSubview:bodyText];
    
    // Create autolayout constraints
    NSArray *titleLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[titleLabel]-(>=20)-|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:@{@"titleLabel":titleLabel}];
    NSArray *bodyTextHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[bodyText]-20-|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:@{@"bodyText":bodyText}];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel(==30)]-0-[bodyText]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"titleLabel":titleLabel,
                                                                                     @"bodyText":bodyText}];
    [projectView addConstraints:titleLabelHorizontalConstraints];
    [projectView addConstraints:bodyTextHorizontalConstraints];
    [projectView addConstraints:verticalConstraints];
    
    return projectView;
}

- (UIView *)createSectionHeaderWithString:(NSString *)title
{
    UIView *headerView = [[UIView alloc]init];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *titleCaps = [title uppercaseString];
    
    // Instantiate objects
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = titleCaps;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:19];
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

#pragma mark - Event handling
- (void)didPressContactButton:(UIButton *)sender
{
    // Determine which URL to use
    NSURL *urlToFollow;
    
    if (sender == self.phoneButton) {
        urlToFollow = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.person.phoneNumber]];
    }
    else if (sender == self.emailButton) {
        urlToFollow = [NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", self.person.email]];
    }
    else if (sender == self.githubButton) {
        urlToFollow = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.github.com/%@", self.person.githubUserName]];
    }
    else if (sender == self.twitterButton) {
        urlToFollow = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.twitter.com/%@", self.person.twitterUserName]];
    }
    else {
        NSLog(@"Unrecognized button pressed");
        return;
    }
    
    // Invoke action
    [[UIApplication sharedApplication]openURL:urlToFollow];
}

@end
