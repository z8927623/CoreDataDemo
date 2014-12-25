//
//  FetchedResultsControllerDataSource.m
//  CoreDataTableView
//
//  Created by Wild Yaoyao on 14/11/29.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "FetchedResultsControllerDataSource.h"

@interface FetchedResultsControllerDataSource ()

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation FetchedResultsControllerDataSource

- (id)initWithTableView:(UITableView *)tableView
{
    if (self = [super init]) {
        self.tableView = tableView;
        self.tableView.dataSource = self;
    }
    return self;
}

- (id)selectedItem
{
    NSIndexPath *path = self.tableView.indexPathForSelectedRow;
    return path ? [self.fetchedResultsController objectAtIndexPath:path] : nil;
}


#pragma mark - Setters

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    _fetchedResultsController = fetchedResultsController;
    _fetchedResultsController.delegate = self;
    [_fetchedResultsController performFetch:NULL];
}

- (void)setPaused:(BOOL)paused
{
    _paused = paused;
    
    if (paused) {
        self.fetchedResultsController.delegate = nil;
    } else {
        self.fetchedResultsController.delegate = self;
        [self.fetchedResultsController performFetch:NULL];
        [self.tableView reloadData];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    id cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier];
    [self.delegate configureCell:cell withObject:object];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.delegate deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (type == NSFetchedResultsChangeMove) {
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    } else if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        
    }
}

@end