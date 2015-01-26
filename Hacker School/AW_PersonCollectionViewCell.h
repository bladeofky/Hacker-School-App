//
//  AW_PersonCollectionViewCell.h
//  Hacker School
//
//  Created by Alan Wang on 1/23/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_PersonDelegate.h"

extern const NSUInteger PERSON_CELL_WIDTH;
extern const NSUInteger PERSON_CELL_HEIGHT;

@class AW_Person, AW_BatchIndexedCollectionView;

@interface AW_PersonCollectionViewCell : UICollectionViewCell <AW_PersonDelegate>

@property (nonatomic, weak) UIImageView *personImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) AW_Person *person;

@end
