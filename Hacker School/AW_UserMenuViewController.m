//
//  AW_UserMenuViewController.m
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_UserMenuViewController.h"

#import "AW_Person.h"

@interface AW_UserMenuViewController () <AW_PersonDelegate>


@end

@implementation AW_UserMenuViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - AW_PersonDelegate
-(void)person:(AW_Person *)person didDownloadImage:(UIImage *)image
{
    
}

@end
