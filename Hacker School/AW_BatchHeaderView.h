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

/**
    A view intended to go in the section header view of a UITableView. It corresponds to a single batch and displays the batch
    name, and year. A side bar is also displayed if the batch's people are currently loaded. The color of the side bar depends on the
    season of the batch.
 
    The intention is to create a "drawer opening" effect when this view is tapped. The drawer will be an AW_BatchCollectionTableViewCell and 
    will show the people in the batch.
 
    This view calls the @b didTapBatchHeader: method of its delegate when tapped.
 
    @brief Section header view for a batch.
 */
@interface AW_BatchHeaderView : UIView

@property (nonatomic) BOOL isOpen;                          ///< Tracks whether the "drawer" is open.
@property (nonatomic, strong) UILabel *batchNameLabel;      ///< Label displaying the name of the batch.
@property (nonatomic, strong) UILabel *batchYearLabel;      ///< Label displaying the year of the batch.
@property (nonatomic, strong) UIView *colorBar;             ///< This bar will appear if the batch has loaded its people.
@property (nonatomic, weak) AW_Batch *batch;                ///< The batch this view corresponds to.

@property (nonatomic, weak) id<AW_BatchHeaderViewDelegate> delegate;    ///< Responds to taps to the view.

@end
