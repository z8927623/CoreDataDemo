//
//  Store.m
//  CoreDataTableView
//
//  Created by Wild Yaoyao on 14/12/1.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "Store.h"
#import "Item.h"

@implementation Store

// 根item
- (Item *)rootItem
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    // parent为nil
    request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", nil];
    NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:NULL];
    Item *rootItem = [objects lastObject];
    
    if (rootItem == nil) {
        rootItem = [Item insertItemWithTitle:nil parent:nil inManagedObjectContext:self.managedObjectContext];
    }
    
    return rootItem;
}

@end
