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
    
    //[adb connect:@" 192.168.65.223"];
    [adb scanWithResult:^(NSArray *result) {
        NSLog(@"%@",result);
    }];
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











@end
