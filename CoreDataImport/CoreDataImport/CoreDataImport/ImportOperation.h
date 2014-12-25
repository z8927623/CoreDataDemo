//
//  ImportOperation.h
//  CoreDataImport
//
//  Created by Wild Yaoyao on 14/12/7.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StoreUsingNotification;

@interface ImportOperation : NSOperation

- (id)initWithStore:(StoreUsingNotification *)store fileName:(NSString *)name;

@property (nonatomic) float progress;
@property (nonatomic, copy) void (^progressCallback)(float);

@end
