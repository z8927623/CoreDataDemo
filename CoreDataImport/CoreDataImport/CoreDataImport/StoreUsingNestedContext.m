//
//  StoreUsingNestedContext.m
//  CoreDataImport
//
//  Created by wildyao on 14/12/22.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "StoreUsingNestedContext.h"

@interface StoreUsingNestedContext ()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *privateQueueContext;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *mainQueueContext;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *defaultPrivateQueueContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end

@implementation StoreUsingNestedContext

+ (instancetype)sharedStore
{
    static StoreUsingNestedContext *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[StoreUsingNestedContext alloc] init];
    });
    
    return sharedStore;
}

- (void)saveContext
{
    NSManagedObjectContext *privateQueueContext = self.privateQueueContext;
    NSManagedObjectContext *mainQueueContext = self.mainQueueContext;
    NSManagedObjectContext *defaultPrivateQueueContext = self.defaultPrivateQueueContext;
    
    if ([privateQueueContext hasChanges]) {
        
        __block NSError *errorInBlock = nil;
        [privateQueueContext performBlockAndWait:^{
            // push to parent: mainQueueContext
            if (![privateQueueContext save:&errorInBlock]) {
                NSLog(@"Unresolved error %@, %@", errorInBlock, [errorInBlock userInfo]);
                abort();
            }
            
            [mainQueueContext performBlock:^{
                NSLog(@"1. Is Main Thread? %d", [NSThread currentThread] == [NSThread mainThread]);
                // push to parent: defaultPrivateQueueContext
                if (![mainQueueContext save:&errorInBlock]) {
                    NSLog(@"Unresolved error %@, %@", errorInBlock, [errorInBlock userInfo]);
                    abort();
                }
                
                // save parent to disk asynchronously
                [defaultPrivateQueueContext performBlock:^{
                    //                    NSLog(@"2. Is Main Thread? %d", [NSThread currentThread] == [NSThread mainThread]);
//                    for (int i = 0; i < 100000; i++) {
//                        NSLog(@"i =  %d", i);
//                    }
                    if (![defaultPrivateQueueContext save:&errorInBlock]) {
                        NSLog(@"Unresolved error %@, %@", errorInBlock, [errorInBlock userInfo]);
                        abort();
                    }
                }];
            }];
        }];
    }
}

// worker context，用于处理数据（增删改查）
- (NSManagedObjectContext *)privateQueueContext
{
    if (!_privateQueueContext) {
        // 使用私有队列
        _privateQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        // 设置main context为parentContext
        _privateQueueContext.parentContext = [self mainQueueContext];
    }
    
    return _privateQueueContext;
    
    //    // 临时worker context
    //    NSManagedObjectContext *privateQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    //    // 设置main context为parentContext
    //    privateQueueContext.parentContext = [self mainQueueContext];
    //
    //    return privateQueueContext;
}

// main contxt，用于展示信息
- (NSManagedObjectContext *)mainQueueContext
{
    if (!_mainQueueContext) {
        // 使用主队列
        _mainQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        // 设置default context为parentContext
        _mainQueueContext.parentContext = [self defaultPrivateQueueContext];
//        _mainQueueContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _mainQueueContext;
}

// 默认private context，用于保存数据
- (NSManagedObjectContext *)defaultPrivateQueueContext
{
    if (!_defaultPrivateQueueContext) {
        // 使用私有队列
        _defaultPrivateQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _defaultPrivateQueueContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _defaultPrivateQueueContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentDirectory] URLByAppendingPathComponent:@"CoreDataImport.sqlite"];
    
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataImport" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSURL *)applicationDocumentDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end