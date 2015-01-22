//
//  AW_Person.m
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

/*
 ----------------------------
 Hacker School API
 ----------------------------
 Using [NSJSONSerialization JSONObjectWithData:data options:0 error:&error]; where data is the
 response from the Hacker School API results in the following keys and value types:
 
 "id"                   :   NSNumber
 "first_name"           :   NSString
 "middle_name"          :   NSString
 "last_name"            :   NSString
 "email"                :   NSString
 "twitter"              :   NSString
 "github"               :   NSString
 "batch_id"             :   NSNumber
 "phone_number"         :   NSString
 "has_photo"            :   NSNumber
 "is_faculty"           :   NSNumber
 "is_hacker_schooler"   :   NSNumber
 "job"                  :   NSString
 "skills"               :   NSArray of NSStrings
 "image"                :   NSString (stringof URL)
 "batch"                :   NSDictionary
 */

#import "AW_Person.h"

@implementation AW_Person

#pragma mark - Initializers
-(instancetype)initWithHackerSchoolAPIData:(NSData *)data
{
    self = [super init];
    
    if (self) {
        NSError *error;
        NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
            return nil;
        }

        _idNumber = userInfo[@"id"];
        _firstName = userInfo[@"first_name"];
        _middleName = userInfo[@"middle_name"];
        _lastName = userInfo[@"last_name"];
        _email = userInfo[@"email"];
        _twitterUserName = userInfo[@"twitter"];
        _githubUserName = userInfo[@"github"];
        _batchID = userInfo[@"batch_id"];
        _phoneNumber = userInfo[@"phone_number"];
        _job = userInfo[@"job"];
        _skills = userInfo[@"skills"];
        _image = [UIImage imageNamed:@"defaultPersonImage"];
        
        // Download the image asynchronously
        NSURL *imageURL = [NSURL URLWithString:userInfo[@"image"]];
        NSURLSessionTask *retrieveImageTask = [[NSURLSession sharedSession] dataTaskWithURL:imageURL
                                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                              self.image = [UIImage imageWithData:data];
                                                                              [self.delegate person:self didDownloadImage:self.image];
                                                                          }];
        [retrieveImageTask resume];
        
        
    } //end if self
    
    return self;
}

-(instancetype)init
{
    [NSException raise:@"Empty AW_Person not allowed" format:@"Use initWithHackerSchoolAPIData instead"];
    
    return nil;
}

@end
