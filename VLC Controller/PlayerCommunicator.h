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

- (void)retrievedStatusJSON:(NSString *)json;
- (void)requestFailedWithError:(NSError *)error;

@end

@interface PlayerCommunicator : NSObject

- (void)retrieveCurrentStatus;
- (void)sendCommand:(PlayerCommand *)command;

@end
