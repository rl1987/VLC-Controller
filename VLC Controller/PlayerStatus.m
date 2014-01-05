//
//  PlayerStatus.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import "PlayerStatus.h"

@implementation PlayerStatus

- (void)setFilename:(NSString *)filename
{
    if (!filename)
        _filename = nil;
    
    if ([filename isKindOfClass:[NSString class]])
        _filename = filename;
    
}

- (void)setCurrentTime:(NSTimeInterval)time
{
    if (time > _duration) {
        NSException *exception =
        [[NSException alloc] initWithName:NSInternalInconsistencyException
                                   reason:@"currentTime MUST NOT be larger than duration"
                                 userInfo:nil];
        
        [exception raise];
    }
    
    time = _currentTime;
}

@end
