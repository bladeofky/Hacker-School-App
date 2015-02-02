//
//  AW_BatchStore.h
//  Hacker School
//
//  Created by Alan Wang on 2/1/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AW_BatchStore : NSObject

@property (nonatomic, strong) NSArray *batches;

+ (instancetype)sharedStore;

- (BOOL)saveChanges;

@end
