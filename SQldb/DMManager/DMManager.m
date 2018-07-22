//
//  DMManager.m
//  SQldb
//
//  Created by Radzivon Uhrynovich on 17.07.2018.
//  Copyright © 2018 BNR. All rights reserved.
//

#import "DMManager.h"

@interface DMManager()

@property(nonatomic, strong) MyFirstDBManager *sqlManager;
@property(nonatomic, strong) CDmanager *cdManager;

@end

@implementation DMManager

- (id)initWithSwitchState:(BOOL)state {
    self = [super init];
    
    if(self) {
        _switchOn = state;
        _sqlManager = [[MyFirstDBManager alloc] initWithDataBaseFileName:kSqlDbFileName];
        _cdManager = [[CDmanager alloc] init];
    }
    return self;
}

- (NSArray *)loadDataFromBothDBs {
    
    NSArray *result;
    if(!self.isSwitchOn) {
        result = [self.sqlManager loadDatatFromDB];
    } else {
        result = [self.cdManager loadDataFromDB:nil];
    }
    if(self.switchOn) {NSLog(@"\n\n\nloadDataFrom CORE DATA RESULT:\n\n\n, %@",result);}
    if(!self.switchOn) {NSLog(@"\n\n\nloadDataFrom SQLite RESULT:\n\n\n, %@",result);}
    return result;
}

- (NSArray *)selectRowFromBothDBsWith:(Task *)coreDataAndSqlSelectedTaskToLoad sqlColumnNames:(NSArray *)sqlByColumnName :(NameOfColumnInRow)columnNameInRow {
    
    NSArray *result;
    if(!self.isSwitchOn) {
        result = [self.sqlManager selectRowsWithColumnNames:nil byColumnName:NameOfColumnInRowID withSelectedTask:coreDataAndSqlSelectedTaskToLoad];
    } else {
        result = [self.cdManager loadDataFromDB:coreDataAndSqlSelectedTaskToLoad];
    }
    NSLog(@"\n\nselectRowFromBothDBsWith RESULT:\n\n, %@",result);
    return result;
}

- (void)addRowInBothDBs:(Task *)newTask {
    [self.sqlManager addRowInDb:newTask];
    [self.cdManager addRowInDb:newTask];
}

- (void)updateRowInBothDBs:(Task *)forCoreDataTaskBeforeUpdate newInfoForTask:(Task *)coreDataAndSqlNewInfoForTask {
    [self.sqlManager updateRowInDb:coreDataAndSqlNewInfoForTask];
    [self.cdManager updateRowInDb:forCoreDataTaskBeforeUpdate newInfoForTask:coreDataAndSqlNewInfoForTask];
}

- (void)deleteRowFromBothDBsWithTask:(Task *)taskToDelete {
    [self.sqlManager deleteRowFromDbByTaskId:taskToDelete];
    [self.cdManager deleteRowFromDbWithTask:taskToDelete];
}

- (void)deleteAllRowsFromBothDBs {
    [self.sqlManager deleteAllRowsFromDb];
    [self.cdManager deleteAllRowsFromDb];
}


@end
