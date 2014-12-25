//
//  PersistentStack.m
//  CoreDataTableView
//
//  Created by Wild Yaoyao on 14/11/28.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "PersistentStack.h"

@interface PersistentStack ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSURL *modelURL;
@property (nonatomic, strong) NSURL *storeURL;

@end

@implementation PersistentStack

- (id)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL
{
    if (self = [super init]) {
        
        self.storeURL = storeURL;
        self.modelURL = modelURL;
        
        [self setupManagedObjectContext];
    }
    
    return self;
}

- (void)setupManagedObjectContext
{
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSError *error;
    [self.managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:nil error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    
    // 添加undo支持
    self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
}

- (NSManagedObjectModel *)managedObjectModel
{
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}

@end
