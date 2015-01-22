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
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];    // This is the format returned from Hacker School API
        
        _idNumber = batchInfo[@"id"];
        _name = batchInfo[@"name"];
        _startDate = [dateFormatter dateFromString:batchInfo[@"start_date"]];
        _endDate = [dateFormatter dateFromString:batchInfo[@"end_date"]];
    }
    
    return self;
}

-(instancetype)init
{
    [NSException raise:@"Cannot create empty batch" format:@"Use initWithAPIData:"];
    
    return nil;
}


@end
