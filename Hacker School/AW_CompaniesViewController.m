//
//  AW_CompaniesViewController.m
//  Hacker School
//
//  Created by Alan Wang on 2/24/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_CompaniesViewController.h"

@interface AW_CompaniesViewController ()

@end

@implementation AW_CompaniesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Configuration
-(WKWebViewConfiguration *)webViewConfiguration
{
    // Set up configuration to accept user script
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    
    NSAssert(self.processPool, @"The process pool must be set from AW_MainViewController.");
    
    configuration.processPool = self.processPool;
    
    
        NSString *hideStuffScriptString = [NSString stringWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"companies" withExtension:@"js"]
                                                                   encoding:NSUTF8StringEncoding
                                                                      error:NULL];
    
        WKUserScript *hideStuffScript = [[WKUserScript alloc]initWithSource:hideStuffScriptString
                                                              injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                           forMainFrameOnly:YES];
    
        [configuration.userContentController addUserScript:hideStuffScript];
    
    return configuration;
}

@end
