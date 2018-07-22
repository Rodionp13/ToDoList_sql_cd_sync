//
//  NSArray+ParsingMOintoTask.m
//  SQldb
//
//  Created by User on 7/22/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import "NSArray+ParsingMOintoTask.h"

@implementation NSArray (ParsingMOintoTask)

- (NSArray<Task *> *)convertMOintoTask:(NSArray<NSManagedObject *> *)array {
    Task *task; NSMutableArray<Task*> *result = [NSMutableArray arrayWithCapacity:array.count];
    for (NSManagedObject *mo in array) {
        
        NSLog(@"From Category type of taskID in MO:%@", [[mo valueForKey:cdTaskID] class]);
        task = [[Task alloc] initTaslWithId:[[mo valueForKey:cdTaskID] integerValue] title:[mo valueForKey:cdTitle] date:[mo valueForKey:cdDate] priority:[mo valueForKey:cdPriority] andTaskDescription:[mo valueForKey:cdTaskDescription]];
        [result addObject:task];
    }
    
    return [result copy];
}

@end
