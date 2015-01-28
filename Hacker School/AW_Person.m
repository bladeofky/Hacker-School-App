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
 "bio"                  :   NSString
 "projects"             :   NSArray of NSDictionaries
 */

#import "AW_Person.h"
#import "AW_Project.h"
#import "AW_Link.h"

@implementation AW_Person

#pragma mark - Initializers
-(instancetype)initWithJSONObject:(NSDictionary *)personInfo
{
    self = [super init];
    
    if (self) {
        _idNumber = personInfo[@"id"];
        _firstName = personInfo[@"first_name"];
        _middleName = personInfo[@"middle_name"];
        _lastName = personInfo[@"last_name"];
        _email = personInfo[@"email"];
        _twitterUserName = personInfo[@"twitter"];
        _githubUserName = personInfo[@"github"];
        _batchID = personInfo[@"batch_id"];
        _phoneNumber = personInfo[@"phone_number"];
        _job = personInfo[@"job"];
        _skills = personInfo[@"skills"];
        _image = [UIImage imageNamed:@"defaultPersonImage"];
        _bio = personInfo[@"bio"];
        
        // Process project
        NSMutableArray *tempProjectsArray = [[NSMutableArray alloc]init];
        for (NSDictionary *projectInfo in personInfo[@"projects"]) {
            AW_Project *project = [[AW_Project alloc]initFromJsonObject:projectInfo];
            [tempProjectsArray addObject:project];
        }
        _projects = [tempProjectsArray copy];
        
        // Process links
        NSMutableArray *tempLinksArray = [[NSMutableArray alloc]init];
        for (NSDictionary *linkInfo in personInfo[@"links"]) {
            AW_Link *link = [[AW_Link alloc]init];
            link.title = linkInfo[@"title"];
            link.url = [NSURL URLWithString:linkInfo[@"url"]];
            [tempLinksArray addObject:link];
        }
        _links = [tempLinksArray copy];
        
        // Download the image asynchronously
        NSURL *imageURL = [NSURL URLWithString:personInfo[@"image"]];
        NSURLSessionTask *retrieveImageTask = [[NSURLSession sharedSession] dataTaskWithURL:imageURL
                                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                              NSLog(@"Did finish downloading image data for: %@ %@", _firstName, _lastName);
                                                                              self.image = [UIImage imageWithData:data];
                                                                              [self.delegate person:self didDownloadImage:self.image];
                                                                          }];
        [retrieveImageTask resume];
        
        
    } //end if self
    
    return self;
}

-(instancetype)initWithHackerSchoolAPIData:(NSData *)data
{
    NSError *error;
    NSDictionary *personInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return nil;
    }
    
    return [self initWithJSONObject:personInfo];
}

-(instancetype)init
{
    [NSException raise:@"Empty AW_Person not allowed" format:@"Use initWithHackerSchoolAPIData instead"];
    
    return nil;
}

@end
