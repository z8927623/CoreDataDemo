//
//  PersistentStack.h
//  CoreDataTableView
//
//  Created by Wild Yaoyao on 14/11/28.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersistentStack : NSObject

- (id)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end
