//
//  UIColor+batchColors.h
//  Hacker School
//
//  Created by Alan Wang on 1/31/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AW_Batch;

@interface UIColor (batchColors)

+ (instancetype)springColor;
+ (instancetype)summerColor;
+ (instancetype)fallColor;
+ (instancetype)winterColor;

+ (instancetype)colorForBatch:(AW_Batch *)batch;

@end
