//
//  AW_Link.h
//  Hacker School
//
//  Created by Alan Wang on 1/28/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AW_Link : NSObject <NSCoding>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *url;

@end
