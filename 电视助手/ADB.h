//
//  ADB.h
//  电视助手
//
//  Created by zhangxi on 14-5-21.
//  Copyright (c) 2014年 zhangxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADB : NSObject
{
    NSString *adb;
}

-(NSArray *)scan;
-(NSArray *)scan:(int)port;

-(BOOL)connect:(NSString *)address;
-(BOOL)connect:(NSString *)address port:(int)port;

-(BOOL)disconnect:(NSString *)address;
-(BOOL)disconnect:(NSString *)address port:(int)port;

-(NSArray *)devices;


@end
