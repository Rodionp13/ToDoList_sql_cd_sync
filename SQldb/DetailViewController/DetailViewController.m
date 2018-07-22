//
//  DetailViewController.m
//  SQldb
//
//  Created by User on 7/10/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import "DetailViewController.h"
#import "MyFirstDBManager.h"

@interface DetailViewController ()
@property(strong, nonatomic) NSArray *detailsArr;
@property(strong, nonatomic) MyFirstDBManager *dbManager;
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;

- (void)loadData;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDbManager:[[MyFirstDBManager alloc] initWithDataBaseFileName:@"myTasks.db"]];
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    [self loadData];
    
    CALayer *label = self.mainLabel.layer;
    [label setBorderWidth:2];
    [label setCornerRadius:20];
    [label setBorderColor:UIColor.blueColor.CGColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.detailsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCellId" forIndexPath:indexPath];
    
    Task *task = [self.detailsArr objectAtIndex:indexPath.row];
    NSString *dateOrTitle;
    if(self.selectedTitleBttn) {
        dateOrTitle = task.date;
    } else {
        dateOrTitle = task.title;
    }
    
//    if([[self.dbManager.arrColumnNames objectA`tIndex:0] isEqualToString:@"title"]) {
//        index1 = [[self.dbManager arrColumnNames] indexOfObject:@"title"];
//    } else if([[self.dbManager.arrColumnNames objectAtIndex:0] isEqualToString:@"date"]) {
//        index1 = [[self.dbManager arrColumnNames] indexOfObject:@"date"];
//    }
//    index2 = [[self.dbManager arrColumnNames] indexOfObject:@"description"];
    
    cell.textLabel.text = dateOrTitle;
    cell.detailTextLabel.text = task.taskDescription;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (void)loadData {
    
    NSArray *resultOfQuery;
    UILabel *mainLabel = self.mainLabel;
    
    if(self.isSelectedTitleBttn & !self.isSelectedDateBttn) {
//        query = [NSString stringWithFormat:@"select date,description from myTasks where title='%@'", self.titleText];
        resultOfQuery = [self.dbManager selectRowsWithColumnNames:@[kDate, kDescription] byColumnName:NameOfColumnInRowTitle withSelectedTask:self.detailTask];
        mainLabel.text = [NSString stringWithFormat:@"Task title (%@) related with dates", self.detailTask.title];
    } else {
//        query = [NSString stringWithFormat:@"select title, description from myTasks where date='%@'", self.detailTask.date];
//        [[self mainLabel] setText:[NSString stringWithFormat:@"All tasks within date: %@", self.dateText]];
        resultOfQuery = [self.dbManager selectRowsWithColumnNames:@[kTitle, kDescription] byColumnName:NameOfColumnInRowDate withSelectedTask:self.detailTask];
        mainLabel.text = [NSString stringWithFormat:@"All tasks within date: %@", self.detailTask.date];
        
    }
    
    if(self.detailsArr != nil) {
        self.detailsArr = nil;
    }
    
    self.detailsArr = resultOfQuery;
    [self.tableView reloadData];
    
#pragma mark - temporary ckeck
    if(self.detailsArr) {
        NSLog(@"SELECT query Successful detailArr count =  %lu", self.detailsArr.count);
        NSLog(@"%@", self.detailsArr);
        NSLog(@"%@", self.dbManager.arrColumnNames);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"goBack is about to trigger");
    [self.delegate goBackToEditVCAndResetButtonsBOOLProperties];
}


@end
