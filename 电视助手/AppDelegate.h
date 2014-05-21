//
//  AppDelegate.h
//  电视助手
//
//  Created by zhangxi on 14-5-21.
//  Copyright (c) 2014年 zhangxi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GCDAsyncSocket.h"
#import "ADB.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *asyncSocket;
    NSMutableArray *availableHosts;
    NSMutableArray *sockets;
    
    ADB *adb;
}
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *result;

@end
