//
//  ExtensionDelegate.m
//  VLC Controller-watchOS Extension
//
//  Created by rl1987 on 26/02/17.
//
//

#import "ExtensionDelegate.h"

#import <WatchConnectivity/WatchConnectivity.h>

#import "PlayerManager.h"
#import "WCSession+Settings.h"

@interface ExtensionDelegate() <WCSessionDelegate>

@end

@implementation ExtensionDelegate

- (void)requestSettingsUpdate
{
    [[WCSession defaultSession] sendSettingsToPeer];
}

- (void)applicationDidFinishLaunching {
    // Perform any final initialization of your application.
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[WCSession defaultSession] setDelegate:self];
        [[WCSession defaultSession] activateSession];
    });
}

- (void)applicationDidBecomeActive {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self requestSettingsUpdate];
}

- (void)applicationWillResignActive {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
}

- (void)handleBackgroundTasks:(NSSet<WKRefreshBackgroundTask *> *)backgroundTasks {
    // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
    for (WKRefreshBackgroundTask * task in backgroundTasks) {
        // Check the Class of each task to decide how to process it
        if ([task isKindOfClass:[WKApplicationRefreshBackgroundTask class]]) {
            // Be sure to complete the background task once you’re done.
            WKApplicationRefreshBackgroundTask *backgroundTask = (WKApplicationRefreshBackgroundTask*)task;
            [backgroundTask setTaskCompleted];
        } else if ([task isKindOfClass:[WKSnapshotRefreshBackgroundTask class]]) {
            // Snapshot tasks have a unique completion call, make sure to set your expiration date
            WKSnapshotRefreshBackgroundTask *snapshotTask = (WKSnapshotRefreshBackgroundTask*)task;
            [snapshotTask setTaskCompletedWithDefaultStateRestored:YES estimatedSnapshotExpiration:[NSDate distantFuture] userInfo:nil];
        } else if ([task isKindOfClass:[WKWatchConnectivityRefreshBackgroundTask class]]) {
            // Be sure to complete the background task once you’re done.
            WKWatchConnectivityRefreshBackgroundTask *backgroundTask = (WKWatchConnectivityRefreshBackgroundTask*)task;
            [backgroundTask setTaskCompleted];
        } else if ([task isKindOfClass:[WKURLSessionRefreshBackgroundTask class]]) {
            // Be sure to complete the background task once you’re done.
            WKURLSessionRefreshBackgroundTask *backgroundTask = (WKURLSessionRefreshBackgroundTask*)task;
            [backgroundTask setTaskCompleted];
        } else {
            // make sure to complete unhandled task types
            [task setTaskCompleted];
        }
    }
}

#pragma mark -
#pragma mark WCSessionDelegate

- (void)session:(WCSession *)session
activationDidCompleteWithState:(WCSessionActivationState)activationState
          error:(nullable NSError *)error
{
    if (error)
        DDLogError(@"%@",error);
    
    [self requestSettingsUpdate];
}

- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext
{
    DDLogInfo(@"ExtensionDelegate session:didReceiveApplicationContext:");
    DDLogInfo(@"%@",applicationContext);
    
    [[NSUserDefaults standardUserDefaults] setValuesForKeysWithDictionary:applicationContext];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
