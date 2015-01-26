//
//  AW_BatchIndexedCollectionView.h
//  Hacker School
//
//  Created by Alan Wang on 1/23/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AW_Batch;

@interface AW_BatchIndexedCollectionView : UICollectionView

@property (nonatomic) NSUInteger index;
@property (nonatomic, weak) AW_Batch *batch;

+(UICollectionViewFlowLayout *)flowLayout;

@end
