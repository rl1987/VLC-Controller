//
//  RemoteFile.h
//  VLC Controller
//
//  Created by rl1987 on 13/03/17.
//
//

#import <Foundation/Foundation.h>

@interface RemoteFile : NSObject

@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *uri;
@property (nonatomic, assign) BOOL isDirectory;

@end
