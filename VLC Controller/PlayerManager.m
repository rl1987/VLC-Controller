//
//  PlayerManager.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import "PlayerManager.h"

#import "PlayerStatusBuilder.h"
#import "RemoteFileBuilder.h"
#import "PlayerCommunicator.h"

@interface PlayerManager() <PlayerCommunicatorDelegate>

@property (nonatomic, strong) PlayerCommunicator *communicator;
@property (nonatomic, strong) PlayerStatusBuilder *playerStatusBuilder;
@property (nonatomic, strong) RemoteFileBuilder *remoteFileBuilder;

@property (nonatomic, strong) NSTimer *statusUpdateTimer;

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
        self.communicator.delegate = self;
        [self updatedCommunicatorSettings];
        
        self.playerStatusBuilder = [[PlayerStatusBuilder alloc] init];
        self.remoteFileBuilder = [[RemoteFileBuilder alloc] init];
        
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

- (void)playRemoteFile:(RemoteFile *)remoteFile {
    assert(remoteFile.uri);
    
    PlayerCommand *command = [[PlayerCommand alloc] init];
    command.commandType = PlayerCommandPlayInput;
    command.input = remoteFile.uri;
    
    [self.communicator sendCommand:command];
}

- (void)stop
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandStop]];
}

- (void)seekBy:(NSTimeInterval)offset
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandSeekRelative
                                                andValue:(double)offset]];
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

- (void)changeVolumeBy:(NSInteger)difference
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandSetVolumeRelative
                                                andValue:(double)difference]];
}

- (void)goToNextItem
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandNextEntry]];
}

- (void)goToPreviousItem
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandPreviousEntry]];
}

- (void)toggleShuffle
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandToggleShuffle]];
}

- (void)toggleRepeat
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandToggleRepeat]];
}

- (void)toggleFullscreen
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandFullscreen]];
}

- (void)startReceivingStatusUpdates
{
    if (!self.statusUpdateTimer.isValid)
    {
        self.statusUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:kStatusUpdateInterval
                                                                 repeats:YES
                                                                   block:^(NSTimer * _Nonnull timer) {
                                                                       [self.communicator retrieveCurrentStatus];
                                                                   }];
    }
}

- (void)stopReceivingStatusUpdates
{
    [self.statusUpdateTimer invalidate];
    
    self.statusUpdateTimer = nil;
}

- (void)listRemoteFilesInDirectory:(NSString *)directory withCompletionHandler:(FileListingCompletionHandler)completion
{
    [self.communicator sendFileListRequestForDirectory:directory
                                                   uri:nil
                                     completionHandler:^(NSDictionary *jsonDictionary, NSError *error) {
        // FIXME: code duplication
        if (completion) {
            if (error)
                completion(nil, error);
            else
                completion([self.remoteFileBuilder remoteFilesFromJSONDictionary:jsonDictionary], nil);
        }
    }];
}

- (void)listRemoteFilesAtURI:(NSString *)uri withCompletionHandler:(FileListingCompletionHandler)completion
{
    [self.communicator sendFileListRequestForDirectory:nil
                                                   uri:uri
                                     completionHandler:^(NSDictionary *jsonDictionary, NSError *error) {
        if (completion) {
            if (error)
                completion(nil, error);
            else
                completion([self.remoteFileBuilder remoteFilesFromJSONDictionary:jsonDictionary], nil);
        }
    }];
}

#pragma mark -
#pragma mark Player communicator delegate

- (void)playerCommunicator:(PlayerCommunicator *)communicator retrievedStatusJSONDictionary:(NSDictionary *)jsonDictionary
{
    self.status = [self.playerStatusBuilder statusFromJSONDictionary:jsonDictionary];
    
    if (self.delegate)
        [self.delegate playerManager:self receivedStatus:self.status];
}

- (void)playerCommunicator:(PlayerCommunicator *)communicator failedWithError:(NSError *)error
{
    DDLogError(@"%@",error);
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
