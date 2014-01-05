//
//  PlayerManager.h
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import <Foundation/Foundation.h>

#import "PlayerStatus.h"

@class PlayerManager;

@protocol PlayerManagerDelegate <NSObject>

- (void)playerManager:(PlayerManager *)manager
       receivedStatus:(PlayerStatus *)status;

@end

@interface PlayerManager : NSObject

@property (strong, atomic) PlayerStatus *status;

+ (instancetype)defaultManager;

- (void)pause;
- (void)play;
- (void)stop;
- (void)seekTo:(NSTimeInterval)secondsFromStart;
- (void)changeVolumeTo:(NSUInteger)volume;
- (void)goToNextItem;
- (void)goToPreviousItem;

- (void)startReceivingStatusUpdates;
- (void)stopReceivingStatusUpdates;

@end
