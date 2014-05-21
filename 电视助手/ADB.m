//
//  ADB.m
//  电视助手
//
//  Created by zhangxi on 14-5-21.
//  Copyright (c) 2014年 zhangxi. All rights reserved.
//

#import "ADB.h"

@implementation ADB


- (id)init
{
    self = [super init];
    if (self) {
        adb = [[NSBundle mainBundle] pathForResource:@"adb" ofType:@""];
        sockets = [NSMutableArray array];
        ips     = [NSMutableArray array];
    }
    return self;
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Found open port %d on %@", port, host);
    [ips addObject:host];
    //[sock setDelegate:nil];
    [sock disconnect];
    //[sock setDelegate:self];
    
    
    if([[[host componentsSeparatedByString:@"."] objectAtIndex:3] isEqualToString:@"30"])
    {
        scanResult(ips);
    }

}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    
    if([[[sock.connectedHost componentsSeparatedByString:@"."] objectAtIndex:3] isEqualToString:@"30"])
    {
        scanResult(ips);
    }
    NSLog(@"Disconnected  \n\n  %@\n %d\n  %@\n %d\n",sock.connectedHost,sock.connectedPort,sock.localHost,sock.localPort);
}

-(NSArray *)scanWithResult:(void(^)(NSArray *result))result;
{
    scanResult = result;
    return [self scan:5555];
}

-(NSArray *)scan:(int)port;
{
    if(port >0)
    {
        NSString *ip  = [[NSHost currentHost] addresses][1];
        NSArray  *ipArray = [ip componentsSeparatedByString:@"."];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
        for(int i =0;i<=30;i++)
        {
            GCDAsyncSocket *s = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
            
            [sockets addObject:s];
            NSError *error = nil;
            
            
            NSString *theIP = [NSString stringWithFormat:@"%@.%@.%@.%d",ipArray[0],ipArray[1],ipArray[2],i];
            //NSLog(@"%@",theIP);
            [s connectToHost:theIP onPort:port withTimeout:1 error:&error];
                
        }
        
    }
    return @[];
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
    return @[];
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
