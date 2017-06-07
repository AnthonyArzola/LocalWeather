//
//  AppDelegate.m
//  LocalWeather
//
//  Created by Anthony Arzola on 1/2/17.
//  Copyright © 2017 Anthony Arzola. All rights reserved.
//

#import "AppDelegate.h"
#import "LWCityTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
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

#pragma mark - App Shortcut Items

- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem
  completionHandler:(nonnull void (^)(BOOL))completionHandler
{
    [self loadShortcutItem:shortcutItem];
}

#pragma mark - Private Methods

-(void)loadShortcutItem:(UIApplicationShortcutItem *)shortcutItem
{
    if ([shortcutItem.type isEqualToString:@"current-weather"])
    {
        
    }
    else if([shortcutItem.type isEqualToString:@"show-map"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"cityTableViewController"];
        ((LWCityTableViewController *)viewController).loadMap = YES;
        
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        [navigationController pushViewController:viewController animated:YES];
    }
}

@end
