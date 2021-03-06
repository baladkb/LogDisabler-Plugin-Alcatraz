//
//  LogController.m
//  LogDisabler
//
//  Created by Michalis Mavris on 26/02/16.
//  Copyright © 2016 Miksoft. All rights reserved.
//

#import "LogController.h"

@implementation LogController
{
    
    NSString *projectPath;
}
+(LogController *) sharedInstance
{
    static LogController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        
    });
    return instance;
}

- (id)init {
    self = [super init];
    if(self != nil) {
        
    }
    return self;
}

- (IDEWorkspaceDocument*)currentWorkspaceDocument
{
    NSWindowController* currentWindowController =
    [[NSApp mainWindow] windowController];
    id document = [currentWindowController document];
    if (currentWindowController &&
        [document isKindOfClass:NSClassFromString(@"IDEWorkspaceDocument")]) {
        return (IDEWorkspaceDocument*)document;
    }
    return nil;
}

-(void)disableLogs{
    
    //Getting the project directory
    NSString* filePath = [[self currentWorkspaceDocument].workspace.representingFilePath.fileURL path];
    projectPath = [filePath stringByDeletingLastPathComponent];
    
    if (projectPath==nil) {
        return;
    }
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/find";
    task.arguments = @[ projectPath, @"-not" ,@"-path" ,@"*/\\.*",@"-type", @"f", @"-name", @"*.m",@"-exec", @"sed", @"-i", @"", @"s!NSLog(!//LDLog(!", @"{}", @"+" ];
    [task launch];
    [task waitUntilExit];
    
    NSTask *task2 = [[NSTask alloc] init];
    task2.launchPath = @"/usr/bin/find";
    task2.arguments = @[ projectPath, @"-not" ,@"-path" ,@"*/\\.*",@"-type", @"f", @"-name", @"*.swift",@"-exec", @"sed", @"-i", @"", @"s!Swift\\.print(!//DLSwift\\.pDLrint(!", @"{}", @"+" ];
    [task2 launch];
    [task2 waitUntilExit];

    NSTask *task3 = [[NSTask alloc] init];
    task3.launchPath = @"/usr/bin/find";
    task3.arguments = @[ projectPath, @"-not" ,@"-path" ,@"*/\\.*",@"-type", @"f", @"-name", @"*.swift",@"-exec", @"sed", @"-i", @"", @"s!print(!//DLrint(!", @"{}", @"+" ];
    [task3 launch];
    [task3 waitUntilExit];
    
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"You have successfully disabled all comments"];
    [alert runModal];
    
}

-(void)enableLogs{
    
    //Getting the project directory
    NSString* filePath = [[self currentWorkspaceDocument].workspace.representingFilePath.fileURL path];
    projectPath = [filePath stringByDeletingLastPathComponent];
    
    if (projectPath==nil) {
        return;
    }
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/find";
    task.arguments = @[ projectPath,@"-not" ,@"-path" ,@"*/\\.*", @"-type", @"f", @"-name", @"*.m", @"-exec", @"sed", @"-i", @"", @"s!//LDLog(!NSLog(!", @"{}", @"+" ];
    [task launch];
    [task waitUntilExit];
    
    NSTask *task2 = [[NSTask alloc] init];
    task2.launchPath = @"/usr/bin/find";
    task2.arguments = @[ projectPath,@"-not" ,@"-path" ,@"*/\\.*", @"-type", @"f", @"-name", @"*.swift", @"-exec", @"sed", @"-i", @"", @"s!//DLSwift.pDLrint(!Swift.print(!", @"{}", @"+" ];
    [task2 launch];
    [task2 waitUntilExit];
    
    
    NSTask *task3 = [[NSTask alloc] init];
    task3.launchPath = @"/usr/bin/find";
    task3.arguments = @[ projectPath,@"-not" ,@"-path" ,@"*/\\.*", @"-type", @"f", @"-name", @"*.swift", @"-exec", @"sed", @"-i", @"", @"s!//DLrint(!print(!", @"{}", @"+" ];
    [task3 launch];
    [task3 waitUntilExit];
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"You have successfully enabled all comments"];
    [alert runModal];
    
}


@end
