//
//  PlayerStatus.h
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import <Foundation/Foundation.h>

@interface PlayerStatus : NSObject

@property (nonatomic, assign) BOOL fullscreen;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) NSUInteger volume;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, assign) BOOL randomized;
@property (nonatomic, assign) BOOL repeating;
@property (nonatomic, assign) NSTimeInterval subtitleDelay;

@end
