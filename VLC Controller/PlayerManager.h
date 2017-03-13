//
//  PlayerManager.h
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import <Foundation/Foundation.h>

#define kUserDefaultsPortKey     @"user.defaults.port"
#define kUserDefaultsAddressKey  @"user.defaults.address"
#define kUserDefaultsPassword    @"user.defaults.password"

#define kStatusUpdateInterval (1.0)

#import "PlayerStatus.h"
#import "RemoteFile.h"

typedef void (^FileListingCompletionHandler)(NSArray<RemoteFile *> *files, NSError *error);

@class PlayerManager;

@protocol PlayerManagerDelegate <NSObject>

- (void)playerManager:(PlayerManager *)manager
       receivedStatus:(PlayerStatus *)status;

@end

@interface PlayerManager : NSObject

@property (nonatomic, assign) id<PlayerManagerDelegate> delegate;

@property (strong, atomic) PlayerStatus *status;

+ (instancetype)defaultManager;

- (void)pause;
- (void)play;
- (void)playRemoteFile:(RemoteFile *)remoteFile;
- (void)stop;
- (void)seekBy:(NSTimeInterval)offset;
- (void)seekTo:(NSTimeInterval)secondsFromStart;
- (void)changeVolumeTo:(NSUInteger)volume;
- (void)changeVolumeBy:(NSInteger)difference;
- (void)goToNextItem;
- (void)goToPreviousItem;
- (void)toggleShuffle;
- (void)toggleRepeat;
- (void)toggleFullscreen;

- (void)startReceivingStatusUpdates;
- (void)stopReceivingStatusUpdates;

- (void)listRemoteFilesInDirectory:(NSString *)directory withCompletionHandler:(FileListingCompletionHandler)completion;
- (void)listRemoteFilesAtURI:(NSString *)uri withCompletionHandler:(FileListingCompletionHandler)completion;

@end
