//
//  Store.h
//  CoreDataTableView
//
//  Created by Wild Yaoyao on 14/12/1.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;
@class NSFetchedResultsController;

// 存储类

@interface Store : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (Item *)rootItem;

@end
