//
//  PlayerCommunicator.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import "PlayerCommunicator.h"

#import <AFNetworking/AFNetworking.h>

@interface PlayerCommunicator ()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@end

@implementation PlayerCommunicator

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        self.httpSessionManager.responseSerializer.acceptableContentTypes =
        [self.httpSessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    }
    
    return self;
}

- (void)retrieveCurrentStatus
{
    [self sendStatusRequestWithArguments:nil];
}

- (void)sendCommand:(PlayerCommand *)command
{
    NSDictionary *arguments;
    
    switch (command.commandType) {
            case PlayerCommandPlay:
            arguments = command.value ?
            @{ @"command" : @"pl_play", @"id" : command.value } :
            @{ @"command" : @"pl_play" };
            break;
            case PlayerCommandPlayInput:
            arguments = @{ @"command" : @"in_play",
                           @"input" : command.input };
            break;
            case PlayerCommandEnqueueInput:
            arguments = @{ @"command" : @"in_enqueue",
                           @"input" : command.input };
            break;
            case PlayerCommandPause:
            arguments = @{ @"command" : @"pl_pause" };
            break;
            case PlayerCommandStop:
            arguments = @{ @"command" : @"pl_stop" };
            break;
            case PlayerCommandNextEntry:
            arguments = @{ @"command" : @"pl_next" };
            break;
            case PlayerCommandPreviousEntry:
            arguments = @{ @"command" : @"pl_previous" };
            break;
            case PlayerCommandFullscreen:
            arguments = @{ @"command" : @"fullscreen" };
            break;
            case PlayerCommandSetVolume:
            arguments = @{ @"command" : @"volume", @"val" : [NSString stringWithFormat:@"%.0f", [command.value doubleValue]] };
            break;
            case PlayerCommandSetVolumeRelative:
            arguments = @{ @"command" : @"volume", @"val" : [NSString stringWithFormat:@"%s%.0f",
                                                             [command.value doubleValue] > 0.0 ? "+" : "-" ,fabs([command.value doubleValue])] };
            break;
            case PlayerCommandSeek:
            arguments = @{ @"command" : @"seek", @"val" : [NSString stringWithFormat:@"%.0f", [command.value doubleValue]] };
            break;
            case PlayerCommandSeekRelative:
            arguments = @{ @"command" : @"seek", @"val" : [NSString stringWithFormat:@"%s%.0fS",
                                                           [command.value doubleValue] > 0.0 ? "+" : "-" ,fabs([command.value doubleValue])] };
            break;
            case PlayerCommandToggleShuffle:
            arguments = @{ @"command" : @"pl_random" };
            break;
            case PlayerCommandToggleRepeat:
            arguments = @{ @"command" : @"pl_repeat" };
            break;
            case PlayerCommandClearPlaylist:
            arguments = @{ @"command" : @"pl_empty" };
            break;
            case PlayerCommandRemovePlaylistEntry:
            arguments = @{ @"command" : @"pl_delete", @"id" : command.value };
            break;
            case PlayerCommandSubtitleDelayIncrease:
            arguments = @{ @"command" : @"key", @"val" : @"subdelay-up" };
            break;
            case PlayerCommandSubtitleDelayDecrease:
            arguments = @{ @"command" : @"key", @"val" : @"subdelay-down" };
            break;
            case PlayerCommandSwitchSubtitles:
            arguments = @{ @"command" : @"key", @"val" : @"subtitle-track" };
            break;
            case PlayerCommandAudioDelayIncrease:
            arguments = @{ @"command" : @"key", @"val" : @"audiodelay-up" };
            break;
            case PlayerCommandAudioDelayDecrease:
            arguments = @{ @"command" : @"key", @"val" : @"audiodelay-down" };
            break;
            case PlayerCommandSwitchAudioTrack:
            arguments = @{ @"command" : @"key", @"val" : @"audio-track" };
            break;
        default:
            break;
    }
    
    [self sendStatusRequestWithArguments:arguments];
}

- (void)sendStatusRequestWithArguments:(NSDictionary *)arguments
{
    if (!self.hostname) {
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%d/requests/status.json",self.hostname, self.port];
    
    [self.httpSessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"" password:self.password];
    
    [self.httpSessionManager GET:urlString
                      parameters:arguments
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             DDLogDebug(@"%@",responseObject);
                             
                             if (self.delegate)
                                [self.delegate playerCommunicator:self retrievedStatusJSONDictionary:responseObject];
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             DDLogError(@"%@",error);
                             
                             if (self.delegate)
                                [self.delegate playerCommunicator:self failedWithError:error];
                         }];
}

- (void)sendFileListRequestForDirectory:(NSString *)directory
                                    uri:(NSString *)uri
                      completionHandler:(void (^)(NSDictionary *jsonDictionary, NSError *error))completion
{
    if (!self.hostname) {
        return;
    }
    
    NSMutableDictionary *arguments = [[NSMutableDictionary alloc] init];
    
    if (directory)
        arguments[@"dir"] = directory;
    
    if (uri)
        arguments[@"uri"] = uri;
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%d/requests/browse.json", self.hostname, self.port];
    
    [self.httpSessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"" password:self.password];
    
    [self.httpSessionManager GET:urlString
                      parameters:arguments
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             DDLogDebug(@"%@",responseObject);
                             
                             if (completion)
                                 completion(responseObject, nil);
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             DDLogError(@"%@",error);
                             
                             if (completion)
                                 completion(nil, error);
                         }];
    
}

- (void)getPlaylistWithCompletionHandler:(void (^)(NSDictionary *jsonDictionary, NSError *error))completion
{
    if (!self.hostname)
        return;
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@:%d/requests/playlist.json", self.hostname, self.port];
    
    [self.httpSessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"" password:self.password];
    
    [self.httpSessionManager GET:urlString
                      parameters:nil
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             DDLogDebug(@"%@",responseObject);
                             
                             if (completion)
                                 completion(responseObject, nil);
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             DDLogError(@"%@",error);
                             
                             if (completion)
                                 completion(nil, error);
                         }];
}

@end
