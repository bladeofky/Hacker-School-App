//
//  AW_Batch.h
//  Hacker School
//
//  Created by Alan Wang on 1/22/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AW_PersonDelegate.h"
#import "AW_BatchDelegate.h"

@interface AW_Batch : NSObject <AW_PersonDelegate, NSCoding>

@property (nonatomic, strong) NSNumber *idNumber;
@property (nonatomic, strong) NSString *apiName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *year;
@property (nonatomic, strong) NSString *season; // Possibly should make this enum
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSArray *people;

@property (nonatomic, weak) id<AW_BatchDelegate> delegate;


- (instancetype)initWithJSONObject:(NSDictionary *)batchInfo;   //designated
- (instancetype)initWithAPIData:(NSData *)APIData;

-(void)downloadPeople;

@end
