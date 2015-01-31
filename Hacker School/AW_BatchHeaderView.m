//
//  AW_BatchHeaderView.m
//  Hacker School
//
//  Created by Alan Wang on 1/22/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_BatchHeaderView.h"
#import "AW_Batch.h"

#import "UIColor+batchColors.h"

@implementation AW_BatchHeaderView
#pragma mark - Accessors
- (void)setBatch:(AW_Batch *)batch
{
    _batch = batch;
    _batchNameLabel.text = batch.name;
    _batchYearLabel.text = batch.year;
    _colorBar.backgroundColor = [UIColor colorForBatch:self.batch];
}

#pragma mark - Initializers
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Set self
        self.backgroundColor = [UIColor whiteColor];
        
        // Instantiate subviews
        _batchNameLabel = [[UILabel alloc]init];
        _batchNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0];
        _batchNameLabel.textAlignment = NSTextAlignmentCenter;
        _batchNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _batchYearLabel = [[UILabel alloc]init];
        _batchYearLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0];
        _batchYearLabel.textAlignment = NSTextAlignmentCenter;
        _batchYearLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _colorBar = [[UIView alloc]init];
        _colorBar.translatesAutoresizingMaskIntoConstraints = NO;
        
        // Add subviews
        [self addSubview:_batchNameLabel];
        [self addSubview:_batchYearLabel];
        [self addSubview:_colorBar];
        
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
        NSArray *colorBarVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[colorBar]|"
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:@{@"colorBar":_colorBar}];
        NSArray *colorBarHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[colorBar(==12)]"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:@{@"colorBar":_colorBar}];
        
        [self addConstraint:proportionConstraint];
        [self addConstraints:batchNameLabelHorizontalConstraints];
        [self addConstraints:verticalConstraints];
        [self addConstraints:colorBarVerticalConstraints];
        [self addConstraints:colorBarHorizontalConstraints];
        
        // Add gesture recognizers
        UIGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTapGesture];
    }
    
    return self;
}

#pragma mark - Comparisons
-(BOOL)isEqual:(id)object
{
    BOOL output = NO;
    
    if ([object isKindOfClass:[self class]]) {
        AW_Batch *batch = [(AW_BatchHeaderView *)object batch];
        if ([self.batch isEqual:batch]) {
            output = YES;
        }
    }
    
    return output;
}

#pragma mark - Event Handling
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    // Forward event to delegate
    [self.delegate didTapBatchHeader:self];
    NSLog(@"AW_BatchHeaderView did detect tap");
    // TODO: Animate tap feedback
}


@end
