//
//  AW_WebViewController.m
//  Hacker School
//
//  Created by Alan Wang on 2/4/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_MainViewController.h"
#import "AW_WebViewController.h"

CGFloat const PROGRESS_BAR_HEIGHT = 2.0;

@interface AW_WebViewController () <WKNavigationDelegate>

@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, weak) UIProgressView *progressView;
@property (nonatomic, weak) NSLayoutConstraint *progressViewTopConstraint;

@end

@implementation AW_WebViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;   // This prevents views from being placed beneath the navigation bar

    // Set up web view
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:[self webViewConfiguration]];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    webView.allowsBackForwardNavigationGestures = YES;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    self.webView = webView;

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
    self.navigationItem.rightBarButtonItem.enabled = NO;

    self.navigationItem.title = self.navBarTitle;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Thin" size:20]};
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:0 context:nil];
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

        // Do not animate progress when progress goes backwards (i.e. from 1 to 0).
        if (self.progressView.progress > self.webView.estimatedProgress) {
            [self.progressView setProgress:self.webView.estimatedProgress animated:NO];
        }
        else {
            [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        }

    }
}

#pragma mark - Configuration
-(WKWebViewConfiguration *)webViewConfiguration
{
    // Set up configuration to accept user script
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];

    NSAssert(self.processPool, @"The process pool must be set from AW_MainViewController.");

    configuration.processPool = self.processPool;


    NSString *hideStuffScriptString = [NSString stringWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"hideStuff" withExtension:@"js"]
                                                               encoding:NSUTF8StringEncoding
                                                                  error:NULL];

    WKUserScript *hideStuffScript = [[WKUserScript alloc]initWithSource:hideStuffScriptString
                                                          injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                       forMainFrameOnly:YES];

    [configuration.userContentController addUserScript:hideStuffScript];

    return configuration;
}

#pragma mark - WKNavigationDelegate

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (self.webView.canGoBack) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;

    if (![url.host.lowercaseString hasSuffix:@".recurse.com"]) {
        // This site is not part of recurse.com
        // Pass this off to mobile safari
        [[UIApplication sharedApplication] openURL:url];

        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
