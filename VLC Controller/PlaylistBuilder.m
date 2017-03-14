//
//  PlaylistBuilder.m
//  VLC Controller
//
//  Created by rl1987 on 14/03/17.
//
//

#import "PlaylistBuilder.h"

@implementation PlaylistBuilder

- (Playlist *)playlistFromJSONDictionary:(NSDictionary *)jsonDictionary
{
    return [self playlistFromNode:jsonDictionary];
}

- (Playlist *)playlistFromNode:(NSDictionary *)nodeDictionary
{
    Playlist *playlist = [[Playlist alloc] init];
    
    playlist.identifier = [nodeDictionary[@"id"] intValue];
    playlist.name = nodeDictionary[@"name"];
    
    NSMutableArray *children = [[NSMutableArray alloc] init];
    
    for (NSDictionary *c in nodeDictionary[@"children"]) {
        if ([c[@"type"] isEqualToString:@"node"])
            [children addObject:[self playlistFromNode:c]];
        else if ([c[@"type"] isEqualToString:@"leaf"])
            [children addObject:[self playlistEntryFromLeaf:c]];
    }
    
    playlist.children = [children copy];
    
    return playlist;
}

- (PlaylistEntry *)playlistEntryFromLeaf:(NSDictionary *)leafDictionary
{
    PlaylistEntry *entry = [[PlaylistEntry alloc] init];
    
    entry.name = leafDictionary[@"name"];
    entry.identifier = [leafDictionary[@"id"] intValue];
    entry.duration = [leafDictionary[@"duration"] doubleValue];
    entry.uri = leafDictionary[@"uri"];
    entry.isCurrent = [leafDictionary[@"current"] isEqualToString:@"current"];
    
    return entry;
}

@end
