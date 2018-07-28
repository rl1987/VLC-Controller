//
//  VLC_ControllerUITests.m
//  VLC ControllerUITests
//
//  Created by Rimantas Lukosevicius on 28/07/2018.
//

#import <XCTest/XCTest.h>

@interface VLC_ControllerUITests : XCTestCase

@property (nonatomic, strong) XCUIApplication *app;

@end

@implementation VLC_ControllerUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [self.app terminate];
    self.app = nil;
    
    [super tearDown];
}

- (void)testSubButton {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [self.app.buttons[@"Subtitles"] tap];
    
    XCTAssert(self.app.staticTexts[@"Sub delay:"].exists);
    XCTAssert(self.app.buttons[@"Minus"].exists);
    XCTAssert(self.app.buttons[@"Plus"].exists);
    XCTAssert(self.app.buttons[@"Switch subtitle"].exists);
}

@end
