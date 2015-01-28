//
//  AW_Project.h
//  Hacker School
//
//  Created by Alan Wang on 1/28/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AW_Project : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *descriptionText;

- (instancetype)initFromJsonObject:(NSDictionary *)projectInfo; //designated

@end
