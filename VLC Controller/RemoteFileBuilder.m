//
//  RemoteFileBuilder.m
//  VLC Controller
//
//  Created by rl1987 on 13/03/17.
//
//

#import "RemoteFileBuilder.h"

@implementation RemoteFileBuilder

- (NSArray<RemoteFile *> *)remoteFilesFromJSONDictionary:(NSDictionary *)jsonDictionary
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    NSArray *innerArray = jsonDictionary[@"element"];
    
    for (NSDictionary *f in innerArray) {
        RemoteFile *rf = [[RemoteFile alloc] init];
        
        rf.isDirectory = [f[@"type"] isEqualToString:@"dir"];
        rf.uri = f[@"uri"];
        rf.fileName = f[@"name"];
        
        [results addObject:rf];
    }
    
    return [results copy];
}

@end
