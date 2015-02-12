//
//  AW_BatchIndexedCollectionView.h
//  Hacker School
//
//  Created by Alan Wang on 1/23/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AW_Batch;

/**
    The collection view that lives inside the AW_BatchCollectionTableViewCell "drawer". A subclass of UICollectionView that adds an
    index property in order to track with table view section this collection view corresponds to (so that it can display the correct
    batch).
 */
@interface AW_BatchIndexedCollectionView : UICollectionView

@property (nonatomic) NSUInteger index;         ///< The section of the table view this collection corresponds to.
@property (nonatomic, weak) AW_Batch *batch;    ///< The batch this collection view displays.

+(UICollectionViewFlowLayout *)flowLayout;      ///< The UICollectionViewFlowLayout used by this collection view. Used to calculate row height in the table view delegate.

@end
