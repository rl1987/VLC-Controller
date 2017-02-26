//
//  InterfaceController.m
//  VLC Controller-watchOS Extension
//
//  Created by rl1987 on 26/02/17.
//
//

#import "InterfaceController.h"

#import "PlayerManager.h"

@interface InterfaceController()

@property (nonatomic, strong) PlayerManager *playerManager;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // FIXME: User WatchConnectivity.framework to request address and password from iOS app
    [[NSUserDefaults standardUserDefaults] setObject:@"192.168.1.227" forKey:kUserDefaultsAddressKey];
    [[NSUserDefaults standardUserDefaults] setInteger:8080 forKey:kUserDefaultsPortKey];
    [[NSUserDefaults standardUserDefaults] setObject:@"123" forKey:kUserDefaultsPassword];
    
    // Configure interface objects here.
    self.playerManager = [[PlayerManager alloc] init];
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self.playerManager startReceivingStatusUpdates];
    // XXX: we should avoid polling to conserver energy on the watch.
    // Better way to go about this is to request the PlayerStatus on as-needed basis.
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [self.playerManager stopReceivingStatusUpdates];
    
    [super didDeactivate];
}

- (IBAction)rewindTapped {
    [self.playerManager seekBy:-10.0];
}

- (IBAction)playPauseTapped {
    if (self.playerManager.status.playing)
        [self.playerManager pause];
    else
        [self.playerManager play];
}

- (IBAction)fastForwardTapped {
    [self.playerManager seekBy:10.0];
}

- (IBAction)prevIousTapped {
    [self.playerManager goToPreviousItem];
}

- (IBAction)nextTapped {
    [self.playerManager goToNextItem];
}

- (IBAction)softerTapped {
    [self.playerManager changeVolumeBy:-10];
}

- (IBAction)stopTapped {
    [self.playerManager stop];
}

- (IBAction)louderTapped {
    [self.playerManager changeVolumeBy:10];
}

@end



