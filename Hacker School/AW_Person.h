//
//  AW_Person.h
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AW_Batch, AW_Person;

@protocol AW_PersonDelegate <NSObject>

@optional
- (void)person:(AW_Person *)person didDownloadImage:(UIImage *)image;

@end

@interface AW_Person : NSObject

// Based on Hacker School API v1
@property (nonatomic, strong) NSNumber *idNumber;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *twitterUserName;
@property (nonatomic, strong) NSString *githubUserName;
@property (nonatomic, strong) NSNumber *batchID;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, strong) NSArray *skills;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<AW_PersonDelegate> delegate;

- (instancetype)initWithHackerSchoolAPIData:(NSData *)data; // Designated

@end

