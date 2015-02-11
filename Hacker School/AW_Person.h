//
//  AW_Person.h
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AW_PersonDelegate.h"

@class AW_Batch, AW_Person;

/**
 This class represents a person in Hacker School.
 */
@interface AW_Person : NSObject <NSCoding>

// Based on Hacker School API v1
@property (nonatomic, strong) NSNumber *idNumber;                   ///< ID Number of the person as defined by Hacker School.

@property (nonatomic, strong) NSString *firstName;                  ///< First name of the person.
@property (nonatomic, strong) NSString *middleName;                 ///< Middle name of the person.
@property (nonatomic, strong) NSString *lastName;                   ///< Last name of the person.

@property (nonatomic, strong) NSString *phoneNumber;                ///< Phone number of the person. NSNull or empty string if missing.
@property (nonatomic, strong) NSString *email;                      ///< Email of the person. NSNull or empty string if missing.
@property (nonatomic, strong) NSString *twitterUserName;            ///< Twitter user name. NSNull or empty string if missing.
@property (nonatomic, strong) NSString *githubUserName;             ///< GitHub user name. NSNull or empty string if missing.

@property (nonatomic, strong) NSString *job;                        ///< Person's job.
@property (nonatomic, strong) NSArray *skills;                      ///< Collection of skills. Currently, skills are implemented as NSStrings.
@property (nonatomic, strong) UIImage *image;                       ///< Picture of the person. Defaults to defaultPersonImage until real image is downloaded.
@property (nonatomic, strong) NSString *bio;                        ///< Bio in string form including all HTML tags.
@property (nonatomic, strong) NSAttributedString *bioFormmated;     ///< Bio with HTML formatted into an NSAttributedString.
@property (nonatomic, strong) NSArray *projects;                    ///< Collection of AW_Project objects.
@property (nonatomic, strong) NSArray *links;                       ///< Collection of AW_Link objects.

@property (nonatomic) BOOL isHackerSchooler;                        ///< YES if the person is a Hacker Schooler.
@property (nonatomic) BOOL isFaculty;                               ///< YES if the person is Hacker School faculty.

@property (nonatomic, strong) NSNumber *batchID;                    ///< The batch ID of the batch this person belongs to.
@property (nonatomic, weak) AW_Batch *batch;                        ///< The AW_Batch object this person belongs to. Must be set after instantiation.

@property (nonatomic, weak) id<AW_PersonDelegate> delegate;         ///< Receives delegate callbacks for asynchonous operations.


/**
    Returns an initialized AW_Person object from saved data where available.
    All properties are set except for @b bioFormatter, @b projects, and @b image (unless unarchiving from
    saved data, in which case if these properties were previously set, then they will be set upon intialization.)
    An asynchonous operation to download the image data and set it to the @b image property is automatically started.
 
    @brief Returns an initialized person object from a JSON object.
    @param personInfo JSON object created from API response.
    @return Initialized with all properties set, except for @b bioFormatted, @b projects, and @b image.
 */
- (instancetype)initWithJSONObject:(NSDictionary *)personInfo; // Designated

/**
    Returns an initialized AW_Person object from Hacker School API response data. Uses NSJSONSerialization to convert data to JSON object,
    then calls -initWithJSONObject.
 
    @brief Returns an intialized person object from API response data.
    @param data Response data from Hacker School API.
    @return Initialized person object, or nil if the the data could not be converted to a JSON object.
 */
- (instancetype)initWithHackerSchoolAPIData:(NSData *)data;

/** @brief Uses main thread to handle HTML formatting of bio.
 This method uses WebKit and can only be run on the main thread. */
-(NSAttributedString *)formatBio;

/** @brief uses main thread to handle HTML formatting of project descriptions.
 This method uses WebKit and can only be run on the main thread. It may take a few seconds depending
 on the number and formatting of the person's project descriptions. */
-(void)formatProjects;

@end

