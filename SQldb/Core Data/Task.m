//
//  Task.m
//  SQldb
//
//  Created by Radzivon Uhrynovich on 17.07.2018.
//  Copyright © 2018 BNR. All rights reserved.
//

#import "Task.h"

@implementation Task

- (id)initTaslWithId:(NSInteger)taskID title:(NSString *)title date:(NSString *)date priority:(NSString *)priority andTaskDescription:(NSString *)taskDescription {
    self = [super init];
    
    if(self) {
        _taskID = taskID;
        _title = title;
        _date = date;
        _priority = priority;
        _taskDescription = taskDescription;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%ld,\n%@,\n%@,\n%@,\n%@", _taskID, _title, _date, _priority, _taskDescription];
}

@end
