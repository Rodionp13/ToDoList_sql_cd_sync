//
//  EditInfoViewController.h
//  SQLiteFIrstSample
//
//  Created by Radzivon Uhrynovich on 7/9/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
//#import "CDmanager.h"
#import "DMManager.h"

@protocol EditInfoViewControllerDelegate
- (void) editingInfoWasFinishedWithIDofNewElement;
@end

@interface EditInfoViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) id<EditInfoViewControllerDelegate> delegate;

@property (strong, nonatomic) Task *taskToEdit;

@property(nonatomic, assign, getter=isSwitchOn) BOOL switchOn;

@property (assign, nonatomic) NSUInteger idOfLastItemInTasksArray;

@end
