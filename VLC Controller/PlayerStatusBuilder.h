//
//  PlayerStatusBuilder.h
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import <Foundation/Foundation.h>

@class PlayerStatus;

@interface PlayerStatusBuilder : NSObject

- (PlayerStatus *)statusFromJSON:(NSString *)json;

@end
