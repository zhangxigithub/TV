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
    }
    return self;
}


-(NSArray *)scan
{
    return [self scan:-1];
}

-(NSArray *)scan:(int)port;
{
    if(port<0)
    {
    }else if(port >0)
    {
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
