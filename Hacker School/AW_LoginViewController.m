//
//  AW_LoginViewController.m
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_MainViewController.h"
#import "AW_LoginViewController.h"
#import "NXOAuth2.h"

@interface AW_LoginViewController () <UITextFieldDelegate>

@end

@implementation AW_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    // Register self with notification center to dismiss self when returning from login through external browser
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didAddNXOAuth2Account)
                                                 name:NXOAuth2AccountStoreAccountsDidChangeNotification
                                               object:nil];
}


#pragma mark - Notification Responders
- (void)didAddNXOAuth2Account
{
    NSArray *accounts = [[NXOAuth2AccountStore sharedStore]accounts];
    
    if ([accounts count] > 0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];     // Remove self from notification center before dismissing
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
