//
//  MockPlayerCommunicator.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 27/01/14.
//
//

#import "MockPlayerCommunicator.h"

@implementation MockPlayerCommunicator

- (void)sendCommand:(PlayerCommand *)command
{
    self.lastCommand = command;
}

@end
