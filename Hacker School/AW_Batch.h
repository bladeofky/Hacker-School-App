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

/**
    Class that represents a Hacker School batch.
 */
@interface AW_Batch : NSObject <AW_PersonDelegate, NSCoding>

@property (nonatomic, strong) NSNumber *idNumber;   ///< ID Number of the batch as defined internally by Hacker School.
@property (nonatomic, strong) NSString *apiName;    ///< The full name of the batch as defined by Hacker School (i.e. Winter 2, 2015)
@property (nonatomic, strong) NSString *name;       ///< The name of the batch without the year (i.e. Winter 2)
@property (nonatomic, strong) NSString *year;       ///< The year of the batch (i.e. 2015)
@property (nonatomic, strong) NSString *season;     ///< The season of the batch (i.e. Winter)
@property (nonatomic, strong) NSDate *startDate;    ///< The start date of the batch.
@property (nonatomic, strong) NSDate *endDate;      ///< The end date of the batch.
@property (nonatomic, strong) NSArray *people;      ///< The people in the batch. Returns nil until -[AW_Batch downloadPeople] is called.

@property (nonatomic, weak) id<AW_BatchDelegate> delegate;  ///< Delegate to receive callbacks from asynchrnonous operations.

/** 
    @brief Returns an initialized batch object from a JSON object.
    @param batchInfo Response from Hacker School API as a JSON object.
    @return An initialized batch, with all properties set. Missing properties will either be an empty string, or NSNull object.
 */
- (instancetype)initWithJSONObject:(NSDictionary *)batchInfo;   //designated


/**
    This method uses NSJSONSerialization to create a JSON object from the data, then calls initWithJSONObject.
 
    @brief Initializes AW_Batch from NSData recieved from API.
    @param APIData Data received from the Hacker School API.
    @return An initialized batch, with all properties set. Missing properties will either be an empty string, or NSNull object. If the data could not be converted to a JSON object, returns nil.
 */
- (instancetype)initWithAPIData:(NSData *)APIData;

/** 
    Asynchonously calls the Hacker School API to download all people in the batch.
    Creates an AW_Person object for each person downloaded and adds it to a collection.
    When compelte, sets the collection to the @b people property.
    Calls @b batch:didDownloadPeople: on delegate if successful.
    Calls @b batch:failedToDownloadPeopleWithError: on delegate if failed.
 
    @brief Asynchronously request and process people in batch.
 */
-(void)downloadPeople;

@end
