//
//  ImportViewController.m
//  CoreDataImport
//
//  Created by Wild Yaoyao on 14/12/7.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "ImportViewController.h"
#import "Stop.h"
#import "ImportOperation.h"
#import "FetchedResultsTableDataSource.h"
#import "StoreUsingNotification.h"
#import "StoreUsingNestedContext.h"
#import "Importer.h"

@interface ImportViewController ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) FetchedResultsTableDataSource *dataSource;
@property (nonatomic, strong) Importer *importer;

@end

@implementation ImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    // 配置NSFetchRequest
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Stop"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    // 建立NSFetchedResultsController，参数：NSFetchRequest、用于展示信息的main context
//    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.storeUsingNotification.mainQueueContext sectionNameKeyPath:nil cacheName:nil];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.storeUsingNestedContext.mainQueueContext sectionNameKeyPath:nil cacheName:nil];
    
    self.dataSource = [[FetchedResultsTableDataSource alloc] initWithTableView:self.tableView fetchedResultsController:fetchedResultsController];
    self.dataSource.configureCellBlock = ^(UITableViewCell *cell, Stop *item) {
        cell.textLabel.text = item.name;
    };
    
    self.tableView.dataSource = self.dataSource;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UIBarButtonItem *importItem = [[UIBarButtonItem alloc] initWithTitle:@"Import" style:UIBarButtonItemStylePlain target:self action:@selector(startImport:)];
    self.navigationItem.rightBarButtonItem = importItem;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelItem;
}


- (void)startImport:(id)sender
{
    self.progressIndicator.progress = 0;
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"stops" ofType:@"txt"];

//    // store传给operation
//    ImportOperation *operation = [[ImportOperation alloc] initWithStore:self.storeUsingNotification fileName:fileName];
//    operation.progressCallback = ^(float progress) {
//        // 在主队列里执行UI操作
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            self.progressIndicator.progress = progress;
//        }];
//    };
//    [self.operationQueue addOperation:operation];
    
    Importer *importer = [[Importer alloc] initWithStore:self.storeUsingNestedContext fileName:fileName];
    importer.progressCallback = ^(float progress) {
        // 在主队列里执行UI操作
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.progressIndicator.progress = progress;
        }];
    };
    [importer startOperation];
    self.importer = importer;
}

- (void)cancel:(id)sender
{
//    [self.operationQueue cancelAllOperations];
    [self.importer cancelOperation];
}

@end
