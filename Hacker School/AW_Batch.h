//
//  AW_Batch.h
//  Hacker School
//
//  Created by Alan Wang on 1/22/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AW_Batch : NSObject

@property (nonatomic, strong) NSNumber *idNumber;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *season; // Possibly should make this enum
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSArray *people;


- (instancetype)initWithJSONObject:(NSDictionary *)batchInfo;   //designated
- (instancetype)initWithAPIData:(NSData *)APIData;

@end
