//
//  AW_BatchStore.m
//  Hacker School
//
//  Created by Alan Wang on 2/1/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_BatchStore.h"

@interface AW_BatchStore ()


@end

@implementation AW_BatchStore

+ (instancetype)sharedStore
{
    static AW_BatchStore *sharedStore;
    
    if (!sharedStore) {
        
        sharedStore = [[self alloc ]initPrivate];
    }
    
    return sharedStore;
}

#pragma mark - Initializers
-(instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        NSString *path = [self batchesArchivePath];
        _batches = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    
    return self;
}

-(instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use +[sharedStore] instead"];
    
    return nil;
}

#pragma mark - Archiving methods

-(NSString *)batchesArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"batches.archive"];
}

-(BOOL)saveChanges
{
    NSString *path = [self batchesArchivePath];
    
    BOOL isSuccessful = [NSKeyedArchiver archiveRootObject:self.batches toFile:path];
    
    if (isSuccessful) {
        NSLog(@"Saved batches.");
    }
    else {
        NSLog(@"Failed to save batches.");
    }
    
    return isSuccessful;
}

@end
