//
//  NSArray+ParsingMOintoTask.h
//  SQldb
//
//  Created by User on 7/22/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Task.h"
#import "CDmanager.h"

@interface NSArray (ParsingMOintoTask)
- (NSArray<Task*> *)convertMOintoTask:(NSArray<NSManagedObject*> *)array;
@end
