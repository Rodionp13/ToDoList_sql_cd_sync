//
//  DetailTVCell.h
//  SQldb
//
//  Created by User on 7/10/18.
//  Copyright © 2018 BNR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface ViewControllerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *highPtiorLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

- (void)setUpPriorityBttnWith:(NSArray *)dataSource indexPath:(NSIndexPath *)indexPath;
@end
