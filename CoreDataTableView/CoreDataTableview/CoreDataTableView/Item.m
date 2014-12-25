//
//  Item.m
//  CoreDataTableView
//
//  Created by Wild Yaoyao on 14/11/28.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "Item.h"
#import "Item.h"


@implementation Item

@dynamic order;
@dynamic title;
@dynamic children;
@dynamic parent;

+ (instancetype)insertItemWithTitle:(NSString*)title
                             parent:(Item *)parent
             inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    // parent的孩子个数
    NSUInteger order = [parent numberOfChildren];
    
    Item *item = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:managedObjectContext];
    
    item.order = order;
    item.title = title;
    item.parent = parent;
    
    return item;
}

+ (NSString *)entityName
{
    return @"Item";
}

- (NSUInteger)numberOfChildren
{
    return self.children.count;
}

// 搜索item的child数据，生成NSFetchedResultsController
- (NSFetchedResultsController *)childrenFetchedResultsController
{
    // 方法1
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:[self.class entityName] inManagedObjectContext:self.managedObjectContext];
//    [request setEntity:entity];
    
    // 方法2
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self.class entityName]];
    // parent为自身的children
    request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", self];
    // 按照order排序
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]];   // YES为正序
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

// 使删除后的数据仍然有序
- (void)prepareForDeletion
{
    if (self.parent.isDeleted) {
        return;
    }
    
    // sibling：兄弟姊妹
    NSSet *siblings = self.parent.children;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"order > %d", self.order];
    NSSet *itemsAfterSelf = [siblings filteredSetUsingPredicate:predicate];
    
    // 重新调整order：比自己order大的都减一
    [itemsAfterSelf enumerateObjectsUsingBlock:^(Item *sibling, BOOL *stop){
        sibling.order = sibling.order - 1;
    }];
}

@end
