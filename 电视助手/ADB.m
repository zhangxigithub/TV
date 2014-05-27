//
//  ADB.m
//  电视助手
//
//  Created by zhangxi on 14-5-21.
//  Copyright (c) 2014年 zhangxi. All rights reserved.
//

#import "ADB.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <net/ethernet.h>
#include <errno.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <mach/machine.h>

@implementation ADB


- (id)init
{
    self = [super init];
    if (self) {
        isScanning = NO;
        adb = [[NSBundle mainBundle] pathForResource:@"adb" ofType:@""];
        sockets = [NSMutableArray array];

    }
    return self;
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    //NSLog(@"Found open port %d on %@", port, host);
    //[ips addObject:host];
    
    [self.delegate findSocket:sock];
    //[sock setDelegate:nil];
    [sock disconnect];
    //[sock setDelegate:self];
    


}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"%@ %@",@"socketDidDisconnect",sock.connectedHost);
    [sockets removeObject:sock];
    
    if(sockets.count == 0)
    {
        [self.delegate finish];
    }
}

-(void)stopScan
{
    isScanning = NO;
    [sockets makeObjectsPerformSelector:@selector(disconnect)];
}
-(NSArray *)scan;
{
    return [self scan:5555];
}

-(NSArray *)scan:(int)port;
{
    isScanning = YES;
    if(port >0)
    {
        //NSString *ip  = [[NSHost currentHost] addresses][1];
        NSString *ip = [self getIPAddress];
        
        NSArray  *ipArray = [ip componentsSeparatedByString:@"."];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
        for(int i =0;i<=30;i++)
        {
            GCDAsyncSocket *s = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
            
            [sockets addObject:s];
            NSError *error = nil;
            
            
            NSString *theIP = [NSString stringWithFormat:@"%@.%@.%@.%d",ipArray[0],ipArray[1],ipArray[2],i];
            NSLog(@"%@",theIP);
            [s connectToHost:theIP onPort:port withTimeout:1 error:&error];
                
        }

            GCDAsyncSocket *s = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
            
            [sockets addObject:s];
            NSError *error = nil;
            
            [s connectToHost:@"192.168.67.47" onPort:port withTimeout:1 error:&error];
        
        
    }
    return @[];
}
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    NSLog(@"address:%@",address);
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    NSLog(@"address:%@",address);
}


-(BOOL)connect:(NSString *)address
{
    return [self connect:address port:-1];
}
-(BOOL)connect:(NSString *)address port:(int)port
{
    if(port<0)
    {
        NSString *result = [self runShell:adb arguments:@[@"connect",address]];

        NSLog(@"%@",result);
        NSRange fail = [result rangeOfString:@"unable to connect"];
        NSRange success = [result rangeOfString:@"connected to"];
        
        if (fail.location != NSNotFound) {
            return NO;
        }
        if (success.location != NSNotFound) {
            return YES;
        }
        
        NSLog(@"%@",result);
    }else if(port >0)
    {
    }
    return NO;
}
-(BOOL)disconnect:(NSString *)address
{
    return [self disconnect:address port:-1];
}
-(BOOL)disconnect:(NSString *)address port:(int)port
{
    if(port<0)
    {
        NSString *result = [self runShell:adb arguments:@[@"disconnect",address]];
        NSLog(@"%@",result);
        
    }else if(port >0)
    {
    }
    return NO;
}
-(NSArray *)devices
{
    NSString *result = [self runShell:adb arguments:@[@"devices"]];
    NSLog(@"%@",result);
    return @[];
}

-(BOOL)install:(NSString *)path
{
    NSString *result = [self runShell:adb arguments:@[@"install",path]];
    NSLog(@"%@",result);
    
    
    MAIN(^{
        
        NSRange sucess = [result rangeOfString:@"Success"];
        
        
        [self.delegate finishInstall:(sucess.location != NSNotFound) info:result];
    });
    
    
    
    return YES;
}












-(NSString *)runShell:(NSString *)shell arguments:(NSArray *)arguments
{
    return [self shell:shell arguments:arguments];
}

-(NSString *)runShell:(NSString *)shell
{
    return [self shell:shell arguments:nil];
}

-(NSString *)shell:(NSString *)shell arguments:(NSArray *)arguments
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath:shell];
    
    
    //NSArray *arguments;
    //arguments = [NSArray arrayWithObjects: @"devices", nil];
    if (arguments != nil) {
        [task setArguments: arguments];
    }
    
    
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data
                                   encoding: NSUTF8StringEncoding];
    //    NSLog (@"got\n%@", string);
    return string;
}

@end
