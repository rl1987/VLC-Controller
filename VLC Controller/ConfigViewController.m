#import "ConfigViewController.h"

@implementation ConfigViewController

@synthesize addressField;
@synthesize portField;

@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Accessors

- (void)setDelegate:(id<ConfigViewControllerDelegate>)delegate
{
    if (!delegate || [(NSObject *)delegate conformsToProtocol:@protocol(ConfigViewControllerDelegate)])
        _delegate = delegate;
    else {
        NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
                                                         reason:@"Delegate object does not conform to the delegate protocol"
                                                       userInfo:nil];
        
        [exception raise];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.addressField.validator = [[AddressValidator alloc] init];
    self.portField.validator = [[PortValidator alloc] init];
    self.passwordField.validator = [[PasswordValidator alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *defaultAddress = [defaults objectForKey:kUserDefaultsAddressKey];
    NSNumber *defaultPort = [defaults objectForKey:kUserDefaultsPortKey];
    NSString *defaultPassword = [defaults objectForKey:kUserDefaultsPassword];
    
    if (defaultAddress)
        self.addressField.text = defaultAddress;
    
    if (defaultPort)
        self.portField.text = [NSString stringWithFormat:@"%d",
                               [defaultPort intValue]];
    
    if (defaultPassword)
        self.passwordField.text = defaultPassword;
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
        [self.portField isValid] && [self.passwordField isValid])
    {
        NSNumber *port = [NSNumber numberWithInt:[self.portField.text intValue]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setValue:self.addressField.text forKey:kUserDefaultsAddressKey];
        
        [defaults setValue:port forKey:kUserDefaultsPortKey];
        
        [defaults setValue:self.passwordField.text forKey:kUserDefaultsPassword];
        
        [defaults synchronize];
        
        [self.delegate configViewController:self 
                       didFinishWithAddress:[self.addressField.text copy]
                                    andPort:[self.portField.text intValue]
                                   password:self.passwordField.text];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)cancelPressed 
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
