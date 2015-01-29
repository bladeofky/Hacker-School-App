//
//  AW_Batch.m
//  Hacker School
//
//  Created by Alan Wang on 1/22/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

/*
 ----------------------------
 Hacker School API
 ----------------------------
 Using [NSJSONSerialization JSONObjectWithData:data options:0 error:&error]; where data is the
 response from the Hacker School API results in the following keys and value types:
 
 "id"           :   NSNumber (long)
 "name"         :   NSString
 "start_date"   :   NSString
 "end_date"     :   NSString
 */

#import "AW_Batch.h"
#import "AW_Person.h"
#import "AW_UserAccount.h"
#import "NXOAuth2.h"

@implementation AW_Batch

#pragma mark - Initializers
-(instancetype)initWithAPIData:(NSData *)APIData
{
    NSError *error;
    NSDictionary *batchInfo = [NSJSONSerialization JSONObjectWithData:APIData
                                                              options:0
                                                                error:&error];
    
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return nil;
    }
    
    return [self initWithJSONObject:batchInfo];
}

- (instancetype)initWithJSONObject:(NSDictionary *)batchInfo
{
    self = [super init];
    
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";    // This is the format returned from Hacker School API
        
        _idNumber = batchInfo[@"id"];
        _startDate = [dateFormatter dateFromString:batchInfo[@"start_date"]];
        _endDate = [dateFormatter dateFromString:batchInfo[@"end_date"]];
        
        dateFormatter.dateFormat = @"yyyy";
        _year = [dateFormatter stringFromDate:_startDate];
        
        // Parse name
        _apiName = batchInfo[@"name"];
        _name = [_apiName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@" %@", _year] withString:@""];
        _name = [_name stringByReplacingOccurrencesOfString:@"," withString:@""];
        _name = [_name stringByReplacingOccurrencesOfString:@"[" withString:@" "];
        _name = [_name stringByReplacingOccurrencesOfString:@"]" withString:@""];
        
        NSArray *tokens = [_name componentsSeparatedByString:@" "];
        _season = tokens[0];
    }
    
    return self;
}

-(instancetype)init
{
    [NSException raise:@"Cannot create empty batch" format:@"Use initWithAPIData:"];
    
    return nil;
}

#pragma mark - Hacker School API Access
-(void)downloadPeople
{
    NSURL *resourceURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.hackerschool.com//api/v1/batches/%@/people", self.idNumber]];
    
    [NXOAuth2Request performMethod:@"GET"
                        onResource:resourceURL
                   usingParameters:nil
                       withAccount:[AW_UserAccount currentUser]
               sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
                   // Update progress bar if we have one
                   // Intentionally left empty
               } responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                   
                   if (error) {
                       NSLog(@"Error: %@", [error localizedDescription]);
                       return;
                   }
                   
                   // Translate data into JSON Object
                   NSArray *personInfos = [NSJSONSerialization JSONObjectWithData:responseData
                                                                          options:0
                                                                            error:&error];
                   // Generate array of AW_Person objects
                   NSMutableArray *tempPeopleArray = [[NSMutableArray alloc]init];
                   
                   for (NSDictionary *personInfo in personInfos) {
                       AW_Person *person = [[AW_Person alloc]initWithJSONObject:personInfo];
                       person.delegate = self;
                       person.batch = self;
                       [tempPeopleArray addObject:person];
                   }

                   self.people = [tempPeopleArray copy];
                   
                   [self.delegate batch:self didDownloadPeople:self.people];
               }];
}

#pragma mark - AW_PersonDelegate
-(void)person:(AW_Person *)person didDownloadImage:(id)image
{
    [self.delegate batch:self didDownloadImage:image forPerson:person];
}

#pragma mark - Comparisons
// Equality based on if batch idNumber are equal
-(BOOL)isEqual:(id)object
{
    BOOL output = NO;
    
    if ([object isKindOfClass:[self class]]) {
        NSNumber *batchID = [(AW_Batch *)object idNumber];
        if ([batchID isEqualToNumber:self.idNumber]) {
            output = YES;
        }
    }
    
    return output;
}

@end
