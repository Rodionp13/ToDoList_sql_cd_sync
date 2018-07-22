//
//  CAmanager.m
//  SQldb
//
//  Created by Radzivon Uhrynovich on 17.07.2018.
//  Copyright © 2018 BNR. All rights reserved.
//

#import "CDmanager.h"
#import "NSArray+ParsingMOintoTask.h"

@interface CDmanager()
@property(nonatomic, strong) NSManagedObjectContext *contex;
@end

@implementation CDmanager

- (NSManagedObjectContext *)contex {
    if(_contex != nil) {
        return _contex;
    } else {
        return [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedobjectContext];
    }
}

- (NSArray *)loadDataFromDB:(nullable Task*)taskToLoad {
    NSEntityDescription *entityDescr = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:self.contex];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescr];
//    [request setReturnsObjectsAsFaults:NO];
    
    NSError *err;
    NSArray *result;
    if(taskToLoad != nil) {
        [request setPredicate:[self configurePredicateWithTask:taskToLoad]];
        result = [self.contex executeFetchRequest:request error:&err];
        if(err != nil) {
            NSLog(@"1.Failed to load data from CD with predicate\n%@\n%@", err, [err localizedDescription]);
        } else {
            NSLog(@"1.Success load data from CD with predicate, element count=%lu\n%@", [result count], [result description]);
        }
    } else {
        result = [self.contex executeFetchRequest:request error:&err];
        result = [result convertMOintoTask:result];
        if(err != nil) {
            NSLog(@"1.Failed to load data from CD\n%@\n%@", err, [err localizedDescription]);
        } else {
            NSLog(@"1.Success load data from CD, element count=%lu", [result count]);
        }
    }
    
    
    return result;
}

- (NSPredicate *)configurePredicateWithTask:(Task *)task {
    NSNumber *taskID = [NSNumber numberWithInteger:task.taskID];
    NSDictionary *dataForPredicate = @{cdTaskID:taskID, cdTitle:task.title, cdDate:task.date, cdPriority:task.priority, cdTaskDescription:task.taskDescription};
    
    NSMutableArray *subpredicates = [NSMutableArray arrayWithCapacity:dataForPredicate.allKeys.count];
    
    for(NSString *key in dataForPredicate.allKeys) {
        [subpredicates addObject:[NSPredicate predicateWithFormat:@"%K == %@", key, [dataForPredicate valueForKey:key]]];
    }
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    
    return predicate;
}

- (void)addRowInDb:(Task *)newTask {
    NSNumber *taskID = [NSNumber numberWithInteger:newTask.taskID];
    NSDictionary *dataForNewMO = @{cdTaskID:taskID, cdTitle:newTask.title, cdDate:newTask.date, cdPriority:newTask.priority, cdTaskDescription:newTask.taskDescription};
    NSEntityDescription *entityDescr = [NSEntityDescription entityForName:kEntityName inManagedObjectContext:self.contex];
    NSManagedObject *newMO = [[NSManagedObject alloc] initWithEntity:entityDescr insertIntoManagedObjectContext:self.contex];
    [newMO setValuesForKeysWithDictionary:dataForNewMO];
    
    NSError *err;
    if(![self.contex save:&err]) {
        NSLog(@"2.Failed to add new task in CD\n%@\n%@", err, [err localizedDescription]);
    } else {
        NSLog(@"2.Success added new task in CD\n NEW TASK:\n%@", [newMO description]);
    }
}

- (void)updateRowInDb:(Task *)taskBeforeUpdate newInfoForTask:(Task *)newInfoForTask {
    NSNumber *taskID = [NSNumber numberWithInteger:newInfoForTask.taskID];
    NSDictionary *dataToUpdateMO = @{cdTaskID:taskID, cdTitle:newInfoForTask.title, cdDate:newInfoForTask.date, cdPriority:newInfoForTask.priority, cdTaskDescription:newInfoForTask.taskDescription};
    
    NSArray *result = [self loadDataFromDB:taskBeforeUpdate];
    
    if(result.count > 1) {
        NSAssert(errno, ([NSString stringWithFormat:@"Arr to update has more than 1 MO, == %lu", result.count]));
    }
    
    NSManagedObject *MOtoUpdate = [result lastObject];
    [MOtoUpdate setValuesForKeysWithDictionary:dataToUpdateMO];
    
    NSError *err;
    if(![self.contex save:&err]) {
        NSLog(@"3.Failed to update task in CD\n%@\n%@", err, [err localizedDescription]);
    } else {
        NSLog(@"3.Success updated task in CD\n UPDATED TASK:\n%@", [MOtoUpdate description]);
    }
}

- (void)deleteAllRowsFromDb {
    NSArray *result = [self loadDataFromDB:nil];
    if(result.count == 0) NSAssert(errno, @"arr count is 0, deleteRowFromDbWithTask");
    
    for(NSManagedObject *taskMO in result) {
        [self.contex deleteObject:taskMO];
    }
    NSError *err;
    if(![self.contex save:&err]) {
        NSLog(@"4.Failed to delete all objects from CD\n%@\n%@", err, [err localizedDescription]);
    } else {
        NSLog(@"4. Success deleted all objects from CD\n COUNT=%lu", result.count);
    }
    
}

- (void)deleteRowFromDbWithTask:(Task *)task {
    NSArray<NSManagedObject*> *result = [self loadDataFromDB:task];
    
    if(result.count != 1) {NSAssert(errno, ([NSString stringWithFormat:@"result in delete arr wrong!!! count = %lu", result.count]));}
    
    NSManagedObject *MOtoDelete = [result lastObject];
    [self.contex deleteObject:MOtoDelete];
    
    NSError *err;
    if(![self.contex save:&err]) {
        NSLog(@"5.Failed to delete task from CD\n%@\n%@", err, [err localizedDescription]);
    } else {
        NSLog(@"5.Success deleted task from CD\n%@", [MOtoDelete description]);
    }
}

@end
