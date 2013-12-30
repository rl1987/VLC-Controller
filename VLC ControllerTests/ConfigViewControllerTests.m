//
//  ConfigViewControllerTests.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 30/12/13.
//
//

#import <XCTest/XCTest.h>

#import "ConfigViewController.h"
#import "FakeConfigPresentingViewController.h"

@interface ConfigViewControllerTests : XCTestCase

@property ConfigViewController *configViewController;
@property FakeConfigPresentingViewController *presentingViewController;

@end

@implementation ConfigViewControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:[NSBundle mainBundle]];
    
    self.configViewController = [storyboard instantiateViewControllerWithIdentifier:@"config"];
    
    self.presentingViewController = [[FakeConfigPresentingViewController alloc] init];
    
    self.configViewController.delegate = self.presentingViewController;
    
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:self.presentingViewController];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    self.configViewController = nil;
    self.presentingViewController = nil;
    
    [super tearDown];
}

- (void)testTappingCancelClosesConfigWithoutCallingDelegateMethod
{
    self.presentingViewController.delegateMethodCalled = NO;
    
    [self.presentingViewController presentModalViewController:self.configViewController
                                                     animated:NO];
    
    [self.configViewController cancelPressed];
    
    // Wait for view dismissal animation to finish.
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 1.0]];
    
    XCTAssertFalse(self.presentingViewController.delegateMethodCalled,
                   @"Delegate method must not be called when Cancel button is tapped.");
    XCTAssertNil(self.presentingViewController.presentedViewController,
                 @"Tapping Cancel button should dismiss modally presented ConfigViewController");
    
}

- (void)testTappingOKClosesConfigAndTellsTheInputToDelegate
{
    self.presentingViewController.delegateMethodCalled = NO;
    self.presentingViewController.ipAddressString = nil;
    self.presentingViewController.port = 0;
    
    [self.presentingViewController presentModalViewController:self.configViewController
                                                     animated:NO];
    
    NSString *addressString = @"192.168.2.1";
    NSString *portString = @"8080";
    
    self.configViewController.addressField.text = addressString;
    self.configViewController.portField.text = portString;
    
    [self.configViewController okPressed];
    
    // Wait for view dismissal animation to finish.
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 1.0]];
    
    XCTAssertTrue(self.presentingViewController.delegateMethodCalled,
                  @"Delegate method should be called when IP:port fields are filled and OK button is tapped");
    
    XCTAssertEqualObjects(self.presentingViewController.ipAddressString, addressString,
                   @"ConfigViewController should tell the delegate text in its address field.");
    
    XCTAssertEqual(self.presentingViewController.port, [portString intValue],
                  @"ConfigViewController should tell the delegate port number user entered");
    
    XCTAssertNil(self.presentingViewController.presentedViewController,
                 @"ConfigViewController should be dismissed after OK is tapped");
    
}

- (void)testTappingOKClosesConfigButDoesntCallDelegateIfInputIsntValid
{
    self.presentingViewController.delegateMethodCalled = NO;
    
    [self.presentingViewController presentModalViewController:self.configViewController
                                                     animated:NO];
    
    self.configViewController.addressField.text = @"192.168.2.1";
    self.configViewController.portField.text = @"INVALID PORT INPUT";
    
    [self.configViewController okPressed];
    
    // Wait for view dismissal animation to finish.
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 1.0]];
    
    XCTAssertFalse(self.presentingViewController.delegateMethodCalled,
                   @"ConfigViewController should not call delegate if invalid port is entered.");
    
    XCTAssertNil(self.presentingViewController.presentedViewController,
                 @"ConfigViewController should be dismissed after OK is tapped");
    
    self.presentingViewController.delegateMethodCalled = NO;
    
    [self.presentingViewController presentModalViewController:self.configViewController
                                                     animated:NO];
    
    self.configViewController.addressField.text = @"INVALID IP ADDR";
    self.configViewController.portField.text = @"80";
    
    [self.configViewController okPressed];
    
    // Wait for view dismissal animation to finish.
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 1.0]];
    
    XCTAssertFalse(self.presentingViewController.delegateMethodCalled,
                   @"ConfigViewController should not call delegate if invalid IP is entered.");
    
    XCTAssertNil(self.presentingViewController.presentedViewController,
                 @"ConfigViewController should be dismissed after OK is tapped");
    
}


@end
