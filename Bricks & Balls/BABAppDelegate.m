//
//  BABAppDelegate.m
//  Bricks & Balls
//
//  Created by Merritt Tidwell on 8/6/14.
//  Copyright (c) 2014 Merritt Tidwell. All rights reserved.
//

#import "BABAppDelegate.h"
#import "BABGameBoardViewController.h"

@implementation BABAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    self.window.rootViewController = [[BABGameBoardViewController alloc]initWithNibName:nil bundle:nil];
    
 // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
