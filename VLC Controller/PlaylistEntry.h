//
//  PlaylistEntry.h
//  VLC Controller
//
//  Created by rl1987 on 14/03/17.
//
//

#import <Foundation/Foundation.h>

@interface PlaylistEntry : NSObject

@property (nonatomic, assign) int identifier;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uri;
@property (nonatomic, assign) BOOL isCurrent;

@end
