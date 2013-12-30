#import "ViewController.h"

@interface ViewController()

@property (nonatomic,strong) NSDictionary *status;
@property (nonatomic,strong) NSString *vlcAddress;

- (void)refreshGUI;
- (void)refreshStatusWithURL:(NSURL *)statusURL;

@end

@implementation ViewController

@synthesize timeLabel = _timeLabel;
@synthesize filenameLabel = _filenameLabel;
@synthesize timeSlider = _timeSlider;
@synthesize volumeSlider = _volumeSlider;
@synthesize playButton = _playButton;

@synthesize connected = _connected;
@synthesize status = _status;
@synthesize vlcAddress = _vlcAddress;

#pragma mark -
#pragma mark View lifecycle

#define TIMER_INTERVAL 1.0
#define MAX_VOLUME  200
#define MAX_VOL_90P 190
#define MAX_VOL_10P 10

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.connected = NO;
    
    NSTimer *timer = 
    [NSTimer timerWithTimeInterval:TIMER_INTERVAL 
                            target:self 
                          selector:@selector(timerFired:) 
                          userInfo:nil 
                           repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)viewDidUnload 
{
    [self setTimeLabel:nil];
    [self setFilenameLabel:nil];
    
    [self setTimeSlider:nil];
    [self setVolumeSlider:nil];
    [self setPlayButton:nil];
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Timer stuff

- (void)timerFired:(NSTimer *)timer
{
    if (!self.connected)
        return;
    
    dispatch_queue_t q = dispatch_queue_create("status request q", NULL);
    
    dispatch_async(q, ^{
        NSURL *statusURL = 
        [NSURL URLWithString:[self.vlcAddress stringByAppendingString:
                              @"status.xml"]];
        
        [self refreshStatusWithURL:statusURL];
    });
    
    dispatch_release(q);
    
}

#pragma mark -
#pragma mark Target-action stuff

- (IBAction)timeSliderValueChanged:(id)sender {
}

- (IBAction)seekBackPressed:(id)sender 
{
    NSURL *requestURL = 
    [NSURL URLWithString:[self.vlcAddress stringByAppendingString:
                          @"status.xml?command=seek&val=-30"]];
    
    dispatch_queue_t q = dispatch_queue_create("seek back request q", NULL);
    
    dispatch_async(q, ^{
        [self refreshStatusWithURL:requestURL];
    });
    
    dispatch_release(q);
}

- (IBAction)seekForwardPressed:(id)sender 
{
    NSURL *requestURL = 
    [NSURL URLWithString:[self.vlcAddress stringByAppendingString:
                          @"status.xml?command=seek&val=+"]];
    
    dispatch_queue_t q = dispatch_queue_create("seek forward request q", NULL);
    
    dispatch_async(q, ^{
        [self refreshStatusWithURL:requestURL];
    });
    
    dispatch_release(q);
}

- (IBAction)playPressed:(id)sender 
{
    NSURL *requestURL;
    
    if ([[self.status valueForKeyPath:@"root.state.text"] 
         isEqualToString:@"stop"])
        requestURL =
        [NSURL URLWithString:[self.vlcAddress stringByAppendingString:
                              @"status.xml?command=pl_play"]];
    else
        requestURL =
        [NSURL URLWithString:[self.vlcAddress stringByAppendingString:
                              @"status.xml?command=pl_pause"]];
    
    dispatch_queue_t q = dispatch_queue_create("play/pause request q", NULL);
    
    dispatch_async(q, ^{
        [self refreshStatusWithURL:requestURL];
    });
    
    dispatch_release(q);
}

- (IBAction)stopPressed:(id)sender 
{
    
    NSURL *requestURL = 
    [NSURL URLWithString:[self.vlcAddress stringByAppendingString:
                          @"status.xml?command=pl_stop"]];
    
    dispatch_queue_t q = dispatch_queue_create("stop request q", NULL);
    
    dispatch_async(q, ^{
        [self refreshStatusWithURL:requestURL];
    });
    
    dispatch_release(q);
}

- (IBAction)prevPressed:(id)sender 
{
    NSURL *requestURL = 
    [NSURL URLWithString:[self.vlcAddress stringByAppendingString:
                          @"status.xml?command=pl_previous"]];
    
    dispatch_queue_t q = dispatch_queue_create("prev request q", NULL);
    
    dispatch_async(q, ^{
        [self refreshStatusWithURL:requestURL];
    });
    
    dispatch_release(q);
}

- (IBAction)nextPressed:(id)sender 
{
    NSURL *requestURL = 
    [NSURL URLWithString:[self.vlcAddress stringByAppendingString:
                          @"status.xml?command=pl_next"]];
    
    dispatch_queue_t q = dispatch_queue_create("next request q", NULL);
    
    dispatch_async(q, ^{
        [self refreshStatusWithURL:requestURL];
    });
    
    dispatch_release(q);
}

- (IBAction)softerPressed:(id)sender 
{
    NSURL *requestURL; 
    
    if ([[self.status valueForKeyPath:@"root.volume.text"] intValue] > MAX_VOL_10P)
        requestURL =
        [NSURL URLWithString:[self.vlcAddress stringByAppendingString:
                              @"status.xml?command=volume&val=-10%25"]];
    else
        requestURL =
        [NSURL URLWithString:[self.vlcAddress stringByAppendingString:
                              @"status.xml?command=volume&val=0"]];
    
    dispatch_queue_t q = dispatch_queue_create("softer request q", NULL);
    
    dispatch_async(q, ^{
        [self refreshStatusWithURL:requestURL];
    });
    
    dispatch_release(q);
}

- (IBAction)louderPressed:(id)sender 
{
    NSString *urlString;
    
    if ([[self.status valueForKeyPath:@"root.volume.text"] intValue] < MAX_VOL_90P)
        urlString = [self.vlcAddress stringByAppendingString:
                     @"status.xml?command=volume&val=%2B10%25"];
    else
        urlString = [self.vlcAddress stringByAppendingFormat:
                     @"status.xml?command=volume&val=%d",MAX_VOLUME];
    
    
    NSURL *requestURL = [NSURL URLWithString:urlString];
    
    dispatch_queue_t q = dispatch_queue_create("louder request q", NULL);
    
    dispatch_async(q, ^{
        [self refreshStatusWithURL:requestURL];
    });
    
    dispatch_release(q);
}

- (IBAction)playlistPressed:(id)sender {
}

- (IBAction)browsePressed:(id)sender {
}

- (IBAction)volumeSliderValueChanged:(UISlider *)sender 
{
    NSURL *requestURL = 
    [NSURL URLWithString:
     [self.vlcAddress stringByAppendingFormat:@"status.xml?command=volume&val=%f",
      sender.value]];
    
    dispatch_queue_t q = dispatch_queue_create("louder request q", NULL);
    
    dispatch_async(q, ^{
        [self refreshStatusWithURL:requestURL];
    });
    
    dispatch_release(q);    
}

#pragma mark -
#pragma mark Networking stuff

- (void)refreshStatusWithURL:(NSURL *)statusURL
{
    NSData *xmlData = [NSData dataWithContentsOfURL:statusURL];
    
    NSError *error = nil;
    
    NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:xmlData 
                                                            error:error];
    
    if (xmlDictionary) {
        self.connected = YES;
        
        self.status = xmlDictionary;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshGUI];
        });
    } 
