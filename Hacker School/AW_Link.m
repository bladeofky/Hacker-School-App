//
//  AW_Link.m
//  Hacker School
//
//  Created by Alan Wang on 1/28/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_Link.h"

NSString * const LINK_TITLE_KEY = @"title";
NSString * const URL_KEY = @"url";

@implementation AW_Link

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:LINK_TITLE_KEY];
    [aCoder encodeObject:self.url forKey:URL_KEY];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.title = [aDecoder decodeObjectForKey:LINK_TITLE_KEY];
        self.url = [aDecoder decodeObjectForKey:URL_KEY];
    }
    
    return self;
}

@end
