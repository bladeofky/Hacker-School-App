//
//  ViewController.m
//  Hacker School
//
//  Created by Alan Wang on 1/20/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "ViewController.h"
#import "NXOAuth2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Hacker School"];
//    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Hacker School" username:@"alanwang100@gmail.com" password:@""];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      // Update your UI
                                                      NSLog(@"New NXOAuth2Account added. Accounts; %@", [[NXOAuth2AccountStore sharedStore] accounts]);
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                                                      object:[NXOAuth2AccountStore sharedStore]
                                                       queue:nil
                                                  usingBlock:^(NSNotification *aNotification){
                                                      NSError *error = [aNotification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
                                                      NSLog(@"Error: %@", error);
                                                  }];
}


@end
