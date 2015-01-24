//
//  AW_BatchCollectionTableViewCell.m
//  Hacker School
//
//  Created by Alan Wang on 1/23/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_BatchCollectionTableViewCell.h"
#import "AW_BatchIndexedCollectionView.h"
#import "AW_PersonCollectionViewCell.h"

@implementation AW_BatchCollectionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier batch:(AW_Batch *)batch
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _batch = batch;
        
        // Set up collection view layout
        UICollectionViewFlowLayout *layout = [self flowLayout];
        
        // Set up collection view
        _collectionView = [[AW_BatchIndexedCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.batch = batch;
        [_collectionView registerClass:[AW_PersonCollectionViewCell class] forCellWithReuseIdentifier:@"AW_PersonCollectionViewCell.h"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [self.contentView addSubview:self.collectionView];
    }
    
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier batch:nil];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.contentView.bounds;
}

-(UICollectionViewFlowLayout *)flowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(20, 30, 20, 30);
    layout.itemSize = CGSizeMake(130, 160);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 20;
    
    return layout;
}

@end
