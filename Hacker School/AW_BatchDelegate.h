//
//  AW_BatchDelegate.h
//  Hacker School
//
//  Created by Alan Wang on 1/29/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

@class AW_Batch, AW_Person, UIImage;

@protocol AW_BatchDelegate <NSObject>

@required

- (void)batch:(AW_Batch *)batch didDownloadPeople:(NSArray *)people;
- (void)batch:(AW_Batch *)batch didDownloadImage:(UIImage *)image forPerson:(AW_Person *)person;

@end
