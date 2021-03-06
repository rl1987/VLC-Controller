//
//  PlayerCommunicator.h
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import <Foundation/Foundation.h>

#import "PlayerCommand.h"

@class PlayerCommunicator;

@protocol PlayerCommunicatorDelegate <NSObject>

- (void)playerCommunicator:(PlayerCommunicator *)communicator retrievedStatusJSONDictionary:(NSDictionary *)jsonDictionary;
- (void)playerCommunicator:(PlayerCommunicator *)communicator failedWithError:(NSError *)error;

@end

@interface PlayerCommunicator : NSObject

@property (nonatomic, strong) NSString *hostname;
@property (nonatomic, assign) uint16_t port;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, weak) id<PlayerCommunicatorDelegate> delegate;

- (void)retrieveCurrentStatus;
- (void)sendCommand:(PlayerCommand *)command;

- (void)sendFileListRequestForDirectory:(NSString *)directory
                                    uri:(NSString *)uri
                      completionHandler:(void (^)(NSDictionary *jsonDictionary, NSError *error))completion;

- (void)getPlaylistWithCompletionHandler:(void (^)(NSDictionary *jsonDictionary, NSError *error))completion;

@end
