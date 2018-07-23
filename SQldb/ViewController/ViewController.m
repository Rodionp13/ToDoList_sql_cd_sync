//
//  ViewController.m
//  SQldb
//
//  Created by User on 7/10/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import "ViewController.h"

static NSString * const myCellId = @"idCellTask";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *controlSwitch;
@property (strong, nonatomic) NSArray *tasksArr;
@property (strong, nonatomic) DMManager *dmManager;
@property (strong, nonatomic) Task *taskToEdit;

- (IBAction)refreshToService:(UISwitch *)sender;
- (IBAction)massDelete:(id)sender;
- (IBAction)addNewTask:(id)sender;
- (void)loadData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //DBs Configuration SQL & Core Data
    self.dmManager = [[DMManager alloc] initWithSwitchState:self.controlSwitch.on];
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    
    [self loadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tasksArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ViewControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellId forIndexPath:indexPath];
    
    Task *task = [self.tasksArr objectAtIndex:indexPath.row];
    cell.titleLbl.text = task.title;
    cell.dateLbl.text = task.date;
    [cell setUpPriorityBttnWith:self.tasksArr indexPath:indexPath];
    return cell;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    Task *taskToEdit = [self.tasksArr objectAtIndex:indexPath.row];
    self.taskToEdit = taskToEdit;
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        Task *taskToDelete = [self.tasksArr objectAtIndex:indexPath.row];
        
        //DMManager Work(SQL && CD)
        [self.dmManager deleteRowFromBothDBsWithTask:taskToDelete];
        //reload tableView
        [self loadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)loadData {
    if(self.tasksArr != nil) {
        self.tasksArr = nil;
    }
//    DMManager Work
    self.tasksArr = [self.dmManager loadDataFromBothDBs];
    [self.tableView reloadData];
}


- (IBAction)massDelete:(id)sender {
    
    if([self.tasksArr count] != 0) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete All Tasks" message:@"All tips will be removed from you store" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Delete All Tasks" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        //    DMManager Work
        [self.dmManager deleteAllRowsFromBothDBs];
        [self loadData];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cencel" style:UIAlertActionStyleCancel handler:nil]];
        
        UIPopoverPresentationController *popoverController = alert.popoverPresentationController;
        [popoverController setSourceView:self.view];
        [popoverController setSourceRect:self.view.frame];
        [self presentViewController:alert animated:YES completion:nil];
    }
    NSLog(@"delete!!!");
}

- (IBAction)addNewTask:(id)sender {
    [self setTaskToEdit:nil];
    NSString *identifite = @"idSegueEditInfo";
    [self performSegueWithIdentifier:identifite sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditInfoViewController *editInfoVC = [segue destinationViewController];
    [editInfoVC setDelegate:self];
    [editInfoVC setTaskToEdit:self.taskToEdit];
    [editInfoVC setIdOfLastItemInTasksArray:[(Task*)[self.tasksArr lastObject] taskID]];
    [editInfoVC setSwitchOn:self.controlSwitch.isOn];
}

- (IBAction)refreshToService:(UISwitch *)sender {
    if([self.dmManager isSwitchOn]) {
        [self.dmManager setSwitchOn:NO];
    } else {
        [self.dmManager setSwitchOn:YES];
    }
    
    [self loadData];
}

- (void)editingInfoWasFinishedWithIDofNewElement {
    [self loadData];
}



@end

