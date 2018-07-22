//
//  CAmanager.h
//  SQldb
//
//  Created by Radzivon Uhrynovich on 17.07.2018.
//  Copyright © 2018 BNR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Task.h"

@interface CDmanager : NSObject

- (NSArray *)loadDataFromDB:(nullable Task*)taskToLoad;

- (void) addRowInDb:(Task *)newTask;

- (void)updateRowInDb:(Task *)taskBeforeUpdate newInfoForTask:(Task *)newInfoForTask;

- (void)deleteRowFromDbWithTask:(Task *)task;

- (void)deleteAllRowsFromDb;

@end
