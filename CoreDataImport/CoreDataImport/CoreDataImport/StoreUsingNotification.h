//
//  StoreUsingNotification.h
//  CoreDataImport
//
//  Created by wildyao on 14/12/22.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import <Foundation/Foundation.h>

// master - background as independent contexts

@interface StoreUsingNotification : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainQueueContext;
@property (nonatomic, strong, readonly) NSManagedObjectContext *privateQueueContext;

- (void)saveContext;

@end
