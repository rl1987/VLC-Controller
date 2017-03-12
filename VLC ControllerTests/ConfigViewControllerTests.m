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
#import "AddressValidator.h"
#import "PortValidator.h"
#import "PasswordValidator.h"
#import "PlayerManager.h"

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

#pragma mark -
#pragma mark Delegate related tests

- (void)testNonConformingObjectCannotBeDelegate
{
    ConfigViewController *cvc = [[ConfigViewController alloc] init];
    
    XCTAssertThrows(cvc.delegate = (id <ConfigViewControllerDelegate>)[NSNull null],
                    @"Object that doesn't implement ConfigViewController protocol cannot be delegate.");
}

- (void)testConformingObjectCanBeDelegate
{
    ConfigViewController *cvc = [[ConfigViewController alloc] init];
    
    XCTAssertNoThrow(cvc.delegate = self.presentingViewController,
                     @"Object conforming to ConfigViewDelegate protocol should be used as delegate.");
}

- (void)testNilCanBeSetAsDelegate
{
    ConfigViewController *cvc = [[ConfigViewController alloc] init];
    
    cvc.delegate = self.presentingViewController;
    
    XCTAssertNoThrow(cvc.delegate = nil, @"Exception should not be thrown when setting nil as delegate.");
    
    XCTAssertNil(cvc.delegate, @"ConfigViewController should allow unsetting delegate");
    
}

- (void)testTappingCancelClosesConfigWithoutCallingDelegateMethod
{
    self.presentingViewController.delegateMethodCalled = NO;
    
    [self.presentingViewController presentViewController:self.configViewController
                                                animated:NO
                                              completion:NULL];
    
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
    
    [self.presentingViewController presentViewController:self.configViewController
                                                animated:NO
                                              completion:NULL];
    
    NSString *addressString = @"192.168.2.1";
    NSString *portString = @"8080";
    NSString *password = @"trustno1";
    
    self.configViewController.addressField.text = addressString;
    self.configViewController.portField.text = portString;
    self.configViewController.passwordField.text = password;
    
    [self.configViewController okPressed];
    
    // Wait for view dismissal animation to finish.
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 1.0]];
    
    XCTAssertTrue(self.presentingViewController.delegateMethodCalled,
                  @"Delegate method should be called when IP:port fields are filled and OK button is tapped");
    
    XCTAssertEqualObjects(self.presentingViewController.ipAddressString, addressString,
                   @"ConfigViewController should tell the delegate text in its address field.");
    
    XCTAssertEqual(self.presentingViewController.port, [portString intValue],
                  @"ConfigViewController should tell the delegate port number user entered");
    
    XCTAssertEqualObjects(self.presentingViewController.password,
                          password, @"ConfigViewController should tell the delegate a password user entered.");
    
    XCTAssertNil(self.presentingViewController.presentedViewController,
                 @"ConfigViewController should be dismissed after OK is tapped");
    
}

- (void)testTappingOKClosesConfigButDoesntCallDelegateIfInputIsntValid
{
    self.presentingViewController.delegateMethodCalled = NO;
    
    [self.presentingViewController presentViewController:self.configViewController
                                                animated:NO
                                              completion:NULL];
    
    self.configViewController.addressField.text = @"192.168.2.1";
    self.configViewController.portField.text = @"INVALID PORT INPUT";
    self.configViewController.passwordField.text = @"a";
    
    [self.configViewController okPressed];
    
    // Wait for view dismissal animation to finish.
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 1.0]];
    
    XCTAssertFalse(self.presentingViewController.delegateMethodCalled,
                   @"ConfigViewController should not call delegate if invalid port is entered.");
    
    XCTAssertNil(self.presentingViewController.presentedViewController,
                 @"ConfigViewController should be dismissed after OK is tapped");
    
    self.presentingViewController.delegateMethodCalled = NO;
    
    [self.presentingViewController presentViewController:self.configViewController
                                                animated:NO
                                              completion:NULL];
    
    self.configViewController.addressField.text = @"INVALID IP ADDR";
    self.configViewController.portField.text = @"80";
    self.configViewController.passwordField.text = @"a";
    
    [self.configViewController okPressed];
    
    // Wait for view dismissal animation to finish.
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 1.0]];
    
    XCTAssertFalse(self.presentingViewController.delegateMethodCalled,
                   @"ConfigViewController should not call delegate if invalid IP is entered.");
    
    XCTAssertNil(self.presentingViewController.presentedViewController,
                 @"ConfigViewController should be dismissed after OK is tapped");
    
    self.configViewController.addressField.text = @"192.168.2.1";
    self.configViewController.portField.text = @"80";
    self.configViewController.passwordField.text = @"";
    
    [self.configViewController okPressed];
    
    // Wait for view dismissal animation to finish.
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    
    XCTAssertFalse(self.presentingViewController.delegateMethodCalled,
                   @"ConfigViewController should not call delegate if invalid password is entered.");
    
    XCTAssertNil(self.presentingViewController.presentedViewController,
                 @"ConfigViewController should be dismissed after OK is tapped");
    
}

