//
//  Task.h
//  SQldb
//
//  Created by Radzivon Uhrynovich on 17.07.2018.
//  Copyright © 2018 BNR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject
@property(nonatomic, assign) NSInteger taskID;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *priority;
@property(nonatomic, strong) NSString *taskDescription;

- (id)initTaslWithId:(NSInteger)taskID title:(NSString *)title date:(NSString *)date priority:(NSString *)priority andTaskDescription:(NSString *)taskDescription;

@end
