#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application 
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

// http://stackoverflow.com/a/19386835

#ifdef DEBUG
+ (void)initialize {
    [[NSUserDefaults standardUserDefaults] setValue:@"XCTestLog,GcovTestObserver"
                                             forKey:@"XCTestObserverClass"];
}
#endif

- (void)applicationWillTerminate:(UIApplication *)application
{
#ifdef DEBUG
    extern void __gcov_flush(void);
    __gcov_flush();
#endif
}

@end
