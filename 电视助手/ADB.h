//
//  ADB.h
//  电视助手
//
//  Created by zhangxi on 14-5-21.
//  Copyright (c) 2014年 zhangxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"


@protocol ADBDelegate <NSObject>

-(void)findSocket:(GCDAsyncSocket *)socket;

@end

@interface ADB : NSObject<GCDAsyncSocketDelegate>
{
    NSString *adb;
    GCDAsyncSocket *socket;
    NSMutableArray *sockets;
    NSMutableArray *ips;
    BOOL isScanning;
}
@property(nonatomic,weak) id<ADBDelegate> delegate;

-(NSArray *)scan;
-(NSArray *)scan:(int)port;
-(void)stopScan;

-(BOOL)connect:(NSString *)address;
-(BOOL)connect:(NSString *)address port:(int)port;

-(BOOL)disconnect:(NSString *)address;
-(BOOL)disconnect:(NSString *)address port:(int)port;

-(NSArray *)devices;

-(BOOL)install:(NSString *)path;
@end
