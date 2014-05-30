//
//  AppDelegate.m
//  电视助手
//
//  Created by zhangxi on 14-5-21.
//  Copyright (c) 2014年 zhangxi. All rights reserved.
//

#import "AppDelegate.h"
#import "GCDAsyncSocket.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate


-(IBAction)showHelp:(id)sender
{
    [self alert:@"help"];
}
-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    if(flag == NO)
    {
        [self.window makeKeyAndOrderFront:nil];
    }
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    adb = [[ADB alloc] init];
    adb.delegate = self;
    self.fileView.delegate = self;
    
//    self.loadingView.alphaValue = 0;
    [self stopAnimation];
    [self startScan];
}

//adb delegate
-(void)findSocket:(GCDAsyncSocket *)socket
{
    NSLog(@"find socket : %@",socket);

    tv = [[TV alloc] init];
    tv.host = socket.connectedHost;
    
    //[self log:[NSString stringWithFormat:@"连接设备 : %@",socket.connectedHost]];
    
    BOOL connect =  [adb connect:socket.connectedHost];
    
//    [self alert:@"连接"];
    
    [adb stopScan];
    [self alert:[NSString stringWithFormat:@"%@",connect?@"连接成功":@"连接失败"]];
}

-(void)finish
{
    //[self log:@"查找完成"];
    if(tv == nil)
    {
        [self alert:@"> _ <"];
        self.deviceLabel.stringValue = @"未找到设备";
    }
}

-(void)finishInstall:(BOOL)sucess info:(NSString *)info
{
    [self alert:info];
}




-(void)dragDropViewFileList:(NSArray *)fileList{

    if(!fileList || [fileList count] <= 0)
        return;

    
    NSString *path = [fileList firstObject];
    if(path)
    {
        [self alert:@"安装中..."];
        [adb performSelectorInBackground:@selector(install:) withObject:path];
    }
}

-(void)alert:(NSString *)message
{

    //[[alert window] close];
    self.statusLabel.stringValue = message;
    
//    alert = [NSAlert alertWithMessageText:message defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"" ];
//
//
//    [alert beginSheetModalForWindow:[self window]
//                      modalDelegate:nil
//                     didEndSelector:nil
//                        contextInfo:nil];
    

}
//-(void)log:(NSString *)result
//{
//    self.result.stringValue = [self.result.stringValue stringByAppendingString:result];
//    self.result.stringValue = [self.result.stringValue stringByAppendingString:@"\n"];
//}

- (IBAction)scan:(id)sender {
    //[self log:@"开始扫描..."];
    [adb performSelectorInBackground:@selector(scan) withObject:nil];
}

- (IBAction)list:(id)sender {
    [adb devices];
}


- (IBAction)test:(id)sender {
    [self alert:@"上传中..."];
    [self startAnimation];
}
- (IBAction)stop:(id)sender {
    [self alert:@"上传成功"];
    [self stopAnimation];
}


-(void)startScan
{
    [self alert:@"开始扫描..."];
    [adb performSelectorInBackground:@selector(scan) withObject:nil];
}

-(void)startAnimation
{
    self.loadingView.alphaValue = 1;
    [self.loadingView setWantsLayer:YES];
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z" ];
    
    rotation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotation.toValue = [NSNumber numberWithFloat:-M_PI*2];
    rotation.repeatCount = 999;
    rotation.duration = 1.5;
    
    [self.loadingView.layer addAnimation:rotation forKey:@"transform.rotation.z"];
}
-(void)stopAnimation
{
    [self.loadingView.layer removeAllAnimations];
    self.loadingView.alphaValue = 0;
}


@end
