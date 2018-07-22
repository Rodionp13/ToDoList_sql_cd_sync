//
//  DMManager.h
//  SQldb
//
//  Created by Radzivon Uhrynovich on 17.07.2018.
//  Copyright © 2018 BNR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyFirstDBManager.h"
#import "CDmanager.h"

static NSString *const kSqlData = @"sqlData";
static NSString *const kCdData =  @"cdData";


@interface DMManager : NSObject

@property(nonatomic, assign, getter=isSwitchOn) BOOL switchOn;

- (id)initWithSwitchState:(BOOL)state;

- (NSDictionary *)loadDataFromBothDBs;

- (NSDictionary *)selectRowFromBothDBsWith:(Task *)coreDataAndSqlSelectedTaskToLoad sqlColumnNames:(NSArray *)sqlByColumnName :(NameOfColumnInRow)columnNameInRow;

- (void) addRowInBothDBs:(Task *)newTask;

- (void) updateRowInBothDBs:(Task *)forCoreDataTaskBeforeUpdate newInfoForTask:(Task *)coreDataAndSqlNewInfoForTask;

 - (void)deleteRowFromBothDBsWithTask:(Task *)taskToDelete;

- (void)deleteAllRowsFromBothDBs;

@end



/*
 CORE DATA
 - (NSArray *)loadDataFromDB:(nullable Task*)taskToLoad; //OK
 
 - (void) addRowInDb:(Task *)newTask;                    //OK
 
 - (void)updateRowInDb:(Task *)taskBeforeUpdate newInfoForTask:(Task *)newInfoForTask;
                                                         //OK
 - (void)deleteRowFromDbWithTask:(Task *)task;           //OK
 
 - (void)deleteAllRowsFromDb;                            //OK
 
 SQL
 - (id) initWithDataBaseFileName:(NSString *)dbFileName;
 
 - (NSArray *)loadDatatFromDB;                           //OK
 
 - (NSArray *)selectRowsWithColumnNames:(NSArray *)columnNames byColumnName:(NameOfColumnInRow)columnNameInRow withSelectedTask:(Task *)selectedTask;------------------------------ //OK
 
 - (void) addRowInDb:(Task *)task;                       //OK
 
 - (void) updateRowInDb:(Task *)taskToUpdate;            //OK
 
 - (void)deleteRowFromDbByTaskId:(Task *)task;           //OK
 
 - (void)deleteAllRowsFromDb;                            //OK
 */
 
