//
//  AW_Link.h
//  Hacker School
//
//  Created by Alan Wang on 1/28/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    This class represents a link from the Hacker School profile page. It contains a title and url.
 */
@interface AW_Link : NSObject <NSCoding>

@property (nonatomic, strong) NSString *title;  ///< Name of link
@property (nonatomic, strong) NSURL *url;       ///< URL of link

@end
