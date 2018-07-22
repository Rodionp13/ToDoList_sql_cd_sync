//
//  AppDelegate.m
//  SQldb
//
//  Created by User on 7/10/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property(nonatomic) NSManagedObjectContext *managedobjectContext;
@property(nonatomic) NSManagedObjectModel *managedobjectModel;
@property(nonatomic) NSPersistentStoreCoordinator *psc;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - My Core Data stack

- (NSManagedObjectContext *) managedobjectContext {
    if(_managedobjectModel != nil)
    {
        return _managedobjectContext;
    }
    
    NSPersistentStoreCoordinator *psc = self.psc;
    if(psc != nil)
    {
        _managedobjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedobjectContext setPersistentStoreCoordinator:psc];
    }
    return _managedobjectContext;
    
}


- (NSPersistentStoreCoordinator *) psc {
    if(_psc != nil)
    {
        return _psc;
    }
    //    NSURL *documentURL = [[self applicationDocumentDirectory] URLByAppendingPathComponent:@"CodeTut_.sqlite"];
    NSURL *documentURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *filePath = [documentURL URLByAppendingPathComponent:@"CDTasks.sqlite"];
    NSLog(@"%@", filePath);
    NSError *error;
    _psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedobjectModel];
    [_psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:filePath options:nil error:&error];
    if(error != nil)
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _psc;
}



- (NSManagedObjectModel *) managedobjectModel {
    if(_managedobjectModel != nil)
    {
        return _managedobjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CDTasks" withExtension:@"momd"];
    _managedobjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedobjectModel;
}


- (NSURL *)applicationDocumentDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
