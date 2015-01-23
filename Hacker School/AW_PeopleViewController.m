//
//  AW_PeopleViewController.m
//  Hacker School
//
//  Created by Alan Wang on 1/21/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AW_BatchHeaderView.h"

#import "AW_PeopleViewController.h"
#import "AW_LoginViewController.h"

#import "NXOAuth2.h"

#import "AW_Batch.h"

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

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // --- Set up Nav Bar ---
    self.navigationItem.title = @"People";
    // TODO: Set up left button to pull out slide menu
    // TODO: Set up right button to refresh
   
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

- (void)processListOfBatches:(NSData *)responseData
{
    NSError *error;
    NSArray *batchInfos = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        return;
    }
    
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    
    for (NSDictionary *batchInfo in batchInfos) {
        AW_Batch *batch = [[AW_Batch alloc]initWithJSONObject:batchInfo];
        [temp addObject:batch];
    }
    
    self.batches = [temp copy];
    
    NSLog(@"Batches: %@", self.batches);
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return 1;
    return [self.batches count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.batches count];
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    AW_Batch *batch = self.batches[indexPath.row];
    cell.textLabel.text = batch.name;
    
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
    view.batchNameLabel.text = batch.name;
    view.batchYearLabel.text = batch.year;
    
    return view;
}

@end
