//
//  AW_PeopleViewController.m
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_MainViewController.h"
#import "AW_PeopleViewController.h"
#import "AW_PersonDetailViewController.h"
#import "AW_LoginViewController.h"

#import "NXOAuth2.h"

#import "AW_BatchStore.h"
#import "AW_Batch.h"
#import "AW_Person.h"

#import "AW_BatchCollectionTableViewCell.h"
#import "AW_BatchIndexedCollectionView.h"
#import "AW_PersonCollectionViewCell.h"

/*
 The People tableView performs as follows:
 
 - All batches are listed initially. This will look like a typical table view.
 - Tapping a batch will cause it to scroll to the top of the view and "expand" downwards. A collection view will drop down below the selected batch.
    The other rows will move down as appropriate.
 - When scrolling through the collection view of people, the current open batch will remain at the top.
 - Tapping the batch again will close it.
 
 This is implemented as follows:
 - A plain UITableView already has the above described functionality built in to its section headers.
 - Use views that look like table view cells and set them as the section headers. Initially, all sections will have 0 rows.
 - When a section is tapped, add a row to that section. This row will be a collection view containing the faces of the people.
 - If the section header is tapped again, remove the collection view row.
 
 */

@interface AW_PeopleViewController ()

@property (nonatomic, strong) NSArray *batchHeaderViews;
@property (nonatomic, strong) NXOAuth2Account *userAccount;

@end



@implementation AW_PeopleViewController

#pragma mark - Accessors
-(NXOAuth2Account *)userAccount
{
    if (!_userAccount) {
        NSArray *accounts = [[NXOAuth2AccountStore sharedStore] accounts];
        
        if ([accounts count] > 0) {
            _userAccount = accounts[0];
        }
        else {
            _userAccount = nil;
        }
    }
    
    return _userAccount;
}

-(NSArray *)batches
{
    return [AW_BatchStore sharedStore].batches;
}

-(void)setBatches:(NSArray *)batches
{
    [AW_BatchStore sharedStore].batches = batches;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // --- Set up Nav Bar ---
    self.navigationItem.title = @"People";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Menu"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self.mainVC
                                                                           action:@selector(showUserMenu)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Reload" style:UIBarButtonItemStylePlain target:self action:@selector(downloadListOfBatches)];
    
    // --- Set up table view ---
    [self.tableView registerClass:[AW_BatchCollectionTableViewCell class] forCellReuseIdentifier:@"AW_BatchCollectionTableViewCell"];
   
    // --- If no archived data, download batches ---
    if (!self.batches) {
        [self downloadListOfBatches];
    }
    else {
        // Set delegates
        for (AW_Batch *batch in self.batches) {
            batch.delegate = self;
        }
        
        [self generateHeaderViews];
    }
}

#pragma mark - Hacker School API
- (void)downloadListOfBatches
{
    [NXOAuth2Request performMethod:@"GET"
                        onResource:[NSURL URLWithString:@"https://www.hackerschool.com//api/v1/batches"]
                   usingParameters:nil
                       withAccount:self.userAccount
               sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
                   // No code right now
               }
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                       
                       if (error) {
                           NSLog(@"Error: %@", [error localizedDescription]);
                       }
                       else {
                           [self processListOfBatches:responseData];
                       }
                       
                   }];
}

// Processes the raw data returned from the Hacker School API to create AW_Batch objects
- (void)processListOfBatches:(NSData *)responseData
{
    NSError *error;
    NSArray *batchInfos = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return;
    }
    
    NSMutableArray *tempBatches = [[NSMutableArray alloc]init];
    
    
    for (NSDictionary *batchInfo in batchInfos) {
        // Create batch
        AW_Batch *batch = [[AW_Batch alloc]initWithJSONObject:batchInfo];
        batch.delegate = self;
        [tempBatches addObject:batch];
    }

    self.batches = [tempBatches copy];
    
    NSLog(@"Batches: %@", self.batches);
    
    [self generateHeaderViews];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.batches count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows;
    AW_BatchHeaderView *batchHeaderView = self.batchHeaderViews[section];
    
    if (batchHeaderView.isOpen) {
        numRows = 1;
    }
    else {
        numRows = 0;
    }
    
    return numRows;
}

