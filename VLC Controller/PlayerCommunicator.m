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
            arguments = @{ @"command" : @"pl_play" };
            break;
            case PlayerCommandPause:
            arguments = @{ @"command" : @"pl_pause" };
            break;
            case PlayerCommandStop:
            arguments = @{ @"command" : @"pl_stop" };
            break;
            case PlayerCommandNextEntry:
            arguments = @{ @"command" : @"pl_next" };
            case PlayerCommandPreviousEntry:
            arguments = @{ @"command" : @"pl_previous" };
            break;
            case PlayerCommandFullscreen:
            arguments = @{ @"command" : @"fullscreen" };
            break;
            case PlayerCommandSetVolume:
            arguments = @{ @"command" : @"volume", @"val" : [NSString stringWithFormat:@"%.0f", command.value] };
            break;
            case PlayerCommandSeek:
            arguments = @{ @"command" : @"seek", @"val" : [NSString stringWithFormat:@"%.0f", command.value] };
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
                             NSLog(@"%@",responseObject);
                             
                             if (self.delegate)
                                [self.delegate playerCommunicator:self retrievedStatusJSONDictionary:responseObject];
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             NSLog(@"%@",error);
                             
                             if (self.delegate)
                                [self.delegate playerCommunicator:self failedWithError:error];
                         }];
}

@end
