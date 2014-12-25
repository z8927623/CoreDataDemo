//
//  ImportOperation.m
//  CoreDataImport
//
//  Created by Wild Yaoyao on 14/12/7.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "ImportOperation.h"
#import "StoreUsingNotification.h"
#import "NSString+ParseCSV.h"
#import "Stop.h"
#import "Stop+Import.h"

static const int ImportBatchSize = 250;

@interface ImportOperation ()

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) StoreUsingNotification *store;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ImportOperation

- (id)initWithStore:(StoreUsingNotification *)store fileName:(NSString *)name
{
    self = [super init];

    if (self) {
        self.store = store;
        self.fileName = name;
    }
    
    return self;
}

- (void)main
{
    @try {
        @autoreleasepool {
            // 使用私有的context，私有context在store里创建，和main context使用相同NSPersistentStoreCoordinator
            self.context = [self.store privateQueueContext];
            
            // 在当前线程同步执行block(相当于dispatch_sync)，直到import操作完成
            [self.context performBlockAndWait:^{
                // 导入数据，在当前线程运行
                [self import];
            }];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

- (void)import
{
    NSString *fileContents = [NSString stringWithContentsOfFile:self.fileName encoding:NSUTF8StringEncoding error:NULL];
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSInteger count = lines.count;
    
    // Granularity:间隔
    NSInteger progressGranularity = count/100;
    
    __block NSInteger idx = -1;
    
    [fileContents enumerateLinesUsingBlock:^(NSString *line, BOOL *shouldStop) {
        
        idx++;
        
        if (idx == 0) {
            return;
        }
        
        if (self.isCancelled) {
            *shouldStop = YES;
            return;
        }
        
        NSArray *components = [line csvComponents];
        
        if (components.count < 5) {
            NSLog(@"couldn't parse: %@", components);
            return;
        }
        
        // 导入CSV
        [Stop importCSVComponents:components intoContext:self.context];
        
        // 降低更新的频度，每导入100行时更新一次
        if (idx % progressGranularity == 0) {
            self.progressCallback(idx / (float)count);
        }
        
        // 每250次导入就保存一次
        if (idx % ImportBatchSize == 0) {
            // 私有context执行保存工作，在context所在线程运行
            [self.context save:NULL];
        }
    }];
    
    // 执行完上面的遍历再执行下面
    self.progressCallback(1);
    
    // 私有context执行保存工作，在context所在线程运行
    [self.context save:NULL];
}

@end
