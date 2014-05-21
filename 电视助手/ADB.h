//
//  ADB.h
//  电视助手
//
//  Created by zhangxi on 14-5-21.
//  Copyright (c) 2014年 zhangxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"




@interface ADB : NSObject<GCDAsyncSocketDelegate>
{
    NSString *adb;
    GCDAsyncSocket *socket;
    NSMutableArray *sockets;
    NSMutableArray *ips;
    void (^scanResult)(NSArray *result);
}

-(NSArray *)scanWithResult:(void(^)(NSArray *result))result;
-(NSArray *)scan:(int)port;

-(BOOL)connect:(NSString *)address;
-(BOOL)connect:(NSString *)address port:(int)port;

-(BOOL)disconnect:(NSString *)address;
-(BOOL)disconnect:(NSString *)address port:(int)port;

-(NSArray *)devices;


@end
