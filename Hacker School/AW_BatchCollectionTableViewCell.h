//
//  AW_BatchCollectionTableViewCell.h
//  Hacker School
//
//  Created by Alan Wang on 1/23/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AW_BatchIndexedCollectionView, AW_Batch;

@interface AW_BatchCollectionTableViewCell : UITableViewCell <UICollectionViewDataSource>

@property (nonatomic, strong) AW_BatchIndexedCollectionView *collectionView;
@property (nonatomic, weak) AW_Batch *batch;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier batch:(AW_Batch *)batch; //designated


@end
