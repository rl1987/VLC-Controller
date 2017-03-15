//
//  PlayerCommand.h
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 26/01/14.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    PlayerCommandPlay,
    PlayerCommandPlayInput,
    PlayerCommandEnqueueInput,
    PlayerCommandPause,
    PlayerCommandStop,
    PlayerCommandNextEntry,
    PlayerCommandPreviousEntry,
    PlayerCommandFullscreen,
    PlayerCommandSetVolume,
    PlayerCommandSetVolumeRelative,
    PlayerCommandSeek,
    PlayerCommandSeekRelative,
    PlayerCommandToggleShuffle,
    PlayerCommandToggleRepeat
} PlayerCommandType;

@interface PlayerCommand : NSObject

@property (nonatomic, assign) PlayerCommandType commandType;
@property (nonatomic, strong) NSNumber *value;
@property (nonatomic, strong) NSString *input;

@end
