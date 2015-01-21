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
    

}


@end
