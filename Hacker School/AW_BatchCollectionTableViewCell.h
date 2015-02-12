//
//  AW_BatchCollectionTableViewCell.h
//  Hacker School
//
//  Created by Alan Wang on 1/23/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AW_BatchIndexedCollectionView, AW_Batch;


/**
    UITableViewCell representing a "drawer" full of people. The people are the people in the batch corresponding to the drawer.
    This cell will display an AW_BatchIndexedCollectionView, which will display images of all the people in the batch.
 
    This view serves as the data source for the collection view it contains. The delegate must be set separately.
 
    @brief UITableViewCell that represents a drawer full of the people in a batch.
 */
@interface AW_BatchCollectionTableViewCell : UITableViewCell <UICollectionViewDataSource>

@property (nonatomic, strong) AW_BatchIndexedCollectionView *collectionView;    ///< Collection view displayed by the cell.
@property (nonatomic, weak) AW_Batch *batch;                                    ///< Batch whose people are displayed in this cell.


/**
    Returns an initialized view. The contained collection view is also initialized and has its properties set in this method.
 
    @return An initialized table view cell containing a collection view of people.
 */
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier batch:(AW_Batch *)batch; //designated


@end