-(AW_BatchCollectionTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AW_Batch *batch = self.batches[indexPath.section];
    
    AW_BatchCollectionTableViewCell *cell = [[AW_BatchCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                                                  reuseIdentifier:@"AW_BatchCollectionTableViewCell"
                                                                                            batch:batch];
    cell.collectionView.delegate = self;
    cell.collectionView.index = indexPath.section;
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.batchHeaderViews[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Calculate height of collection view
    AW_Batch *batch = self.batches[indexPath.section];
    NSArray *peopleInBatch = batch.people;
    NSUInteger numberOfPeople = [peopleInBatch count];
    
    if (numberOfPeople == 0) {
        return 0;
    }
    
    // Information from AW_BatchCollectionTableViewCell's flowlayout
    UIEdgeInsets edgeInsets = [AW_BatchIndexedCollectionView flowLayout].sectionInset;
    NSUInteger widthOfTableView = self.tableView.bounds.size.width;
    
    NSUInteger numberOfPeoplePerRow = (widthOfTableView - ((NSUInteger)edgeInsets.left + (NSUInteger)edgeInsets.right)) / PERSON_CELL_WIDTH;
    NSUInteger numberOfRows;
    
    if ((numberOfPeople % numberOfPeoplePerRow)) {
        // If is a remainder, add another row
        numberOfRows = numberOfPeople/numberOfPeoplePerRow + 1;
    }
    else {
        numberOfRows = numberOfPeople/numberOfPeoplePerRow;
    }
    
    NSUInteger spaceBetweenRows = [AW_BatchIndexedCollectionView flowLayout].minimumLineSpacing;
    
    NSUInteger totalHeight = (NSUInteger)edgeInsets.top + ((numberOfRows - 1) * spaceBetweenRows) + (numberOfRows * PERSON_CELL_HEIGHT) + (NSUInteger)edgeInsets.bottom;
    
    return totalHeight;
}


#pragma mark - UICollectionViewDelegate
-(void)collectionView:(AW_BatchIndexedCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AW_Batch *batch = self.batches[collectionView.index];
    NSArray *peopleInBatch = batch.people;
    AW_Person *person = peopleInBatch[indexPath.row];
    
    NSLog(@"Did tap %@ %@", person.firstName, person.lastName);
    
    // Perform formatting of HTML (this can only be done on the main thread so we do it here and show a loading screen
    UIView *loadingOverlayView = [self loadingOverlayView];
    loadingOverlayView.alpha = 0;
    
    // Show loading screen
    [self.view addSubview:loadingOverlayView];
    [UIView animateWithDuration:.5 animations:^{
        loadingOverlayView.alpha = 1.0;
    }];
    
    // Perform formatting
    if (!person.bioFormmated) {
        [person formatBio];
    }
    [person formatProjects];
    
    // Remove loading screen
    [UIView animateWithDuration:.5 animations:^{
        loadingOverlayView.alpha = 0.0;
    }];
    [loadingOverlayView removeFromSuperview];
    
    
    
    // Push detail view controller
    AW_PersonDetailViewController *detailVC = [[AW_PersonDetailViewController alloc]init];
    detailVC.person = person;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - AW_BatchDelegate
-(void)batch:(AW_Batch *)batch didDownloadPeople:(NSArray *)people
{
    NSUInteger section = [self.batches indexOfObject:batch];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    // Existing row before loading people has height of zero. Reloading tableView will make the collectionView appear suddenly.
    // Remove and re-add the row to create the drawer effect.
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

-(void)batch:(AW_Batch *)batch didDownloadImage:(UIImage *)image forPerson:(AW_Person *)person
{
//    NSUInteger rowForCollectionView = [batch.people indexOfObject:person];
//    NSUInteger sectionForTableView = [self.batches indexOfObject:batch];
//    NSIndexPath *indexPathForTableViewCell = [NSIndexPath indexPathForRow:0 inSection:sectionForTableView];
//    AW_BatchCollectionTableViewCell *tableViewCell = [self.tableView cellForRowAtIndexPath:indexPathForTableViewCell];
//    
//    NSIndexPath *indexPathForPersonCell = [NSIndexPath indexPathForRow:rowForCollectionView inSection:0];
//    [tableViewCell.collectionView reloadItemsAtIndexPaths:@[indexPathForPersonCell]];
    
}

#pragma mark - AW_BatchHeaderDelegate
-(void)didTapBatchHeader:(AW_BatchHeaderView *)batchHeaderView
{
    // Find the section that the batchHeaderView belongs to
    NSUInteger sectionOfTappedHeader = [self.batchHeaderViews indexOfObject:batchHeaderView];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sectionOfTappedHeader];
    
    if (!batchHeaderView.isOpen) {
        // Section is not currently open. Open section:
        // Add a row to the selected section
//        [self.tableView setContentOffset:batchHeaderView.frame.origin animated:YES];
        
        [self.tableView beginUpdates];
        batchHeaderView.isOpen = YES;
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
        
        // Begin fetching the people in this batch from the API if it has not already been loaded
        AW_Batch *batch = self.batches[sectionOfTappedHeader];
        if (!batch.people) {
            [batch downloadPeople];
        }
    }
    else {
        // Section is currently open. Close section:
//        NSIndexPath *indexPathAtCurrentOffset = [self.tableView indexPathForRowAtPoint:currentOffset];
        
        [self.tableView beginUpdates];
        batchHeaderView.isOpen = NO;
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
//        // If the cell at the top of the view is the cell we are closing, scroll to the top after removing row
//        if ([indexPathAtCurrentOffset isEqual:indexPath]) {
//            [self.tableView setContentOffset:batchHeaderView.frame.origin animated:YES];
//        }
    }
}

#pragma mark - Misc.

-(void)generateHeaderViews
{
    NSMutableArray *tempBatchHeaders = [[NSMutableArray alloc]init];
    
    for (AW_Batch *batch in self.batches) {
        // Create batch header view for table
        AW_BatchHeaderView *batchHeaderView = [[AW_BatchHeaderView alloc]init];
        batchHeaderView.batch = batch;
        batchHeaderView.delegate = self;
        [tempBatchHeaders addObject:batchHeaderView];
    }
    
    self.batchHeaderViews = [tempBatchHeaders copy];
}

-(UIView *)loadingOverlayView
{
    UIView *loadingOverlayView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    UIView *loadingOverlayBackground = [[UIView alloc]init];
    loadingOverlayBackground.translatesAutoresizingMaskIntoConstraints = NO;
    loadingOverlayBackground.backgroundColor = [UIColor whiteColor];
    loadingOverlayBackground.alpha = 0.8;
    [loadingOverlayView addSubview:loadingOverlayBackground];
    
    UILabel *loadingLabel = [[UILabel alloc]init];
    loadingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    loadingLabel.text = @"Working ... Please Wait";
    loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
    loadingLabel.textColor = [UIColor blackColor];
    [loadingOverlayView addSubview:loadingLabel];
    
    NSLayoutConstraint *loadingLabelCenterX = [NSLayoutConstraint constraintWithItem:loadingLabel
                                                                           attribute:NSLayoutAttributeCenterX
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:loadingLabel.superview
                                                                           attribute:NSLayoutAttributeCenterX
                                                                          multiplier:1
                                                                            constant:0];
    NSLayoutConstraint *loadingLabelCenterY = [NSLayoutConstraint constraintWithItem:loadingLabel
                                                                           attribute:NSLayoutAttributeCenterY
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:loadingLabel.superview
                                                                           attribute:NSLayoutAttributeCenterY
                                                                          multiplier:1
                                                                            constant:0];
    NSArray *loadingBackgroundHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[background]|"
                                                                                              options:0
                                                                                              metrics:nil
                                                                                                views:@{@"background":loadingOverlayBackground}];
    NSArray *loadingBackgroundVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[background]|"
                                                                                            options:0
                                                                                            metrics:nil
                                                                                              views:@{@"background":loadingOverlayBackground}];
    
    
    [loadingOverlayView addConstraint:loadingLabelCenterX];
    [loadingOverlayView addConstraint:loadingLabelCenterY];
    [loadingOverlayView addConstraints:loadingBackgroundHorizontalConstraints];
    [loadingOverlayView addConstraints:loadingBackgroundVerticalConstraints];
    
    return loadingOverlayView;
}

@end
