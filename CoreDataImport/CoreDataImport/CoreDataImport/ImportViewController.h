//
//  ImportViewController.h
//  CoreDataImport
//
//  Created by Wild Yaoyao on 14/12/7.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoreUsingNotification;
@class StoreUsingNestedContext;
@class FetchedResultsTableDataSource;

@interface ImportViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressIndicator;

@property (nonatomic, strong) StoreUsingNotification *storeUsingNotification;
@property (nonatomic, strong) StoreUsingNestedContext *storeUsingNestedContext;

@end
