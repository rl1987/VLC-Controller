//
//  AddressValidatorTests.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 30/12/13.
//
//

#import <XCTest/XCTest.h>

#import "AddressValidator.h"

@interface AddressValidatorTests : XCTestCase

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) AddressValidator *validator;

@end

@implementation AddressValidatorTests

- (void)setUp
{
    [super setUp];
    
    self.textField = [[UITextField alloc] init];
    self.validator = [[AddressValidator alloc] init];
}

- (void)tearDown
{
    self.textField = nil;
    self.validator = nil;
    
    [super tearDown];
}

- (void)testValidIPv4AddressesAreValidatedProperly
{
    self.textField.text = @"1.2.3.4";
    
    XCTAssertTrue([self.validator validate:self.textField],
                  @"%@ should be considered valid input.", self.textField.text);
    
    self.textField.text = @"192.168.1.1";
    
    XCTAssertTrue([self.validator validate:self.textField],
                  @"%@ should be considered valid input.", self.textField.text);
}

- (void)testInvalidIPv4AddressAreInvalidated
{
    self.textField.text = @"256.168.1.1";

    XCTAssertFalse([self.validator validate:self.textField],
                   @"%@ should NOT be considered valid input.", self.textField.text);
}

- (void)testIncompleteIPv4AddressesAreInvalidated
{
    self.textField.text = @"226.168.1.";
    
    XCTAssertFalse([self.validator validate:self.textField],
                   @"%@ should NOT be considered valid input.", self.textField.text);
}

- (void)testTooLongIPv4AddressesAreInvalidated
{
    self.textField.text = @"226.168.1.2.3";
    
    XCTAssertFalse([self.validator validate:self.textField],
                   @"%@ should NOT be considered valid input.", self.textField.text);
}

- (void)testIPv6AddressIsValidated {
    self.textField.text = @"2001:0db8:85a3:0000:0000:8a2e:0370:7334";
    
    XCTAssert([self.validator validate:self.textField],
              @"%@ should be considered valid input.", self.textField.text);
}

@end
