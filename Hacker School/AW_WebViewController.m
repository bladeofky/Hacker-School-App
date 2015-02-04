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

@interface AW_WebViewController ()

@property (nonatomic, weak) WKWebView *webView;

@end

@implementation AW_WebViewController

-(void)viewDidLoad
{
    // Set up web view
    WKWebView *webView = [[WKWebView alloc]init];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:webView];
    self.webView = webView;
    
    NSDictionary *views = @{@"webView":webView};
    NSArray *webViewHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views];
    NSArray *webViewVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webView]|"
                                                                                  options:0
                                                                                  metrics:nil
                                                                                    views:views];
    [self.view addConstraints:webViewHorizontalConstraints];
    [self.view addConstraints:webViewVerticalConstraints];
    
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

@end
