//
//  AppDelegate.m
//  电视助手
//
//  Created by zhangxi on 14-5-21.
//  Copyright (c) 2014年 zhangxi. All rights reserved.
//

#import "AppDelegate.h"
#import "GCDAsyncSocket.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    adb = [[ADB alloc] init];
    adb.delegate = self;
    self.fileView.delegate = self;
    //[adb connect:@" 192.168.65.223"];
    //[adb scan];
    //[adb scan:24];
//    [adb scan:5554
    //NSArray *addresses = [[NSHost currentHost] addresses];
    //NSLog(@"%@",[[NSHost currentHost] address]);
    //[adb scan];
    //[adb connect:@"10.0.1.4"];
    
    //self.result.stringValue = [NSString stringWithFormat:@"command path :\n%@\n\n",path];
    
    //self.result.stringValue = [self.result.stringValue stringByAppendingString:[self shell:path arguments:@[@"devices"]]];
    
    
    //[self runShell:path arguments:@[@"devices"]];
    //[self runShell:path arguments:@[@"conne",]];
    //[self runShell:path arguments:@[@"install",@"/Users/zhangxi/Downloads/baidu_16784655.apk"]];
    //[self runShell:@"/sbin/pin" arguments:@[@"www.zhangxi.me"]];
    
    
    //[self startScan];
}

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

-(void)log:(NSString *)result
{
    self.result.stringValue = [self.result.stringValue stringByAppendingString:result];
    self.result.stringValue = [self.result.stringValue stringByAppendingString:@"\n"];
}
//
//
//
//
//- (IBAction)startScan
//{
//    NSArray *ipAddressList = @[@"192.168.1.1",@"192.168.1.2",@"192.168.1.3",@"192.168.1.4",@"192.168.1.5",@"192.168.1.6",@"192.168.1.7"];
//    
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    
//    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
//    NSError *error = nil;
//    
//    for (int i = 1; i < ipAddressList.count; i++) {
//        NSString *scanHostIP = ipAddressList[i];
//        NSLog(@"%d",i);
//        [asyncSocket connectToHost:scanHostIP onPort:21 withTimeout:2 error:&error];
//    }
//}
//
//- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
//{
//    NSLog(@"Found open port %d on %@", port, host);
//    [availableHosts addObject:host];
//    [sock setDelegate:nil];
//    [sock disconnect];
//    [sock setDelegate:self];
//    
//}
//
//- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
//{
//    NSLog(@"%@ Disconnected: %@",sock.connectedAddress, err ? err : @"");
//}
//
//
//






-(void)dragDropViewFileList:(NSArray *)fileList{
    //如果数组不存在或为空直接返回不做处理（这种方法应该被广泛的使用，在进行数据处理前应该现判断是否为空。）
    if(!fileList || [fileList count] <= 0)return;
    //在这里我们将遍历这个数字，输出所有的链接，在后台你将会看到所有接受到的文件地址
    
    NSString *path = [fileList firstObject];
    if(path)
    {
        BOOL sucess =  [adb install:path];
        [self log:[NSString stringWithFormat:@"%@",sucess?@"安装成功":@"安装失败"]];
    }
    
    
    
    for (int n = 0 ; n < [fileList count] ; n++) {
        NSLog(@">>> %@",[fileList objectAtIndex:n]);
        
        
        
    }
    
    
    //NSString *path = [fileList firstObject];
    
    
}




- (IBAction)scan:(id)sender {
    [self log:@"开始扫描..."];
    [adb performSelectorInBackground:@selector(scan) withObject:nil];
}

- (IBAction)list:(id)sender {
    [adb devices];
}

- (IBAction)test:(id)sender {
    [adb install:@"/Users/zhangxi/Downloads/com.ting.mp3.qianqian.android_170944.apk"];
}
@end
