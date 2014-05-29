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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    adb = [[ADB alloc] init];
    adb.delegate = self;
    self.fileView.delegate = self;
    
    self.loadingView.alphaValue = 1;
}

//adb delegate
-(void)findSocket:(GCDAsyncSocket *)socket
{
    NSLog(@"find socket : %@",socket);
    [self log:[NSString stringWithFormat:@"连接设备 : %@",socket.connectedHost]];
    
    BOOL connect = [adb connect:socket.connectedHost];
    
    [adb stopScan];
    [self log:[NSString stringWithFormat:@"%@",connect?@"连接成功":@"连接失败"]];
}

-(void)finish
{
    [self log:@"查找完成"];
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
    
    alert = [NSAlert alertWithMessageText:message defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"" ];


    [alert beginSheetModalForWindow:[self window]
                      modalDelegate:nil
                     didEndSelector:nil
                        contextInfo:nil];
    

}
-(void)log:(NSString *)result
{
    self.result.stringValue = [self.result.stringValue stringByAppendingString:result];
    self.result.stringValue = [self.result.stringValue stringByAppendingString:@"\n"];
}

- (IBAction)scan:(id)sender {
    [self log:@"开始扫描..."];
    [adb performSelectorInBackground:@selector(scan) withObject:nil];
}

- (IBAction)list:(id)sender {
    [adb devices];
}

- (IBAction)test:(id)sender {
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"frameRotation" ];
    rotation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotation.toValue = [NSNumber numberWithFloat:360];
    rotation.repeatCount = 10;
    rotation.duration = 1;
    
    //[self.loadingView setWantsLayer:YES];
    //self.loadingView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    
    [[self.loadingView animator] setAnimations:@{@"frameRotation":rotation}];
     [[self.loadingView animator] setFrameRotation:360];
    //self.loadingView.layer.anchorPoint = CGPointMake(1,1);

}
@end
