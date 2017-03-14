//
//  Playlist.h
//  VLC Controller
//
//  Created by rl1987 on 14/03/17.
//
//

#import <Foundation/Foundation.h>

#import "PlaylistEntry.h"

@interface Playlist : NSObject

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *children;

@end
