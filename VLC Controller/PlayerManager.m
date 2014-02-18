//
//  PlayerManager.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import "PlayerManager.h"

@implementation PlayerManager

- (void)setDelegate:(id<PlayerManagerDelegate>)delegate
{
    if (delegate && ![delegate conformsToProtocol:@protocol(PlayerManagerDelegate)]) {
        NSException *exception =
        [NSException exceptionWithName:NSInvalidArgumentException
                                reason:@"delegate object does not conform to PlayerManagerDelegate"
                              userInfo:nil];
        
        [exception raise];
        return;
    }
    
    _delegate = delegate;
}

#pragma mark -
#pragma mark Public API

+ (instancetype)defaultManager
{
    return nil;
}

- (void)pause
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandPause]];
}

- (void)play
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandPlay]];
}

- (void)stop
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandStop]];
}

- (void)seekTo:(NSTimeInterval)secondsFromStart
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandSeek
                                                andValue:(double)secondsFromStart]];
}

- (void)changeVolumeTo:(NSUInteger)volume
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandSetVolume
                                                andValue:(double)volume]];
}

- (void)goToNextItem
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandNextEntry]];
}

- (void)goToPreviousItem
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandPreviousEntry]];
}

- (void)startReceivingStatusUpdates
{
    
}

- (void)stopReceivingStatusUpdates
{
    
}

#pragma mark -
#pragma mark Private helper methods

- (PlayerCommand *)commandWithType:(PlayerCommandType)type
{
    PlayerCommand *command = [[PlayerCommand alloc] init];
    
    command.commandType = type;
    
    return command;
}

- (PlayerCommand *)commandWithType:(PlayerCommandType)type andValue:(double)value
{
    PlayerCommand *command = [self commandWithType:type];
    
    command.value = value;
    
    return command;
}

@end
