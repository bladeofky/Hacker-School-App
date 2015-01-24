//
//  AW_PersonCollectionViewCell.m
//  Hacker School
//
//  Created by Alan Wang on 1/23/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_BatchIndexedCollectionView.h"
#import "AW_PersonCollectionViewCell.h"
#import "AW_Person.h"

@interface AW_PersonCollectionViewCell ()

@end

@implementation AW_PersonCollectionViewCell

-(void)setPerson:(AW_Person *)person
{
    // Set person
    _person = person;
    
    // Update image
    _personImageView.image = person.image;
    [_personImageView setNeedsDisplay];
    
    // Update name
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", _person.firstName, _person.lastName];
    [_nameLabel setNeedsDisplay];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Configure profile image
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 130)];
        _personImageView = imageView;
        _personImageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_personImageView];
        
        // Configure name
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, self.bounds.size.width, 30)];
        nameLabel.text = [NSString stringWithFormat:@"%@ %@", _person.firstName, _person.lastName];
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        
        _nameLabel = nameLabel;
        [self.contentView addSubview:_nameLabel];
    }
    
    return self;
}

#pragma mark - AW_PersonDelegate
-(void)person:(AW_Person *)person didDownloadImage:(UIImage *)image
{
    self.personImageView.image = _person.image;
    [self.personImageView setNeedsDisplay];
    
}

@end
