//
//  AppDelegate.m
//  yesno
//
//  Created by Clay Reimann on 8/25/14.
//  Copyright (c) 2014 Sudo Studios. All rights reserved.
//

#import "AppDelegate.h"

#import "YNQuestionDataSource.h"

@interface AppDelegate ()
            

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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


/**
 *  When we recieve a push notification while we are running iOS < 7)
 *  We just want to push the data to the DataSource instance
 *
 *  @param application this application instance
 *  @param userInfo    the NSDictionary representation of the push JSON
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[YNQuestionDataSource source] receivedQuestion:userInfo withAction:nil];
}

/**
 *  When we recieve a push notificaiton while we are running (iOS 7+)
 *  We just want to push the data to the DataSource instance
 *
 *  @param application       the application instance
 *  @param userInfo          the NSDiciotnary representation of the push JSON
 *  @param completionHandler the completion handler (this will update our thumbnail if we recieve data)
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [[YNQuestionDataSource source] receivedQuestion:userInfo withAction:nil];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

/**
 *  This method gets called when the user responds to a push notification in the background
 *
 *  @param application       the application instance
 *  @param identifier        the identifier for the action
 *  @param userInfo          the NSDictionary reference of the push JSON
 *  @param completionHandler the completion handler (this will update our thumbnail if we recieve data)
 */
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    
    // go to question and mark as answered
    [[YNQuestionDataSource source] receivedQuestion:userInfo withAction:identifier];
    
    completionHandler();
}

/**
 *  When we register for push notificaitons this is the method that gets called if the user grants us permission
 *
 *  @param application the application instance
 *  @param deviceToken the token that we use to recieve data from the APN service
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  When we register for push notifications this is the method that gets called if something goes wrong
 *
 *  @param application the application instance
 *  @param error       what went wrong
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"error registering for remote notifications: %@", error);
}

@end
