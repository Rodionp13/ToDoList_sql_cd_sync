//
//  AppDelegate.h
//  SQldb
//
//  Created by User on 7/10/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(readonly, nonatomic) NSManagedObjectContext *managedobjectContext;
@property(readonly, nonatomic) NSManagedObjectModel *managedobjectModel;
@property(readonly, nonatomic) NSPersistentStoreCoordinator *psc;

- (NSURL *)applicationDocumentDirectory;

@end

