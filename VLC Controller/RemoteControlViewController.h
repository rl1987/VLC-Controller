//
//  RemoteControlViewController.h
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 01/01/14.
//
//

#import <UIKit/UIKit.h>

@interface RemoteControlViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *filenameLabel;
@property (strong, nonatomic) IBOutlet UISlider *timeSlider;
@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *shuffleButton;
@property (strong, nonatomic) IBOutlet UIButton *repeatButton;
@property (strong, nonatomic) IBOutlet UIButton *fullscreenButton;

@property (weak, nonatomic) IBOutlet UIView *popoverContainerView;
@property (weak, nonatomic) IBOutlet UIButton *popoverMainButton;
@property (weak, nonatomic) IBOutlet UILabel *popoverCentralLabel;
@property (weak, nonatomic) IBOutlet UILabel *popoverNumberLabel;

- (IBAction)timeSliderValueChanged:(id)sender;
- (IBAction)seekBackPressed:(id)sender;
- (IBAction)seekForwardPressed:(id)sender;
- (IBAction)playPressed:(id)sender;
- (IBAction)stopPressed:(id)sender;
- (IBAction)prevPressed:(id)sender;
- (IBAction)nextPressed:(id)sender;
- (IBAction)softerPressed:(id)sender;
- (IBAction)louderPressed:(id)sender;
- (IBAction)volumeSliderValueChanged:(UISlider *)sender;
- (IBAction)shuffleButtonTapped:(id)sender;
- (IBAction)repeatButtonTapped:(id)sender;
- (IBAction)fullscreenButtonTapped:(id)sender;
- (IBAction)subtitleButtonTapped:(id)sender;

- (IBAction)popoverMainButtonTapped:(id)sender;
- (IBAction)popoverMinusButtonTapped:(id)sender;
- (IBAction)popoverPlusButtonTapped:(id)sender;
- (IBAction)popoverBackgroundTapped:(id)sender;

@end
