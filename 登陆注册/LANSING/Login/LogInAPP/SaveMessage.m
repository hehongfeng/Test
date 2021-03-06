//
//  SaveMessage.m
//  LANSING
//
//  Created by nsstring on 15/6/17.
//  Copyright (c) 2015年 DengLu. All rights reserved.
//

#import "SaveMessage.h"

@implementation SaveMessage
+ (void)saveUserMessagePHP:(NSDictionary *)userMsg
{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    
    [userData setObject:userMsg
                                              forKey:usernameMessagePHP];
//    [[NSUserDefaults standardUserDefaults] setValue:archiveDic forKey:usernameMessage];
    [userData synchronize];
    
    NSLog(@"_----usernameMessagePHP---%@-----",[[NSUserDefaults standardUserDefaults]objectForKey:usernameMessagePHP]);
}

+ (void)saveUserMessageJava:(NSDictionary *)userMsg
{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    
    [userData setObject:userMsg
                 forKey:usernameMessageJava];
    //    [[NSUserDefaults standardUserDefaults] setValue:archiveDic forKey:usernameMessage];
    [userData synchronize];
    
    NSLog(@"_----usernameMessageJava---%@-----",[[NSUserDefaults standardUserDefaults]objectForKey:usernameMessageJava]);
}

+(void)clearPHP
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:usernameMessagePHP];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)clearJava
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:usernameMessageJava];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
