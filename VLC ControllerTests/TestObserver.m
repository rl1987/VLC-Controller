//
//  TestObserver.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import "TestObserver.h"

@implementation TestObserver


- (void) stopObserving
{
    [super stopObserving];
    
    [[[UIApplication sharedApplication] delegate] applicationWillTerminate:
     [UIApplication sharedApplication]];
}

@end
