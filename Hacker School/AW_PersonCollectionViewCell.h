//
//  AW_PersonCollectionViewCell.h
//  Hacker School
//
//  Created by Alan Wang on 1/23/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_PersonDelegate.h"

extern const NSUInteger PERSON_CELL_WIDTH;      ///< Width of the AW_PersonColelctionViewCell
extern const NSUInteger PERSON_CELL_HEIGHT;     ///< Height of the AW_PersonCollectionViewCell

@class AW_Person, AW_BatchIndexedCollectionView;

/**
    A subclass of UICollectionViewCell that displays the portrait and name for a single AW_Person.
 */
@interface AW_PersonCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *personImageView;   ///< The UIImageView that displays the person's image.
@property (nonatomic, weak) UILabel *nameLabel;             ///< The UILabel that displays the person's name.
@property (nonatomic, weak) AW_Person *person;              ///< The person this cell displays.

@end
