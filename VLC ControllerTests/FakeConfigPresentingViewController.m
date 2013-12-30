//
//  FakeConfigPresentingViewController.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 30/12/13.
//
//

#import "FakeConfigPresentingViewController.h"

@implementation FakeConfigPresentingViewController

- (id)init
{
    self = [super init];
    
    if (self)
        self.delegateMethodCalled = NO;
    
    return self;
}

- (void)configViewController:(ConfigViewController *)cvc
        didFinishWithAddress:(NSString *)ipAddressString
                     andPort:(int)port
{
    self.configViewControllerFromDelegate = cvc;
    self.ipAddressString = ipAddressString;
    self.port = port;

    self.delegateMethodCalled = YES;
}

@end