#pragma mark -
#pragma mark View lifecycle related tests

- (void)testViewWillAppearSetsProperValidatorsToTextFields
{
    // We have to put view controller on the screen to have its view hierarchy
    // loaded from storyboard.
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:
     self.configViewController];
    
    [self.configViewController viewWillAppear:NO];
    
    XCTAssertTrue([self.configViewController.addressField.validator isKindOfClass:[AddressValidator class]],
                   @"viewWillAppear should set AddressValidator to addressField");
    
    XCTAssertTrue([self.configViewController.portField.validator isKindOfClass:[PortValidator class]],
                  @"viewWillAppear should set PortValidator to portField.");
    
    XCTAssertTrue([self.configViewController.passwordField.validator isKindOfClass:[PasswordValidator class]],
                  @"viewWillAppear should set PasswordValidator to passwordField");
    
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:nil];
}

- (void)testViewWillAppearLoadsSetttingFromUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:80]
                                              forKey:kUserDefaultsPortKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"192.168.2.1"
                                              forKey:kUserDefaultsAddressKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"trustno1"
                                              forKey:kUserDefaultsPassword];
    
    // We have to put view controller on the screen to have its view hierarchy
    // loaded from storyboard.
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:
     self.configViewController];
    
    [self.configViewController viewWillAppear:NO];
    
    XCTAssertEqualObjects(self.configViewController.addressField.text,
                          @"192.168.2.1", @"IP address should be retrieved from NSUserDefaults");
    
    XCTAssertEqualObjects(self.configViewController.portField.text, @"80",
                          @"Port number should be retrieved from NSUserDefaults");
    
    XCTAssertEqualObjects(self.configViewController.passwordField.text,
                          @"trustno1", @"Password should be retrieved from NSUserDefaults");
    
    [[[UIApplication sharedApplication] keyWindow] setRootViewController:nil];
    
}

- (void)testValidSettingsAreSavedToUserDefaultsWhenConfigCloses
{
    [[NSUserDefaults standardUserDefaults] setObject:nil
                                              forKey:kUserDefaultsAddressKey];
    [[NSUserDefaults standardUserDefaults] setObject:nil
                                              forKey:kUserDefaultsPortKey];
    
    [self.presentingViewController presentViewController:self.configViewController
                                                animated:NO
                                              completion:NULL];
    
    NSString *address = @"192.168.2.1";
    NSString *port = @"80";
    NSString *password = @"trustno1";
    
    self.configViewController.addressField.text = address;
    self.configViewController.portField.text = port;
    self.configViewController.passwordField.text = password;
    
    [self.configViewController okPressed];
    
    // Wait for view dismissal animation to finish.
    [[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 1.0]];
    
    XCTAssertEqualObjects([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAddressKey],
                          address,
                          @"Valid IP address should be saved to NSUserDefaults when user taps OK");
    XCTAssertEqual([[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsPortKey] intValue],
                   [port intValue],
                   @"Valid port should be saved to NSUserDefaults when user taps OK");
    XCTAssertEqualObjects([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsPassword],
                          password, @"Valid password should be saved to NSUserDefaults when user taps OK.");
    
}

@end
