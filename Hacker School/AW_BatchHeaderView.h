//
//  AW_BatchHeaderView.h
//  Hacker School
//
//  Created by Alan Wang on 1/22/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_BatchHeaderViewDelegate.h"

@class AW_BatchHeaderView, AW_Batch;

@interface AW_BatchHeaderView : UIView

@property (nonatomic) BOOL isOpen;
@property (nonatomic, strong) UILabel *batchNameLabel;
@property (nonatomic, strong) UILabel *batchYearLabel;
@property (nonatomic, weak) AW_Batch *batch;

@property (nonatomic, weak) id<AW_BatchHeaderViewDelegate> delegate;

@end
