//
//  AW_LoginViewController.m
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_LoginViewController.h"
#import "NXOAuth2.h"

@interface AW_LoginViewController ()

@end

@implementation AW_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Register self with notification center to dismiss self when returning from login through external browser
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didAddNXOAuth2Account)
                                                 name:NXOAuth2AccountStoreAccountsDidChangeNotification
                                               object:nil];
}

- (IBAction)didTapSignInButton:(id)sender {
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Hacker School"];
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
