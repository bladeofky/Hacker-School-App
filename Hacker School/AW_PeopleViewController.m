//
//  AW_PeopleViewController.m
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_PeopleViewController.h"
#import "AW_LoginViewController.h"

#import "NXOAuth2.h"

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

@property (nonatomic, strong) NSArray *batches;
@property (nonatomic, strong) NSMutableDictionary *loadedBatches;   // Stores people in the batch (key: section in tableview, value: NSArray of AW_Person objects)
@property (nonatomic, strong) NSMutableArray *isSectionOpenArray;   // Tracks which sections are opened (index: section, value: BOOL)
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

-(NSMutableArray *)isSectionOpenArray
{
    if (!_isSectionOpenArray) {
        _isSectionOpenArray = [[NSMutableArray alloc]init];
    }
    
    return _isSectionOpenArray;
}

-(NSMutableDictionary *)loadedBatches
{
    if (!_loadedBatches) {
        _loadedBatches = [[NSMutableDictionary alloc]init];
    }
    
    return _loadedBatches;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // --- Set up Nav Bar ---
    self.navigationItem.title = @"People";
    // TODO: Set up left button to pull out slide menu
    // TODO: Set up right button to refresh
    
    // --- Set up table view ---
    [self.tableView registerClass:[AW_BatchCollectionTableViewCell class] forCellReuseIdentifier:@"AW_BatchCollectionTableViewCell"];
   
    // --- Initial download ---
    [self downloadListOfBatches];
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
        AW_Batch *batch = [[AW_Batch alloc]initWithJSONObject:batchInfo];
        [tempBatches addObject:batch];
        [self.isSectionOpenArray addObject:@NO];
    }
    
    self.batches = [tempBatches copy];
    
    NSLog(@"Batches: %@", self.batches);
    
    [self.tableView reloadData];
}

// Processes the raw data returned from the Hacker School API to create an NSArray of AW_Person objects
// Adds this NSArray to the self.loadedBatches dictionary with a key corresponding to the batch's section in the table view
- (void)processPeopleInBatch:(NSData *)responseData forSection:(NSUInteger)section
{
    // Translate data into JSON Object
    NSError *error;
    NSArray *personInfos = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:0
                                                             error:&error];
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return;
    }
    
    // Get the tableview cell this batch belongs to
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    AW_BatchCollectionTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // Generate array of AW_Person objects
    NSMutableArray *tempPeopleArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *personInfo in personInfos) {
        AW_Person *person = [[AW_Person alloc]initWithJSONObject:personInfo];
        [tempPeopleArray addObject:person];
    }
    
    NSLog(@"Section %lu batch contains: %@", (unsigned long)section, tempPeopleArray);
    // Add array to dictionary
    NSNumber *sectionWrapper = [NSNumber numberWithInteger:section];
    self.loadedBatches[sectionWrapper] = [tempPeopleArray copy];
    
    [cell.collectionView reloadData];
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
    
    if ([self.isSectionOpenArray[section] isEqual:@YES]) {
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
    cell.collectionView.dataSource = self;
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
    AW_Batch *batch = self.batches[section];
    
    AW_BatchHeaderView *view = [[AW_BatchHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    view.batch = batch;
    view.delegate = self;
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Calculate height of collection view
    NSNumber *batchSectionWrapper = [NSNumber numberWithInteger:indexPath.section];
    NSArray *peopleInBatch = self.loadedBatches[batchSectionWrapper];
    NSUInteger numberOfPeople = [peopleInBatch count];
    NSUInteger numberOfRows = numberOfPeople - (numberOfPeople / 2);
    
    // Information from AW_BatchCollectionTableViewCell's flowlayout
    // TODO: Couple this information somehow
    NSUInteger topInset = 20;
    NSUInteger bottomInset = 20;
    NSUInteger spaceBetweenRows = 20;
    NSUInteger heightOfCell = 160;
    
    NSUInteger totalHeight = topInset + ((numberOfRows - 1) * spaceBetweenRows) + (numberOfRows * heightOfCell) + bottomInset;
    
    return totalHeight;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(AW_BatchIndexedCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSNumber *wrapper = [NSNumber numberWithInteger:collectionView.index];
    NSArray *peopleInBatch = self.loadedBatches[wrapper];   // Will return nil if section is not found among dictionary's keys
    
    return [peopleInBatch count];
}

-(AW_PersonCollectionViewCell *)collectionView:(AW_BatchIndexedCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AW_PersonCollectionViewCell *personCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AW_PersonCollectionViewCell.h" forIndexPath:indexPath];
    
    NSNumber *batchSectionWrapper = [NSNumber numberWithInteger:collectionView.index];
    NSArray *peopleInBatch = self.loadedBatches[batchSectionWrapper];
    AW_Person *person = peopleInBatch[indexPath.row];
    person.delegate = personCell;
    
    personCell.person = person;
    
    return personCell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - AW_BatchHeaderDelegate
-(void)didTapBatchHeader:(AW_BatchHeaderView *)batchHeaderView
{
    NSUInteger sectionOfTappedHeader;
    
    // Find the section that the batchHeaderView belongs to
    for (int section = 0; section < [self.tableView numberOfSections]; section++) {
        UIView *viewForSectionHeader = [self tableView:self.tableView viewForHeaderInSection:section];
        if ([viewForSectionHeader isEqual:batchHeaderView]) {
            sectionOfTappedHeader = section;
            break;
        }
    }
    
    if ([self.isSectionOpenArray[sectionOfTappedHeader] isEqual:@NO]) {
        // Section is not currently open. Open section:
        // Add a row to the selected section
        [self.tableView beginUpdates];
        self.isSectionOpenArray[sectionOfTappedHeader] = @YES;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sectionOfTappedHeader];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
        // Begin fetching the people in this batch from the API if it has not already been loaded
        NSNumber *sectionOfTappedHeaderWrapper = [NSNumber numberWithInteger:sectionOfTappedHeader];
        if (!self.loadedBatches[sectionOfTappedHeaderWrapper]) {
            AW_Batch *batch = self.batches[sectionOfTappedHeader];
            
            NSNumber *batchID = batch.idNumber;
            NSURL *resourceURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.hackerschool.com//api/v1/batches/%@/people", batchID]];
            
            [NXOAuth2Request performMethod:@"GET"
                                onResource:resourceURL
                           usingParameters:nil
                               withAccount:self.userAccount
                       sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
                           // Update progress bar if we have one
                           // Intentionally left empty
                       } responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                           // Return the data to our view controller
                           [self processPeopleInBatch:responseData forSection:indexPath.section];
                       }];
        }
    }
    else {
        // Section is currently open. Close section:
        [self.tableView beginUpdates];
        self.isSectionOpenArray[sectionOfTappedHeader] = @NO;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sectionOfTappedHeader];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
   
}

@end
