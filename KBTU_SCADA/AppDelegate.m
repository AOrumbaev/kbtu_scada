//
//  AppDelegate.m
//  KBTU_SCADA
//
//  Created by Altynbek Orumbayev on 16/11/2016.
//  Copyright © 2016 A_Orumbayev. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"

#import "TBWebViewController.h"
#import "AOTabBarController.h"
#import "AOCSVViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = [AOTabBarController new];
    [self.window.rootViewController setTitle:@"KBTU SCADA"];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self.window setTintColor:UIColorFromRGB(0x228291)];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if (url != nil && [url isFileURL]) {
        
        //  xdxf file type handling
        
        if ([[url pathExtension] isEqualToString:@"csv"]) {
            
            NSLog(@"URL:%@", [url absoluteString]);
            
            NSString *filePath = [url absoluteString];
            //            if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                     bundle: nil];
            
            AOCSVViewController *csvVC = (AOCSVViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"csvVC"];
         //   csvVC.pathToCSV = filePath;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                AOTabBarController *tabBar = (AOTabBarController *)self.window.rootViewController;
                [tabBar.addSensorVC pushViewController:csvVC animated:YES];
            });
        }
        
    }
    
    return YES;
}



@end
