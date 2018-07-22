//
//  MyFirstDBManager.m
//  SQLiteFIrstSample
//
//  Created by User on 7/9/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import "MyFirstDBManager.h"
#import <sqlite3.h>
#import "Task.h"

@interface MyFirstDBManager()
@property(nonatomic, strong) NSString *documentsDirectory;
@property(nonatomic, strong) NSString *databaseFilename;

@property(nonatomic, strong) NSMutableArray *arrResults;

- (void)copyDatabaseIntoDocumentsDirectory;
- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;
@end

@implementation MyFirstDBManager

- (id)initWithDataBaseFileName:(NSString *)dbFileName {
    self = [super init];
    
    if(self) {
        //set documents directory path to the documentsDirectory property
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        //Keep the data base file name;
        _databaseFilename = dbFileName;
        
        //Copy the data base file into the documents directory if neccessary (custom method)
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

- (void)copyDatabaseIntoDocumentsDirectory {
    //Chek if db file exists in documents directory
    NSString *destination = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if(![[NSFileManager defaultManager] fileExistsAtPath:destination]) {
        //DB copping
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destination error:&error];
        
        //Check if an error ucured and display it
        if(error != nil) {
            NSLog(@"1.%@",[error localizedDescription]);
        }
    }
}

- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable {
    //Create SQLite object
    sqlite3 *sqlite3Database;

    //Set the db file path
//    NSLog(@"%@", [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename]);
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];


    //init the results Array
    if(self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [NSMutableArray array];

    //init the columns Array
    if(self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [NSMutableArray array];

    //Open db
//    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
//    sqlite3_open(<#const char *filename#>, <#sqlite3 **ppDb#>)
    BOOL open_v2 = sqlite3_open_v2([databasePath UTF8String], &sqlite3Database, SQLITE_OPEN_READWRITE, NULL);
    if(open_v2 == SQLITE_OK) {
        //declare sql stmt object -> to store in it query after it compiled into sql statement
        sqlite3_stmt *compiledStatement;

    //Load all data from db to memory
    BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK) {
            if(!queryExecutable) {
                //arr to keep each data row
//                NSMutableArray *arrDataRow;
                NSMutableDictionary *dictDataRow;

                //Loop through the results and add them to the result Array row by row
                while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
//                    arrDataRow = [NSMutableArray array];
                    dictDataRow = [NSMutableDictionary dictionary];

                    int totalColums = sqlite3_column_count(compiledStatement);
                    
                    for(int i = 0; i < totalColums; i++) {
                        char *dbColumnText = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        if(dbColumnText != NULL && dictDataRow.count != totalColums) {
                            
                            char *dbColumnName = (char *)sqlite3_column_name(compiledStatement, i);
                            [dictDataRow setValue:[NSString stringWithUTF8String:dbColumnText] forKey:[NSString stringWithUTF8String:dbColumnName]];
                        }
                    }
                    
                    if(dictDataRow.count > 0) {
                        [self.arrResults addObject:dictDataRow];
                    }
                }
            }  else {
                //executable
                if(sqlite3_step(compiledStatement) == SQLITE_DONE) {
                    //keep affected fows and last inserted row's ID
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                    NSLog(@"1.\n\naffected %d, inserted ID %lld\n\n", self.affectedRows, self.lastInsertedRowID);
                } else {
                    NSLog(@"2.Data Base error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        } else {
            NSLog(@"3.%s", sqlite3_errmsg(sqlite3Database));
        }
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(sqlite3Database);
}

- (void)executeQuery:(NSString *)query {
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}


//=============================================================================================================//
- (NSArray *)loadDatatFromDB {
    NSString *query = @"select * from myTasks";
    NSArray *result = [self loadDatatFromDB:query];
    
    return result;
}

- (NSArray *)loadDatatFromDB:(NSString *)query {
    //run non executable quary
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    NSMutableArray<Task*> *result = [NSMutableArray arrayWithCapacity:self.arrResults.count];
    
    for(NSDictionary *item in self.arrResults) {
        id taskId = [item valueForKey:kTaskId];
        NSString *title = [item valueForKey:kTitle];
        NSString *date = [item valueForKey:kDate];
        NSString *priority = [item valueForKey:kPriority];
        NSString *description = [item valueForKey:kDescription];
        
        Task *myTask = [[Task alloc] initTaslWithId:[taskId integerValue] title:title date:date priority:priority andTaskDescription:description];
        [result addObject:myTask];
    }
    
    
    return [result copy];
}
//=============================================================================================================//


- (void)deleteAllRowsFromDb {
    NSString *query = [NSString stringWithFormat:@"delete from myTasks"];
    
    [self executeQuery:query];
}

- (void)deleteRowFromDbByTaskId:(Task *)task {
    NSString *query = [NSString stringWithFormat:@"delete from myTasks where %@=%ld", kTaskId, task.taskID];
    
    [self executeQuery:query];
}


- (void) addRowInDb:(Task *)task {
   NSString *query = [NSString stringWithFormat:@"insert into myTasks values(null, '%@', '%@', '%@', '%@')", task.title.lowercaseString, task.date, task.priority, task.taskDescription];
    
    [self executeQuery:query];
}

- (void) updateRowInDb:(Task *)taskToUpdate {
    NSString *query = [NSString stringWithFormat:@"update myTasks set title='%@', date='%@', priority='%@', description='%@' where taskID=%ld", [taskToUpdate.title lowercaseString], taskToUpdate.date, taskToUpdate.priority, taskToUpdate.taskDescription, taskToUpdate.taskID];
    
    [self executeQuery:query];
}

//exmp: select date, description from Table where title = task.title
//exmp: select * from Table where taskID = task.taskID
- (NSArray *)selectRowsWithColumnNames:(NSArray *)columnNames byColumnName:(NameOfColumnInRow)columnNameInRow withSelectedTask:(Task *)selectedTask {
    
    if(columnNames.count > 2) NSAssert(errno, @"Count of columnName should not be more then 2");
    
    NSString *query;
    
    NSDictionary *context = [self defineColumnNameAndValue:columnNameInRow withSelectedTask:selectedTask];
    NSString *columnNameToSelect = [context valueForKey:@"columnName"];
    id columnValueToSelect = [context valueForKey:@"columnNameVulue"];
    
    if(columnNames.count == 2) {
        NSString *columnNameToShow1 = columnNames[0];
        NSString *columnNameToShow2 = columnNames[1];
        query = [NSString stringWithFormat:@"select %@,%@ from myTasks where %@='%@'",columnNameToShow1, columnNameToShow2, columnNameToSelect, columnValueToSelect];
    } else if(columnNames.count == 1) {
        NSString *columnNameToShow = columnNames[0];
        query = [NSString stringWithFormat:@"select %@ from myTasks where %@='%@'", columnNameToShow,columnNameToSelect, columnValueToSelect];
    } else if(columnNames.count == 0 || columnNames == nil) {
        query = [NSString stringWithFormat:@"select * from myTasks where %@='%@'", columnNameToSelect, columnValueToSelect];
    }
    
    NSArray *result = [self loadDatatFromDB:query];
    
    return result;
}



- (NSDictionary *)defineColumnNameAndValue:(NameOfColumnInRow)nameOfColumnInRow withSelectedTask:(Task *)selectedTask {
    NSString *columnName;
    id columnNameVulue;
    
    switch (nameOfColumnInRow) {
        case 0:
            columnName = kTaskId;
            columnNameVulue = [NSNumber numberWithInteger:selectedTask.taskID];
            break;
        case 1:
            columnName = kTitle;
            columnNameVulue = selectedTask.title;
            break;
        case 2:
            columnName = kDate;
            columnNameVulue = selectedTask.date;
            break;
        case 3:
            columnName = kPriority;
            columnNameVulue = selectedTask.priority;
            break;
        case 4:
            columnName = kDescription;
            columnNameVulue = selectedTask.taskDescription;
            break;
        default:
            break;
    }
    return @{@"columnName":columnName,@"columnNameVulue":columnNameVulue};
}

@end
