//
//  AW_Project.m
//  Hacker School
//
//  Created by Alan Wang on 1/28/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_Project.h"

@implementation AW_Project

- (instancetype)initFromJsonObject:(NSDictionary *)projectInfo
{
    self = [super init];
    
    if (self) {
        _title = projectInfo[@"title"];
        _urlString = projectInfo[@"url"];
        _descriptionText = projectInfo[@"description"];
    }
    
    return self;
}

-(instancetype)init
{
    [NSException raise:@"Empty AW_Project not allowed" format:@"Use initFromJsonObject instead"];
    
    return nil;
}

@end
