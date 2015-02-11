//
//  AW_BatchStore.h
//  Hacker School
//
//  Created by Alan Wang on 2/1/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AW_BatchStore : NSObject

@property (nonatomic, strong) NSArray *batches; ///< Collection of AW_Batch objects. No sorting is performed, but API provides them in reverse chronological order.


/** 
    @brief Singleton that manages storage of downloaded batches.
    @return AW_BatchStore singleton
 */
+ (instancetype)sharedStore;


/** 
    @brief Writes downloaded batches to app's Document directory.
    @return BOOL representing whether the operation was successful
 */
- (BOOL)saveChanges;

@end
