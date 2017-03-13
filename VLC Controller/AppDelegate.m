#import "AppDelegate.h"

#import <WatchConnectivity/WatchConnectivity.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

#import "PlayerManager.h"
#import "WCSession+Settings.h"

@interface AppDelegate() <WCSessionDelegate>

@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [[WCSession defaultSession] setDelegate:self];
        
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[WCSession defaultSession] activateSession];
}

- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error
{
    [[WCSession defaultSession] sendSettingsToPeer];
}

- (void)sessionDidBecomeInactive:(WCSession *)session
{
    
}

- (void)sessionDidDeactivate:(WCSession *)session
{
    [[WCSession defaultSession] activateSession];
}

- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *,id> *)applicationContext
{
    DDLogInfo(@"AppDelegate session:didReceiveApplicationContext:");
    DDLogInfo(@"%@",applicationContext);
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *currentSettings = [[NSMutableDictionary alloc] init];
    
    currentSettings[@"UUID"] = [[NSUUID UUID] UUIDString];
    
    if ([ud stringForKey:kUserDefaultsAddressKey]) {
        [currentSettings setObject:[ud stringForKey:kUserDefaultsAddressKey]
                            forKey:kUserDefaultsAddressKey];
    }
    
    if ([ud integerForKey:kUserDefaultsPortKey]) {
        [currentSettings setObject:@([ud integerForKey:kUserDefaultsPortKey])
                            forKey:kUserDefaultsPortKey];
    }
    
    if ([ud stringForKey:kUserDefaultsPassword]) {
        [currentSettings setObject:[ud stringForKey:kUserDefaultsPassword]
                            forKey:kUserDefaultsPassword];
    }
    
    if (![applicationContext isEqualToDictionary:currentSettings])
        [[WCSession defaultSession] updateApplicationContext:currentSettings error:NULL];
}

@end
