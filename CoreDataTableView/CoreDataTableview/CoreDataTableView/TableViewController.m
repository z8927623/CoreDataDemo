//
//  TableViewController.m
//  CoreDataTableView
//
//  Created by Wild Yaoyao on 14/11/28.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "TableViewController.h"
#import "FetchedResultsControllerDataSource.h"
#import "Item.h"

static NSString *const selectItemSegue = @"SelectItem";

@interface TableViewController () <UITextFieldDelegate, FetchedResultsControllerDataSourceDelegate>

@property (nonatomic, strong) FetchedResultsControllerDataSource *fetchedResultsControllerDataSource;
@property (nonatomic, strong) UITextField *titleField;

@property (nonatomic, assign) int i;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(onBtnAdd:)];
    self.navigationItem.rightBarButtonItem = addBtn;

    [self setupFetchedResultsController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.fetchedResultsControllerDataSource.paused = NO;
    
    self.i = 0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.fetchedResultsControllerDataSource.paused = YES;
}

- (void)setupFetchedResultsController
{
    self.fetchedResultsControllerDataSource = [[FetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    // self.fetchedResultsControllerDataSource.fetchedResultsController and self.parent call setters
    
    // 获取parent的child，即当前的controller
    self.fetchedResultsControllerDataSource.fetchedResultsController = self.parent.childrenFetchedResultsController;
    self.fetchedResultsControllerDataSource.delegate = self;
    self.fetchedResultsControllerDataSource.reuseIdentifier = @"Cell";
}

- (void)onBtnAdd:(UIBarButtonItem *)btn
{
    NSString *title = [NSString stringWithFormat:@"title %d", self.i++];;
    
    [Item insertItemWithTitle:title parent:self.parent inManagedObjectContext:self.parent.managedObjectContext];
    
    [self.parent.managedObjectContext save:NULL];
}

#pragma mark - FetchedResultsControllerDataSourceDelegate
- (void)configureCell:(id)theCell withObject:(id)object
{
    Item *item = object;
    UITableViewCell *cell = theCell;
    cell.textLabel.text = item.title;
}

- (void)deleteObject:(id)object
{
    Item *item = object;
    
    NSString *actionName = [NSString stringWithFormat:NSLocalizedString(@"Delete \"%@\"", @"Delete undo action name"), item.title];
    [self.parent.managedObjectContext.undoManager setActionName:actionName];

    [self.undoManager setActionName:actionName];
    
    [item.managedObjectContext deleteObject:item];
    
    // 立马存储
    [item.managedObjectContext save:NULL];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:selectItemSegue]) {
        [self presentSubItemViewController:segue.destinationViewController];
    }
}

- (void)presentSubItemViewController:(TableViewController *)subItemViewController
{
    Item *item = [self.fetchedResultsControllerDataSource selectedItem];
    
    subItemViewController.parent = item;
}

#pragma mark - Setters

- (void)setParent:(Item *)parent
{
    _parent = parent;
    
    self.navigationItem.title = parent.title;
}

#pragma mark Undo

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (NSUndoManager *)undoManager
{
    return self.parent.managedObjectContext.undoManager;
}

@end
