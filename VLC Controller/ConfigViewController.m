#import "ConfigViewController.h"

@implementation ConfigViewController

@synthesize addressField;
@synthesize portField;

@synthesize delegate = _delegate;

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.addressField.validator = [[AddressValidator alloc] init];
    self.portField.validator = [[PortValidator alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *defaultAddress = [defaults objectForKey:@"address"];
    NSNumber *defaultPort = [defaults objectForKey:@"port"];
    
    if (defaultAddress)
        self.addressField.text = defaultAddress;
    
    if (defaultPort)
        self.portField.text = [NSString stringWithFormat:@"%d",
                               [defaultPort intValue]];
}

- (void)viewDidUnload
{
    [self setAddressField:nil];
    [self setPortField:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Text field delegate 

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL answer;
    
    NSAssert([textField isKindOfClass:[ValidatingTextField class]], 
             @"ERROR: textField should be an instance of ValidatingTextField");    
    
    answer = [(ValidatingTextField *)textField isValid];
    
    if (answer == YES)
        [textField resignFirstResponder];
    
    return answer;
    
}

#pragma mark -
#pragma mark Target-action stuff

- (IBAction)okPressed 
{
    
    if ((self.delegate) && [self.addressField isValid] && 
        [self.portField isValid])
    {
        NSNumber *port = [NSNumber numberWithInt:[self.portField.text intValue]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setValue:self.addressField.text forKey:@"address"];
        
        [defaults setValue:port forKey:@"port"];
        
        [defaults synchronize];
        
        [self.delegate senderViewController:self 
                       didFinishWithAddress:[self.addressField.text copy]
                                    andPort:[self.portField.text intValue]];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelPressed 
{
    [self dismissModalViewControllerAnimated:YES];
}

@end