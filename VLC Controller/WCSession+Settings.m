//
//  WCSession+Settings.m
//  VLC Controller
//
//  Created by rl1987 on 27/02/17.
//
//

#import "WCSession+Settings.h"

#import "PlayerManager.h"

@implementation WCSession (Settings)

- (void)sendSettingsToPeer
{
    if ([self activationState] != WCSessionActivationStateActivated)
        return;
    
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
    
    [self updateApplicationContext:currentSettings error:NULL];
}

@end
