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
#import "DragDropView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,GCDAsyncSocketDelegate,ADBDelegate,DragDropViewDelegate>
{
    GCDAsyncSocket *asyncSocket;
    NSMutableArray *availableHosts;
    NSMutableArray *sockets;
    
    ADB *adb;
    NSAlert* alert;
}
@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *result;
@property (weak) IBOutlet DragDropView *fileView;

- (IBAction)scan:(id)sender;
- (IBAction)list:(id)sender;
- (IBAction)test:(id)sender;

@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSImageView *loadingView;

@end
