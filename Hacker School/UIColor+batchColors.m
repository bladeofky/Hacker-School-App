//
//  UIColor+batchColors.m
//  Hacker School
//
//  Created by Alan Wang on 1/31/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "UIColor+batchColors.h"
#import "AW_Batch.h"

@implementation UIColor (batchColors)

+(instancetype)springColor
{
    return [UIColor colorWithRed:0.92 green:0.82 blue:0.86 alpha:1.0];
}

+(instancetype)summerColor
{
    return [UIColor colorWithRed:0.85 green:0.92 blue:0.83 alpha:1.0];
}

+(instancetype)fallColor
{
    return [UIColor colorWithRed:0.99 green:0.90 blue:0.80 alpha:1.0];
}

+(instancetype)winterColor
{
    return [UIColor colorWithRed:0.81 green:0.89 blue:0.95 alpha:1.0];
}

+ (instancetype)colorForBatch:(AW_Batch *)batch
{
    UIColor *returnColor;
    
    if ([batch.name containsString:@"Spring"]) {
        returnColor = [UIColor springColor];
    }
    else if ([batch.name containsString:@"Summer"]) {
        returnColor = [UIColor summerColor];
    }
    else if ([batch.name containsString:@"Fall"]) {
        returnColor = [UIColor fallColor];
    }
    else if ([batch.name containsString:@"Winter"]) {
        returnColor = [UIColor winterColor];
    }
    else {
        returnColor = [UIColor blackColor];
    }
    
    return returnColor;
}

@end
