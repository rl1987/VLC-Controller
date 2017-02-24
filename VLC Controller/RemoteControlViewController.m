//
//  RemoteControlViewController.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import "RemoteControlViewController.h"

#import "PlayerManager.h"

@interface RemoteControlViewController () <PlayerManagerDelegate>

@property (nonatomic, strong) PlayerManager *playerManager;

@end

@implementation RemoteControlViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.playerManager = [PlayerManager defaultManager];
    self.playerManager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.playerManager startReceivingStatusUpdates];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.playerManager stopReceivingStatusUpdates];
    
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Action handlers

- (IBAction)timeSliderValueChanged:(UISlider *)sender
{
    [self.playerManager seekTo:sender.value];
}

- (IBAction)seekBackPressed:(id)sender
{
    [self.playerManager seekTo:MAX(self.playerManager.status.currentTime - 10.0, 0.0)];
}

- (IBAction)seekForwardPressed:(id)sender
{
    [self.playerManager seekTo:MIN(self.playerManager.status.currentTime + 10.0, self.playerManager.status.duration)];
}

- (IBAction)playPressed:(id)sender
{
    [self.playerManager play];
}

- (IBAction)stopPressed:(id)sender
{
    [self.playerManager stop];
}

- (IBAction)prevPressed:(id)sender
{
    [self.playerManager goToPreviousItem];
}

- (IBAction)nextPressed:(id)sender
{
    [self.playerManager goToNextItem];
}

- (IBAction)softerPressed:(id)sender
{
    [self.playerManager changeVolumeTo:MAX(self.playerManager.status.volume - 10, 0)];
}

- (IBAction)louderPressed:(id)sender
{
    [self.playerManager changeVolumeTo:MIN(self.playerManager.status.volume + 10, 200)];
}

- (IBAction)playlistPressed:(id)sender
{
    // TODO
}

- (IBAction)browsePressed:(id)sender
{
    // TODO
}

- (IBAction)volumeSliderValueChanged:(UISlider *)sender
{
    [self.playerManager changeVolumeTo:(NSUInteger)sender.value];
}

#pragma mark -
#pragma mark Config view controller delegate

- (void)configViewController:(ConfigViewController *)cvc
        didFinishWithAddress:(NSString *)ipAddressString
                     andPort:(int)port
                    password:(NSString *)password
{
    NSLog(@"configViewController:didFinishWithAddress:andPort:password:");
}

#pragma mark -
#pragma mark Player Manager delegate

- (void)playerManager:(PlayerManager *)manager
       receivedStatus:(PlayerStatus *)status
{
    // TODO: update UI
}

#pragma mark -
#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"to_config"])
    {
        ConfigViewController *configVC = segue.destinationViewController;
        
        configVC.delegate = self;
    }
}

@end
