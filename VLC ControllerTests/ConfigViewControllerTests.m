//
//  ConfigViewControllerTests.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 30/12/13.
//
//

#import <XCTest/XCTest.h>

#import "ConfigViewController.h"
#import "AddressValidator.h"
#import "PortValidator.h"
#import "PasswordValidator.h"
#import "PlayerManager.h"

@interface ConfigViewControllerTests : XCTestCase

@property ConfigViewController *configViewController;
@property (nonatomic, strong) UIViewController *presentingViewController;

@end

@implementation ConfigViewControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:[NSBundle mainBundle]];
    
    self.configViewController = [storyboard instantiateViewControllerWithIdentifier:@"config"];
    
    self.presentingViewController = [[UIViewController alloc] init];
    
    
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
