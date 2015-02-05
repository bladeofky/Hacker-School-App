//
//  AW_WebViewController.m
//  Hacker School
//
//  Created by Alan Wang on 2/4/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "AW_MainViewController.h"
#import "AW_WebViewController.h"

CGFloat const PROGRESS_BAR_HEIGHT = 2.0;

@interface AW_WebViewController ()

@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, weak) UIProgressView *progressView;
@property (nonatomic, weak) NSLayoutConstraint *progressViewTopConstraint;

@end

@implementation AW_WebViewController

-(void)viewDidLoad
{
    self.navigationController.navigationBar.translucent = NO;   // This prevents views from being placed beneath the navigation bar
    
    // Set up web view
    WKWebView *webView = [[WKWebView alloc]init];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:webView];
    self.webView = webView;
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:0 context:nil];
    
    // Set up progress bar
    UIProgressView *progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    NSDictionary *views = @{@"webView":webView,
                            @"progressView":progressView};
    NSArray *webViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views];
    NSArray *progressViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[progressView]|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:views];
    NSString *verticalConstraintString = [NSString stringWithFormat:@"V:[progressView(==%f)][webView]|", PROGRESS_BAR_HEIGHT];
    NSArray *webViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:verticalConstraintString
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:views];
    NSLayoutConstraint *progressBarTopConstraint = [NSLayoutConstraint constraintWithItem:progressView
                                                                                attribute:NSLayoutAttributeTop
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.view
                                                                                attribute:NSLayoutAttributeTop
                                                                               multiplier:1
                                                                                 constant:-PROGRESS_BAR_HEIGHT];
    [self.view addConstraints:webViewHorizontalConstraints];
    [self.view addConstraints:progressViewHorizontalConstraints];
    [self.view addConstraints:webViewVerticalConstraints];
    [self.view addConstraint:progressBarTopConstraint];
    self.progressViewTopConstraint = progressBarTopConstraint;
    
    [self.view layoutIfNeeded];
    
    // Load URL
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [webView loadRequest:request];
    
    // Set up navigation
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Menu"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self.mainVC
                                                                           action:@selector(showUserMenu)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self.webView
                                                                            action:@selector(goBack)];
    self.navigationItem.title = self.navBarTitle;
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Remove self from KVO
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        // Hide progress bar when not useful
        if (self.webView.estimatedProgress > 0 && self.webView.estimatedProgress < 1) {
            self.progressViewTopConstraint.constant = 0;
            
            [self.view layoutIfNeeded];
        }
        else {
            self.progressViewTopConstraint.constant = -PROGRESS_BAR_HEIGHT;
            
            [self.view layoutIfNeeded];
        }
        
        if (self.progressView.progress > self.webView.estimatedProgress) {
            [self.progressView setProgress:self.webView.estimatedProgress animated:NO];
        }
        else {
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        }
        
    }
}

@end
