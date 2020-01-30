//
//  TableViewController.h
//  Labb2AlfredSävblomVG
//
//  Created by Alfred on 2020-01-20.
//  Copyright © 2020 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewController : UITableViewController

@property (nonatomic) NSMutableArray* todoTasks;

@property (nonatomic) NSMutableArray* priorityTasks;

@property (nonatomic) NSMutableArray* regularTasks;

@property (nonatomic) NSMutableArray* doneTasks;

@end

NS_ASSUME_NONNULL_END
