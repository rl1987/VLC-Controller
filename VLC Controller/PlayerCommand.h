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
    PlayerCommandPause,
    PlayerCommandStop,
    PlayerCommandNextEntry,
    PlayerCommandPreviousEntry,
    PlayerCommandFullscreen,
    PlayerCommandSetVolume,
    PlayerCommandSeek
} PlayerCommandType;

@interface PlayerCommand : NSObject

@property (nonatomic, assign) PlayerCommandType commandType;
@property (nonatomic, assign) NSUInteger value;

@end
