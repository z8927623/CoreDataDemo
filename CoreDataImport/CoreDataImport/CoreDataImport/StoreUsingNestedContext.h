//
//  StoreUsingNestedContext.h
//  CoreDataImport
//
//  Created by wildyao on 14/12/22.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import <Foundation/Foundation.h>

// master - main - worker as nested contexts

@interface StoreUsingNestedContext : NSObject

+ (instancetype)sharedStore;

- (void)saveContext;

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainQueueContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *privateQueueContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *defaultPrivateQueueContext;

@end
