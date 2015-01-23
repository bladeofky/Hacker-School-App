//
//  AW_BatchHeaderView.h
//  Hacker School
//
//  Created by Alan Wang on 1/22/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AW_BatchHeaderView, AW_Batch;

@protocol AW_BatchHeaderViewDelegate <NSObject>

@optional
- (void)didTapBatchHeader:(AW_BatchHeaderView *)batchHeaderView;

@end

@interface AW_BatchHeaderView : UIView

@property (strong, nonatomic) UILabel *batchNameLabel;
@property (strong, nonatomic) UILabel *batchYearLabel;
@property (weak, nonatomic) AW_Batch *batch;

@property (weak, nonatomic) id<AW_BatchHeaderViewDelegate> delegate;

@end
