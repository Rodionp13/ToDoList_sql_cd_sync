//
//  MyFirstDBManager.h
//  SQLiteFIrstSample
//
//  Created by User on 7/9/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

static NSString *const kTaskId = @"taskID";
static NSString *const kTitle = @"title";
static NSString *const kDate = @"date";
static NSString *const kPriority = @"priority";
static NSString *const kDescription = @"description";
static NSString *const kSqlDbFileName = @"myTasks.db";

typedef NS_ENUM(NSInteger, NameOfColumnInRow) {
    NameOfColumnInRowID = 0,
    NameOfColumnInRowTitle,
    NameOfColumnInRowDate,
    NameOfColumnInRowPriority,
    NameOfColumnInRowDescription
};


@interface MyFirstDBManager : NSObject
@property(nonatomic, strong) NSMutableArray *arrColumnNames;
@property(nonatomic) int affectedRows;
@property(nonatomic) long long lastInsertedRowID;

- (id) initWithDataBaseFileName:(NSString *)dbFileName;

- (NSArray *)loadDatatFromDB;

- (NSArray *)selectRowsWithColumnNames:(NSArray *)columnNames byColumnName:(NameOfColumnInRow)columnNameInRow withSelectedTask:(Task *)selectedTask;

- (void) addRowInDb:(Task *)task;

- (void) updateRowInDb:(Task *)taskToUpdate;

- (void)deleteRowFromDbByTaskId:(Task *)task;

- (void)deleteAllRowsFromDb;

@end
