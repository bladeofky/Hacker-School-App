//
//  AW_PersonDelegate.h
//  Hacker School
//
//  Created by Alan Wang on 1/23/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

@class AW_Person, UIImage;

@protocol AW_PersonDelegate <NSObject>

@required

/** 
    @brief Called when the asynchronous download of the person's image is complete. The image is set to the @b image property for the AW_Person. 
 */
- (void)person:(AW_Person *)person didDownloadImage:(UIImage *)image;

@end

