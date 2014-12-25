//
//  Importer.h
//  CoreDataImport
//
//  Created by wildyao on 14/12/22.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StoreUsingNestedContext;

@interface Importer : NSObject

- (id)initWithStore:(StoreUsingNestedContext *)store fileName:(NSString *)name;

- (void)startOperation;
- (void)cancelOperation;

@property (nonatomic) BOOL isCancelled;
@property (nonatomic) float progress;
@property (nonatomic, copy) void (^progressCallback)(float);

@end
