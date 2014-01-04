//
//  PlayerStatus.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import "PlayerStatus.h"

@implementation PlayerStatus

- (void)setFilename:(NSString *)filename
{
    if ([filename isKindOfClass:[NSString class]])
        _filename = filename;
    
}

@end
