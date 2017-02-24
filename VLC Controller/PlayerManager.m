//
//  PlayerManager.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import "PlayerManager.h"

#import "PlayerStatusBuilder.h"
#import "PlayerCommunicator.h"

@interface PlayerManager()

@property (nonatomic, strong) PlayerCommunicator *communicator;
@property (nonatomic, strong) PlayerStatusBuilder *playerStatusBuilder;

@end

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

static PlayerManager *_defaultManager;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.communicator = [[PlayerCommunicator alloc] init];
        [self updatedCommunicatorSettings];
        
        self.playerStatusBuilder = [[PlayerStatusBuilder alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                            [self updatedCommunicatorSettings];
                                                          }];
    }
    
    return self;
}

+ (instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManager = [[self alloc] init];
    });
    
    return _defaultManager;
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

- (void)updatedCommunicatorSettings
{
    self.communicator.hostname = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsAddressKey];
    self.communicator.password = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsPassword];
    self.communicator.port = [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsPortKey];
}

@end
