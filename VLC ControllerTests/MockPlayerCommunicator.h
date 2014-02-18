//
//  MockPlayerCommunicator.h
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 27/01/14.
//
//

#import "PlayerCommunicator.h"

@interface MockPlayerCommunicator : PlayerCommunicator

@property (nonatomic, strong) NSString *lastStatusJSON;
@property (nonatomic, strong) PlayerCommand *lastCommand;

@end
