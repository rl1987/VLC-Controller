//
//  PlayerStatusBuilder.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import "PlayerStatusBuilder.h"

#import "PlayerStatus.h"

@implementation PlayerStatusBuilder

- (PlayerStatus *)statusFromJSONDictionary:(NSDictionary *)jsonDictionary
{
    PlayerStatus *status = [[PlayerStatus alloc] init];
    
    status.fullscreen = [jsonDictionary[@"fullscreen"] boolValue];
    status.duration = [jsonDictionary[@"length"] doubleValue];
    status.currentTime = [jsonDictionary[@"time"] doubleValue];
    status.playing = [jsonDictionary[@"state"] isEqualToString:@"playing"];
    status.filename = [jsonDictionary valueForKeyPath:@"information.meta.filename"];
    
    return status;
}

@end
