//
//  RemoteControlViewController.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import "RemoteControlViewController.h"

#import "ConfigViewController.h"
#import "PlayerManager.h"

typedef enum {
    PopoverStateNotPresented = 0,
    PopoverStateSubtitle,
    PopoverStateAudio
} PopoverState;

@interface RemoteControlViewController () <PlayerManagerDelegate>

@property (nonatomic, strong) PlayerManager *playerManager;
@property (nonatomic, assign) PopoverState popoverState;

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
    
    [self becomeFirstResponder];
    [self.playerManager startReceivingStatusUpdates];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.playerManager stopReceivingStatusUpdates];
    [self resignFirstResponder];
    
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
    [self.playerManager seekBy:-10.0];
}

- (IBAction)seekForwardPressed:(id)sender
{
    [self.playerManager seekBy:10.0];
}

- (IBAction)playPressed:(id)sender
{
    if (self.playerManager.status.playing)
        [self.playerManager pause];
    else
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
    [self.playerManager changeVolumeBy:-10];
}

- (IBAction)louderPressed:(id)sender
{
    [self.playerManager changeVolumeBy:10];
}

- (IBAction)shuffleButtonTapped:(id)sender
{
    [self.playerManager toggleShuffle];
}

- (IBAction)repeatButtonTapped:(id)sender
{
    [self.playerManager toggleRepeat];
}

- (IBAction)volumeSliderValueChanged:(UISlider *)sender
{
    [self.playerManager changeVolumeTo:(NSUInteger)sender.value];
}

- (IBAction)fullscreenButtonTapped:(id)sender
{
    [self.playerManager toggleFullscreen];
}

- (IBAction)subtitleButtonTapped:(id)sender
{
    [self presentPopoverWithState:PopoverStateSubtitle];
}

- (IBAction)audioButtonTapped:(id)sender {
    [self presentPopoverWithState:PopoverStateAudio];
}

- (IBAction)popoverMainButtonTapped:(id)sender
{
    if (self.popoverState == PopoverStateSubtitle)
        [self.playerManager switchSubtitles];
    else if (self.popoverState == PopoverStateAudio)
        [self.playerManager switchAudioTrack];
}

- (IBAction)popoverMinusButtonTapped:(id)sender {
    if (self.popoverState == PopoverStateSubtitle)
        [self.playerManager decreaseSubtitleDelay];
    else if (self.popoverState == PopoverStateAudio)
        [self.playerManager decreaseAudioDelay];
}

- (IBAction)popoverPlusButtonTapped:(id)sender {
    if (self.popoverState == PopoverStateSubtitle)
        [self.playerManager increaseSubtitleDelay];
    else if (self.popoverState == PopoverStateAudio)
        [self.playerManager increaseAudioDelay];
}

- (IBAction)popoverBackgroundTapped:(id)sender {
    self.popoverContainerView.hidden = YES;
    self.popoverState = PopoverStateNotPresented;
}

#pragma mark -

- (void)presentPopoverWithState:(PopoverState)popoverState
{
    self.popoverState = popoverState;
    
    if (popoverState == PopoverStateAudio)
    {
        self.popoverCentralLabel.text = @"Audio delay:";
        [self.popoverMainButton setTitle:@"Switch audio" forState:UIControlStateNormal];
    }
    else if (popoverState == PopoverStateSubtitle)
    {
        self.popoverCentralLabel.text = @"Sub delay:";
        [self.popoverMainButton setTitle:@"Switch subtitle" forState:UIControlStateNormal];
    }
    
    self.popoverNumberLabel.text = @"";
    
    self.popoverContainerView.hidden = NO;
    [self.view bringSubviewToFront:self.popoverContainerView];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        DDLogInfo(@"Shake detected!");
        
        [self.playerManager startReceivingStatusUpdates];
    }
}

#pragma mark -
#pragma mark Player Manager delegate

- (void)playerManager:(PlayerManager *)manager
       receivedStatus:(PlayerStatus *)status
{
    UIImage *image = status.playing ? [UIImage imageNamed:@"Pause"] : [UIImage imageNamed:@"Play"];
    
    [self.playButton setImage:image forState:UIControlStateNormal];
    
    self.filenameLabel.textColor = [UIColor whiteColor];
    
    self.filenameLabel.text = status.filename;
    self.timeSlider.maximumValue = status.duration;
    self.timeSlider.value = status.currentTime;
    self.volumeSlider.value = status.volume;
    
    NSDateComponentsFormatter *dateComponentsFormatter = [[NSDateComponentsFormatter alloc] init];
    dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ / %@",
                           [dateComponentsFormatter stringFromTimeInterval:status.currentTime],
                           [dateComponentsFormatter stringFromTimeInterval:status.duration]];
    
    self.shuffleButton.alpha = status.randomized ? 1.0 : 0.5;
    self.repeatButton.alpha = status.repeating ? 1.0 : 0.5;
    self.fullscreenButton.alpha = status.fullscreen ? 1.0 : 0.5;
    
    if (self.popoverState == PopoverStateSubtitle) {
        self.popoverNumberLabel.text = [NSString stringWithFormat:@"%.0f ms", status.subtitleDelay * 1000];
    } else if (self.popoverState == PopoverStateAudio) {
        self.popoverNumberLabel.text = [NSString stringWithFormat:@"%.0f ms", status.audioDelay * 1000];
    }
}

- (void)playerManagerFailedWithError:(NSError *)error
{
    self.filenameLabel.textColor = [UIColor redColor];
    
    self.filenameLabel.text = @"Error - Shake to retry";
}

@end
