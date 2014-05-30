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
#import "TV.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,GCDAsyncSocketDelegate,ADBDelegate,DragDropViewDelegate>
{
    ADB *adb;
    
    TV *tv;
}

@property (assign) IBOutlet NSWindow *window;



@property (weak) IBOutlet DragDropView *fileView;
@property (weak) IBOutlet NSTextField *deviceLabel;
@property (weak) IBOutlet NSTextField *statusLabel;
@property (weak) IBOutlet NSImageView *loadingView;



- (IBAction)test:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)showHelp:(id)sender;



@end
