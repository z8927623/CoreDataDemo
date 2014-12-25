//
//  Item.h
//  CoreDataTableView
//
//  Created by Wild Yaoyao on 14/11/28.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Item : NSManagedObject

@property (nonatomic) int64_t order;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) Item *parent;

+ (instancetype)insertItemWithTitle:(NSString*)title
                             parent:(Item *)parent
             inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

// 子NSFetchedResultsController
- (NSFetchedResultsController *)childrenFetchedResultsController;

@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Item *)value;
- (void)removeChildrenObject:(Item *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

@end


