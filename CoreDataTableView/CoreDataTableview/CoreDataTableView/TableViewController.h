//
//  TableViewController.h
//  CoreDataTableView
//
//  Created by Wild Yaoyao on 14/11/28.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface TableViewController : UITableViewController

@property (nonatomic, strong) Item *parent;

@end
