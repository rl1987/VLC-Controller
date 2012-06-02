#import "ViewController.h"

@interface ViewController()

@property (nonatomic,strong) NSDictionary *status;
@property (nonatomic,strong) NSString *vlcAddress;

- (void)refreshGUI;

@end

@implementation ViewController

@synthesize timeLabel = _timeLabel;
@synthesize filenameLabel = _filenameLabel;

@synthesize connected = _connected;
@synthesize status = _status;
@synthesize vlcAddress = _vlcAddress;

#pragma mark -
#pragma mark View lifecycle

#define TIMER_INTERVAL 0.1

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
    
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Timer stuff

- (void)timerFired:(NSTimer *)timer
{
    if (!self.connected)
        return;
    
    // ...
}

#pragma mark -
#pragma mark Target-action stuff

- (IBAction)timeSliderValueChanged:(id)sender {
}

- (IBAction)seekBackPressed:(id)sender {
}

- (IBAction)seekForwardPressed:(id)sender {
}

- (IBAction)playPressed:(id)sender {
}

- (IBAction)stopPressed:(id)sender {
}

- (IBAction)prevPressed:(id)sender {
}

- (IBAction)nextPressed:(id)sender {
}

- (IBAction)softerPressed:(id)sender {
}

- (IBAction)louderPressed:(id)sender {
}

- (IBAction)playlistPressed:(id)sender {
}

- (IBAction)browsePressed:(id)sender {
}

#pragma mark -
#pragma mark Config view controller delegate

- (void)senderViewController:(ConfigViewController *)cvc 
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
        } else
            NSLog(@"%@",[NSString stringWithCString:[xmlData bytes] 
                                           encoding:NSASCIIStringEncoding]);
            
    });
    
    dispatch_release(q);
}

#pragma mark -
#pragma mark Refresh GUI

- (void)refreshGUI
{
    NSLog(@"ViewController refreshGUI");
    NSLog(@"%@",self.status);
}

#pragma mark -
#pragma mark Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setDelegate:self];
}

@end
