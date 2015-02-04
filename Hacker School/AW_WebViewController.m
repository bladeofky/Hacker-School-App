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
    //    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    self.webView = webView;
    
    NSURL *url = [NSURL URLWithString:@"https://community.hackerschool.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
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
    
}

@end
