//
//  AppDelegate.m
//  Hacker School
//
//  Created by Alan Wang on 1/20/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NXOAuth2.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blueColor];
    
    // The ClientID and secret are generated by the Hacker School website
    [[NXOAuth2AccountStore sharedStore] setClientID:@"6a0ef0f986f96b491ae88d9eed40d8b32b08525ac2b603ba931b368b0f881fbc"
                                             secret:@"25a6deb0dcf00a01c4e8e5f54de0635765fd53a89ca55975c76fc0fa9fdab749"
                                   authorizationURL:[NSURL URLWithString:@"https://www.hackerschool.com/oauth/authorize"]
                                           tokenURL:[NSURL URLWithString:@"https://www.hackerschool.com/oauth/token"]
                                        redirectURL:[NSURL URLWithString:@"HackerSchoolApp://oauth"]
                                     forAccountType:@"Hacker School"];
    
    ViewController *vc = [[ViewController alloc]init];
    
    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"Redirected from: %@", sourceApplication);
    NSLog(@"URL: %@", url);
    
    BOOL didSucceed = [[NXOAuth2AccountStore sharedStore]handleRedirectURL:url];
    
    NSLog(@"Did succeed: %i", didSucceed);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
