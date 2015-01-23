//
//  AW_BatchHeaderView.m
//  Hacker School
//
//  Created by Alan Wang on 1/22/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_BatchHeaderView.h"

@implementation AW_BatchHeaderView

#pragma mark - Initializers
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Instantiate subviews
        _batchNameLabel = [[UILabel alloc]init];
        _batchNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
        _batchNameLabel.textAlignment = NSTextAlignmentCenter;
        _batchNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        _batchYearLabel = [[UILabel alloc]init];
        _batchYearLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
        _batchYearLabel.textAlignment = NSTextAlignmentCenter;
        _batchYearLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        // Add subviews
        [self addSubview:_batchNameLabel];
        [self addSubview:_batchYearLabel];
        
        // Add autolayout constraints
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[batchNameLabel]-[batchYearLabel]-|"
                                                                               options:NSLayoutFormatAlignAllCenterX
                                                                               metrics:nil
                                                                                 views:@{@"batchNameLabel":_batchNameLabel,
                                                                                         @"batchYearLabel":_batchYearLabel}];
        
        NSArray *batchNameLabelHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[batchNameLabel]-20-|"
                                                                                               options:0
                                                                                               metrics:nil
                                                                                                 views:@{@"batchNameLabel":_batchNameLabel}];
        
        NSLayoutConstraint *proportionConstraint = [NSLayoutConstraint constraintWithItem:_batchNameLabel
                                                                                attribute:NSLayoutAttributeHeight
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:_batchYearLabel
                                                                                attribute:NSLayoutAttributeHeight
                                                                               multiplier:2.0
                                                                                 constant:0];
        
        [self addConstraint:proportionConstraint];
        [self addConstraints:batchNameLabelHorizontalConstraints];
        [self addConstraints:verticalConstraints];
    }
    
    return self;
}


@end
