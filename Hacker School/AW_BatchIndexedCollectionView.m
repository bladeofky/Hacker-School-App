//
//  AW_BatchIndexedCollectionView.m
//  Hacker School
//
//  Created by Alan Wang on 1/23/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_BatchIndexedCollectionView.h"
#import "AW_PersonCollectionViewCell.h"

#import "AW_Person.h"

@implementation AW_BatchIndexedCollectionView

#pragma mark - Miscellaneous
+(UICollectionViewFlowLayout *)flowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.itemSize = CGSizeMake(PERSON_CELL_WIDTH, PERSON_CELL_HEIGHT);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 20;
    
    return layout;
}

@end
