//
//  AW_PersonDetailViewController.m
//  Hacker School
//
//  Created by Alan Wang on 1/27/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_PersonDetailViewController.h"
#import "AW_Person.h"
#import "AW_Project.h"

@interface AW_PersonDetailViewController () <UITextViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *contentView;

@end

@implementation AW_PersonDetailViewController

#pragma mark - Accessors

#pragma mark - Intializers

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // ---- Set up scroll view ---
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
    
    // --- Add skillsView ---
    UIView *skillsView = [self createSkillsView];
    [contentView addSubview:skillsView];
    
    NSArray *skillsViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[skillsView]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:@{@"skillsView":skillsView}];
    NSArray *skillsViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[basicInfoView]-20-[skillsView]"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:@{@"basicInfoView":basicInfoView,
                                                                                            @"skillsView":skillsView}];
    [contentView addConstraints:skillsViewHorizontalConstraints];
    [contentView addConstraints:skillsViewVerticalConstraints];
    
    
    // --- Add projectsView ---
    UIView *projectsView = [self createProjectsView];
    [contentView addSubview:projectsView];
    
    NSArray *projectsViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[projectsView]|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:@{@"projectsView":projectsView}];
    NSArray *projectsViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[skillsView]-20-[projectsView]"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:@{@"skillsView":skillsView,
                                                                                               @"projectsView":projectsView}];
    [contentView addConstraints:projectsViewHorizontalConstraints];
    [contentView addConstraints:projectsViewVerticalConstraints];
    
    // --- Add bioview ---
    UIView *bioView = [self createBioView];
    [contentView addSubview:bioView];
    
    NSArray *bioViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bioView]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:@{@"bioView":bioView}];
    NSArray *bioViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[projectsView]-20-[bioView]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:@{@"projectsView":projectsView,
                                                                                            @"bioView":bioView}];
    [contentView addConstraints:bioViewHorizontalConstraints];
    [contentView addConstraints:bioViewVerticalConstraints];
    
    
    
//    // Test
//    UIView *testHeaderView = [self createSectionHeaderWithString:@"test"];
//    testHeaderView.frame = CGRectMake(0, 100, 320, 30);
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:testHeaderView];

}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // After autolayout has laid out views, set scroll view content size
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

- (UIView *)createSkillsView
{
    UIView *skillsView = [[UIView alloc]init];
    skillsView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Create views
    UIView *headerView = [self createSectionHeaderWithString:@"Skills"];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [skillsView addSubview:headerView];
    
    UILabel *bodyText = [[UILabel alloc]init];
    bodyText.translatesAutoresizingMaskIntoConstraints = NO;
    bodyText.text = self.person.bio;
    bodyText.adjustsFontSizeToFitWidth = NO;
    bodyText.numberOfLines = 0;
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
    NSString *htmlBio = self.person.bio;
    htmlBio = [htmlBio stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    htmlBio = [NSString stringWithFormat:@"<span style=\"font-family: HelveticaNeue; font-size: 17; color: black;\">%@</span>", htmlBio];
    NSAttributedString *attributedBio = [[NSAttributedString alloc]initWithData:[htmlBio dataUsingEncoding:NSUTF8StringEncoding]
                                                                                       options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                            documentAttributes:nil
                                                                                         error:nil];
    bodyText.attributedText = attributedBio;

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
    NSString *htmlProjectDescription = project.projectDescription;
    htmlProjectDescription = [htmlProjectDescription stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    htmlProjectDescription = [NSString stringWithFormat:@"<span style=\"font-family: HelveticaNeue; font-size: 17; color: black;\">%@</span>", htmlProjectDescription];
    NSAttributedString *attributedProjectDescription = [[NSAttributedString alloc]initWithData:[htmlProjectDescription dataUsingEncoding:NSUTF8StringEncoding]
                                                                                       options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                            documentAttributes:nil
                                                                                         error:nil];
    bodyText.attributedText = attributedProjectDescription;
    [projectView addSubview:bodyText];
    
    // Create autolayout constraints
    NSArray *titleLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[titleLabel]-20-|"
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


@end