//    else
//        NSLog(@"%@",[NSString stringWithCString:[xmlData bytes] 
//                                       encoding:NSASCIIStringEncoding]);
}

#pragma mark -
#pragma mark Config view controller delegate

- (void)configViewController:(ConfigViewController *)cvc 
        didFinishWithAddress:(NSString *)ipAddressString
                     andPort:(int)port
{
    self.vlcAddress = [NSString stringWithFormat:@"http://%@:%d/requests/",
                       ipAddressString,port];
    
    dispatch_queue_t q = dispatch_queue_create("test request q", NULL);
    
    dispatch_async(q, ^{
        NSURL *statusURL = 
        [NSURL URLWithString:[self.vlcAddress stringByAppendingString:
                              @"status.xml"]];
        
        [self refreshStatusWithURL:statusURL];        
    });
    
    dispatch_release(q);
}

#pragma mark -
#pragma mark Refresh GUI

- (void)refreshGUI
{
    NSLog(@"ViewController refreshGUI");
    NSLog(@"%@",self.status);
    
    self.filenameLabel.text = 
    [self.status valueForKeyPath:@"root.information.meta-information.title.text"];
    
    int totalSeconds = 
    [[self.status valueForKeyPath:@"root.length.text"] intValue];
    
    int secondsSoFar = 
    [[self.status valueForKeyPath:@"root.time.text"] intValue];
    
    self.timeSlider.value = 
    (secondsSoFar * self.timeSlider.maximumValue)/totalSeconds;
    
    [self.timeSlider setNeedsLayout];
    
    int seconds1 = secondsSoFar % 60;
    int minutes1 = secondsSoFar / 60;
    int hours1 = minutes1 / 60;
    minutes1 -= hours1*60;
    
    int seconds2 = totalSeconds % 60;
    int minutes2 = totalSeconds / 60;
    int hours2 = minutes2 / 60;
    minutes2 -= hours2*60;
    
    self.timeLabel.text =
    [NSString stringWithFormat:@"%1d%1d:%1d%1d:%1d%1d / %1d%1d:%1d%1d:%1d%1d",
     hours1/10,hours1%10,minutes1/10,minutes1%10,seconds1/10,seconds1%10,
     hours2/10,hours2%10,minutes2/10,minutes2%10,seconds2/10,seconds2%10];  
    
    self.volumeSlider.value =
    [[self.status valueForKeyPath:@"root.volume.text"] floatValue];
    
    NSString *state = [self.status valueForKeyPath:@"root.state.text"];
    
    if ([state isEqualToString:@"playing"])
        self.playButton.titleLabel.text = @"Pause";
    else
        self.playButton.titleLabel.text = @"Play";   
    
}

#pragma mark -
#pragma mark Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setDelegate:self];
}

@end
