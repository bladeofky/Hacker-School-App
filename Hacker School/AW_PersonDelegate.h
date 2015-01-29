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
- (void)person:(AW_Person *)person didDownloadImage:(UIImage *)image;

@end

