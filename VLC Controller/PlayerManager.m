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
#import "PlaylistBuilder.h"

@interface PlayerManager() <PlayerCommunicatorDelegate>

@property (nonatomic, strong) PlayerCommunicator *communicator;
@property (nonatomic, strong) PlayerStatusBuilder *playerStatusBuilder;
@property (nonatomic, strong) RemoteFileBuilder *remoteFileBuilder;
@property (nonatomic, strong) PlaylistBuilder *playlistBuilder;

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
        self.playlistBuilder = [[PlaylistBuilder alloc] init];
        
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

- (BOOL)isConfigured
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAddressKey] &&
    [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsPortKey] &&
    [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsPassword];
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

- (void)playPlaylistEntry:(PlaylistEntry *)playlistEntry
{
    PlayerCommand *command = [[PlayerCommand alloc] init];
    command.commandType = PlayerCommandPlay;
    command.value = @(playlistEntry.identifier);
    
    [self.communicator sendCommand:command];
}

- (void)enqueueRemoteFile:(RemoteFile *)remoteFile
{
    assert(remoteFile.uri);
    
    PlayerCommand *command = [[PlayerCommand alloc] init];
    command.commandType = PlayerCommandEnqueueInput;
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
    BOOL volumeDoubled = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsIsVolumeDouble];
    
    if (volumeDoubled)
        volume *= 2;
    
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

- (void)listRemoteFilesInDirectory:(NSString *)directory
                            xorURI:(NSString *)uri
             withCompletionHandler:(FileListingCompletionHandler)completion
{
    [self.communicator sendFileListRequestForDirectory:directory
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

- (void)listRemoteFilesInDirectory:(NSString *)directory withCompletionHandler:(FileListingCompletionHandler)completion
{
    [self listRemoteFilesInDirectory:directory
                              xorURI:nil
               withCompletionHandler:completion];
}

- (void)listRemoteFilesAtURI:(NSString *)uri withCompletionHandler:(FileListingCompletionHandler)completion
{
    [self listRemoteFilesInDirectory:nil
                              xorURI:uri
               withCompletionHandler:completion];
}

- (void)getPlaylistWithCompletionHandler:(PlaylistRequestCompletionHandler)completion
{
    [self.communicator getPlaylistWithCompletionHandler:^(NSDictionary *jsonDictionary, NSError *error) {
        if (completion) {
            if (error)
                completion(nil, error);
            else
                completion([self.playlistBuilder playlistFromJSONDictionary:jsonDictionary], nil);
        }
    }];
}

- (void)clearPlaylist
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandClearPlaylist]];
}

- (void)removePlaylistEntry:(PlaylistEntry *)playlistEntry
{
    PlayerCommand *command = [[PlayerCommand alloc] init];
    
    command.commandType = PlayerCommandRemovePlaylistEntry;
    command.value = @(playlistEntry.identifier);
    
    [self.communicator sendCommand:command];
}

- (void)increaseSubtitleDelay
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandSubtitleDelayIncrease]];
}

- (void)decreaseSubtitleDelay
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandSubtitleDelayDecrease]];
}

- (void)switchSubtitles
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandSwitchSubtitles]];
}

- (void)increaseAudioDelay
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandAudioDelayIncrease]];
}

- (void)decreaseAudioDelay
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandAudioDelayDecrease]];
}

- (void)switchAudioTrack
{
    [self.communicator sendCommand:[self commandWithType:PlayerCommandSwitchAudioTrack]];
}

#pragma mark -
#pragma mark Player communicator delegate

- (void)playerCommunicator:(PlayerCommunicator *)communicator retrievedStatusJSONDictionary:(NSDictionary *)jsonDictionary
{
    self.status = [self.playerStatusBuilder statusFromJSONDictionary:jsonDictionary];
    
    BOOL volumeDoubled = [[NSUserDefaults standardUserDefaults] boolForKey:kUserDefaultsIsVolumeDouble];

    if (volumeDoubled) {
        self.status.volume /= 2;
    }
    
    if (self.delegate)
        [self.delegate playerManager:self receivedStatus:self.status];
}

- (void)playerCommunicator:(PlayerCommunicator *)communicator failedWithError:(NSError *)error
{
    DDLogError(@"%@",error);
    
    if (self.delegate)
        [self.delegate playerManagerFailedWithError:error]; // TODO: use Facade pattern for errors as well
    
    [self stopReceivingStatusUpdates];
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
    
    command.value = @(value);
    
    return command;
}

- (void)updatedCommunicatorSettings
{
    self.communicator.hostname = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsAddressKey];
    self.communicator.password = [[NSUserDefaults standardUserDefaults] stringForKey:kUserDefaultsPassword];
    self.communicator.port = [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsPortKey];
}

@end
