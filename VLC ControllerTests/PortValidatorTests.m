//
//  PortValidatorTests.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 30/12/13.
//
//

#import <XCTest/XCTest.h>

#import "PortValidator.h"

extern void __gcov_flush(void);

@interface PortValidatorTests : XCTestCase

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) PortValidator *validator;

@end

@implementation PortValidatorTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.

    self.textField = [[UITextField alloc] init];
    self.validator = [[PortValidator alloc] init];
    
}

- (void)tearDown
{
    self.textField = nil;
    self.validator = nil;
    
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testValidPortNumberIsValidated
{
    self.textField.text = @"1024";
    
    XCTAssertTrue([self.validator validate:self.textField], @"%@ is valid input",
                  self.textField.text);
}

- (void)testNonNumericalInputIsInvalidated
{
    self.textField.text = @"abc80";
    
    XCTAssertFalse([self.validator validate:self.textField],
                   @"%@ is invalid input, since it contains non-numerical characters.",
                   self.textField.text);
}

- (void)testSmallerThan1PortNumberIsInvalidated
{
    self.textField.text = @"0";
    
    XCTAssertFalse([self.validator validate:self.textField],
                   @"%@ is invalid input: too small",
                   self.textField.text);
    
    self.textField.text = @"-1";
    
    XCTAssertFalse([self.validator validate:self.textField],
                   @"%@ is invalid input: too small",
                   self.textField.text);

}

- (void)testLargerThan65535PortNumberIsInvalidated
{
    self.textField.text = @"65536";
    
    XCTAssertFalse([self.validator validate:self.textField],
                   @"%@ is invalid input: too large",
                   self.textField.text);
    
}

@end
