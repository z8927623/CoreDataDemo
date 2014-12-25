//
//  FetchedResultsControllerDataSource.h
//  CoreDataTableView
//
//  Created by Wild Yaoyao on 14/11/29.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FetchedResultsControllerDataSourceDelegate <NSObject>

- (void)configureCell:(id)theCell withObject:(id)object;
- (void)deleteObject:(id)object;

@end

@interface FetchedResultsControllerDataSource : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) id <FetchedResultsControllerDataSourceDelegate> delegate;
@property (nonatomic, copy) NSString *reuseIdentifier;
@property (nonatomic) BOOL paused;

- (id)initWithTableView:(UITableView *)tableView;

- (id)selectedItem;

@end
