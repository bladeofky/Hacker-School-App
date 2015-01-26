//
//  AW_BatchHeaderViewDelegate.h
//  Hacker School
//
//  Created by Alan Wang on 1/26/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//
@class AW_BatchHeaderView;

@protocol AW_BatchHeaderViewDelegate <NSObject>

@optional
- (void)didTapBatchHeader:(AW_BatchHeaderView *)batchHeaderView;

@end