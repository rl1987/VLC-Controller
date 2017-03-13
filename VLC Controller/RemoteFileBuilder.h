//
//  RemoteFileBuilder.h
//  VLC Controller
//
//  Created by rl1987 on 13/03/17.
//
//

#import <Foundation/Foundation.h>

#import "RemoteFile.h"

@interface RemoteFileBuilder : NSObject

- (NSArray<RemoteFile *> *)remoteFilesFromJSONDictionary:(NSDictionary *)jsonDictionary;

@end
