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

/**
    Called when a batch successfully retrieves the people objects from the API, turns them into AW_Person objects, and
    adds the collection of AW_Person objects to the AW_Batch's @b people property.
 
    @brief Called when a batch successfully downloads its people from the API.
 */
- (void)batch:(AW_Batch *)batch didDownloadPeople:(NSArray *)people;

/**
    @brief Called when a batch fails to retrieve the people objects from the API.
 */
- (void)batch:(AW_Batch *)batch failedToDownloadPeopleWithError:(NSError *)error;

/** 
    Called when an AW_Person finishes asynchronously downloading its image. At this point, the image
    is set to the AW_Person's @b image property. Use this method to update the UI with the new image.
    @brief Use this method to update the UI with the updated image.
  */
- (void)batch:(AW_Batch *)batch didDownloadImage:(UIImage *)image forPerson:(AW_Person *)person;

@end
