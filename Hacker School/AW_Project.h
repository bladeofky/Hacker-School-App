//
//  AW_Project.h
//  Hacker School
//
//  Created by Alan Wang on 1/28/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AW_Project : NSObject <NSCoding>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *projectDescription;
@property (nonatomic, strong) NSAttributedString *projectDescriptionFormatted;

- (instancetype)initFromJsonObject:(NSDictionary *)projectInfo; //designated

-(NSAttributedString *)formatProjectDescription;

@end
