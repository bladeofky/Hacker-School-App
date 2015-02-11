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

// --- Constants ---
NSString * const PERSON_ID_NUMBER_KEY = @"idNumber";

NSString * const FIRST_NAME_KEY = @"firstName";
NSString * const MIDDLE_NAME_KEY = @"middleName";
NSString * const LAST_NAME_KEY = @"lastName";

NSString * const PHONE_NUMBER_KEY = @"phoneNumber";
NSString * const EMAIL_KEY = @"email";
NSString * const TWITTER_USER_NAME_KEY = @"twitterUserName";
NSString * const GITHUB_USER_NAME_KEY = @"githubUserName";

NSString * const JOB_KEY = @"job";
NSString * const SKILLS_KEY = @"skills";
NSString * const IMAGE_KEY = @"image";
NSString * const BIO_KEY = @"bio";
NSString * const BIO_FORMATTED_KEY = @"bioFormatted";
NSString * const PROJECTS_KEY = @"projects";
NSString * const LINKS_KEY = @"links";

NSString * const IS_HACKER_SCHOOLER_KEY = @"isHackerSchooler";
NSString * const IS_FACULTY_KEY = @"isFaculty";

NSString * const BATCH_ID_KEY = @"batchID";

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
        
        _phoneNumber = personInfo[@"phone_number"];
        _email = personInfo[@"email"];
        _twitterUserName = personInfo[@"twitter"];
        _githubUserName = personInfo[@"github"];
        
        _job = personInfo[@"job"];
        _skills = personInfo[@"skills"];
        _image = [UIImage imageNamed:@"defaultPersonImage"];
        _bio = personInfo[@"bio"];
        
        _isFaculty = [personInfo[@"is_faculty"]boolValue];
        _isHackerSchooler = [personInfo[@"is_hacker_schooler"]boolValue];
        
        _batchID = personInfo[@"batch_id"];
        
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
                                                                              
                                                                              // Evidently NSURLSessionTask does not run the completion handler on the main thread
                                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                                  [self.delegate person:self didDownloadImage:self.image];
                                                                              });
                                                                          }];
        [retrieveImageTask resume]; // Start the NSURLSessionTask
        
        
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

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.idNumber forKey:PERSON_ID_NUMBER_KEY];
    
    [aCoder encodeObject:self.firstName forKey:FIRST_NAME_KEY];
    [aCoder encodeObject:self.middleName forKey:MIDDLE_NAME_KEY];
    [aCoder encodeObject:self.lastName forKey:LAST_NAME_KEY];
    
    [aCoder encodeObject:self.phoneNumber forKey:PHONE_NUMBER_KEY];
    [aCoder encodeObject:self.email forKey:EMAIL_KEY];
    [aCoder encodeObject:self.twitterUserName forKey:TWITTER_USER_NAME_KEY];
    [aCoder encodeObject:self.githubUserName forKey:GITHUB_USER_NAME_KEY];
    
    [aCoder encodeObject:self.job forKey:JOB_KEY];
    [aCoder encodeObject:self.skills forKey:SKILLS_KEY];
    [aCoder encodeObject:self.image forKey:IMAGE_KEY];
    [aCoder encodeObject:self.bio forKey:BIO_KEY];
    [aCoder encodeObject:self.bioFormmated forKey:BIO_FORMATTED_KEY];
    [aCoder encodeObject:self.projects forKey:PROJECTS_KEY];
    [aCoder encodeObject:self.links forKey:LINKS_KEY];
    
    [aCoder encodeBool:self.isHackerSchooler forKey:IS_HACKER_SCHOOLER_KEY];
    [aCoder encodeBool:self.isFaculty forKey:IS_FACULTY_KEY];
    
    [aCoder encodeObject:self.batchID forKey:BATCH_ID_KEY];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.idNumber = [aDecoder decodeObjectForKey:PERSON_ID_NUMBER_KEY];
        
        self.firstName = [aDecoder decodeObjectForKey:FIRST_NAME_KEY];
        self.middleName = [aDecoder decodeObjectForKey:MIDDLE_NAME_KEY];
        self.lastName = [aDecoder decodeObjectForKey:LAST_NAME_KEY];
        
        self.phoneNumber = [aDecoder decodeObjectForKey:PHONE_NUMBER_KEY];
        self.email = [aDecoder decodeObjectForKey:EMAIL_KEY];
        self.twitterUserName = [aDecoder decodeObjectForKey:TWITTER_USER_NAME_KEY];
        self.githubUserName = [aDecoder decodeObjectForKey:GITHUB_USER_NAME_KEY];
        
        self.job = [aDecoder decodeObjectForKey:JOB_KEY];
        self.skills = [aDecoder decodeObjectForKey:SKILLS_KEY];
        self.image = [aDecoder decodeObjectForKey:IMAGE_KEY];
        self.bio = [aDecoder decodeObjectForKey:BIO_KEY];
        self.bioFormmated = [aDecoder decodeObjectForKey:BIO_FORMATTED_KEY];
        self.projects = [aDecoder decodeObjectForKey:PROJECTS_KEY];
        self.links = [aDecoder decodeObjectForKey:LINKS_KEY];
        
        self.isHackerSchooler = [aDecoder decodeBoolForKey:IS_HACKER_SCHOOLER_KEY];
        self.isFaculty = [aDecoder decodeBoolForKey:IS_FACULTY_KEY];
        
        self.batchID = [aDecoder decodeObjectForKey:BATCH_ID_KEY];
    }
    
    return self;
}

#pragma mark - 

// I use this method rather than perform the converstion in a getter because this will allow me to put up a temporary loading screen
// if bioFormatted is nil while converting.
-(NSAttributedString *)formatBio
{
    // Early exit if no bio
    if ([self.bio isKindOfClass:[NSNull class]] || [self.bio isEqualToString:@""]) {
        return nil;
    }
    
    // Convert raw projectDescription string (with HTML tags) to attributed string
    NSString *htmlBio = self.bio;
    htmlBio = [htmlBio stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    htmlBio = [NSString stringWithFormat:@"<span style=\"font-family: HelveticaNeue; font-size: 17; color: black;\">%@</span>", htmlBio];
    
    // Supposedly this can only be done on the main thread. Something about Webkit requiring run cycles
    NSAttributedString *attributedBio = [[NSAttributedString alloc]initWithData:[htmlBio dataUsingEncoding:NSUnicodeStringEncoding]
                                                                        options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                             documentAttributes:nil
                                                                          error:nil];
    
    NSLog(@"Bio formatted");
    
    self.bioFormmated = attributedBio;
    
    return self.bioFormmated;
}

-(void)formatProjects
{
    for (AW_Project *project in self.projects) {
        if (!project.projectDescriptionFormatted) {
            [project formatProjectDescription];
        }
    }
}

@end
