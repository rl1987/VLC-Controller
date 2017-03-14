//
//  PlaylistBuilder.h
//  VLC Controller
//
//  Created by rl1987 on 14/03/17.
//
//

#import <Foundation/Foundation.h>

#import "Playlist.h"

@interface PlaylistBuilder : NSObject

- (Playlist *)playlistFromJSONDictionary:(NSDictionary *)jsonDictionary;

@end
