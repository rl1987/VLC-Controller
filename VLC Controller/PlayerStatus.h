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
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, assign) NSUInteger volume;
@property (nonatomic, assign) NSTimeInterval length;
@property (nonatomic, assign) BOOL playing;
@property (nonatomic, strong) NSString *filename;

@end
