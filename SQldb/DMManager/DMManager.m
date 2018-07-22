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

- (NSDictionary *)loadDataFromBothDBs {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
//    if(!self.isSwitchOn) {
        NSArray *sqlData = [self.sqlManager loadDatatFromDB];
        [result setValue:sqlData forKey:kSqlData];
//    } else {
        NSArray * cdData = [self.cdManager loadDataFromDB:nil];
        [result setValue:cdData forKey:kCdData];
//    }
    
    NSLog(@"\n\n\nloadDataFromDB RESULT:\n\n\n, %@",result);
    
    return result;
}

- (NSDictionary *)selectRowFromBothDBsWith:(Task *)coreDataAndSqlSelectedTaskToLoad sqlColumnNames:(NSArray *)sqlByColumnName :(NameOfColumnInRow)columnNameInRow {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
//    if(!self.isSwitchOn) {
        NSArray *sqlData = [self.sqlManager selectRowsWithColumnNames:nil byColumnName:NameOfColumnInRowID withSelectedTask:coreDataAndSqlSelectedTaskToLoad];
        [result setValue:sqlData forKey:kSqlData];
//    } else {
        NSArray * cdData = [self.cdManager loadDataFromDB:coreDataAndSqlSelectedTaskToLoad];
        [result setValue:cdData forKey:kCdData];
//    }
    
    NSLog(@"\n\nselectRowFromBothDBsWith RESULT:\n\n, %@",result);
    
    return result;
}


- (void)addRowInBothDBs:(Task *)newTask {
    
//    if(!self.isSwitchOn) {
        [self.sqlManager addRowInDb:newTask];
//    } else {
        [self.cdManager addRowInDb:newTask];
//    }
}

- (void)updateRowInBothDBs:(Task *)forCoreDataTaskBeforeUpdate newInfoForTask:(Task *)coreDataAndSqlNewInfoForTask {
    
//    if(!self.isSwitchOn) {
        [self.sqlManager updateRowInDb:coreDataAndSqlNewInfoForTask];
//    } else {
        [self.cdManager updateRowInDb:forCoreDataTaskBeforeUpdate newInfoForTask:coreDataAndSqlNewInfoForTask];
//    }
}

- (void)deleteRowFromBothDBsWithTask:(Task *)taskToDelete {
    
//    if(!self.isSwitchOn) {
        [self.sqlManager deleteRowFromDbByTaskId:taskToDelete];
//    } else {
        [self.cdManager deleteRowFromDbWithTask:taskToDelete];
//    }
    
}

- (void)deleteAllRowsFromBothDBs {
    
//    if(!self.isSwitchOn) {
        [self.sqlManager deleteAllRowsFromDb];
//    } else {
        [self.cdManager deleteAllRowsFromDb];
//    }
}


@end
