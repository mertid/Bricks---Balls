//
//  BABLevelData.m
//  Bricks & Balls
//
//  Created by Merritt Tidwell on 8/7/14.
//  Copyright (c) 2014 Merritt Tidwell. All rights reserved.
//


#import "BABLevelData.h"

@implementation BABLevelData
{
    NSArray * levels;
}

+ (BABLevelData *) mainData;
{
    // static means it can't be redefined //
    static dispatch_once_t create;
    
    static BABLevelData * singleton = nil;
    
    // dispatch_once ONLY RUNS IT ONCE //
    dispatch_once(&create, ^{
        
        singleton = [[BABLevelData alloc] init];
        
    });
    
    return singleton;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
        levels = @[
                   @{
                       @"cols" : @7,
                       @"rows": @3
                       },
                   @{
                       @"cols" : @8,
                       @"rows": @4
                       },
                 ];
        
    }
    
    return self;
}

- (NSDictionary *)levelInfo
{
    return levels[self.currentLevel];
}

@end