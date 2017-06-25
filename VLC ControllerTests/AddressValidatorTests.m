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

@end

@implementation AddressValidatorTests

- (void)testValidIPv4AddressesAreValidatedProperly
{
    AddressValidator *validator = [[AddressValidator alloc] init];
    
    UITextField *textField = [[UITextField alloc] init];
    
    textField.text = @"1.2.3.4";
    
    XCTAssertTrue([validator validate:textField],
                  @"%@ should be considered valid input.", textField.text);
    
    textField.text = @"192.168.1.1";
    
    XCTAssertTrue([validator validate:textField],
                  @"%@ should be considered valid input.", textField.text);
}

- (void)testInvalidIPv4AddressAreInvalidated
{
    AddressValidator *validator = [[AddressValidator alloc] init];
    
    UITextField *textField = [[UITextField alloc] init];
    
    textField.text = @"256.168.1.1";

    XCTAssertFalse([validator validate:textField],
                   @"%@ should NOT be considered valid input.", textField.text);
}

- (void)testIncompleteIPv4AddressesAreInvalidated
{
    AddressValidator *validator = [[AddressValidator alloc] init];
    
    UITextField *textField = [[UITextField alloc] init];
    
    textField.text = @"226.168.1.";
    
    XCTAssertFalse([validator validate:textField],
                   @"%@ should NOT be considered valid input.", textField.text);
}

- (void)testTooLongIPv4AddressesAreInvalidated
{
    AddressValidator *validator = [[AddressValidator alloc] init];
    
    UITextField *textField = [[UITextField alloc] init];
    
    textField.text = @"226.168.1.2.3";
    
    XCTAssertFalse([validator validate:textField],
                   @"%@ should NOT be considered valid input.", textField.text);
}

- (void)testIPv6AddressIsValidated {
    AddressValidator *validator = [[AddressValidator alloc] init];
    
    UITextField *textField = [[UITextField alloc] init];
    
    textField.text = @"2001:0db8:85a3:0000:0000:8a2e:0370:7334";
    
    XCTAssert([validator validate:textField],
              @"%@ should be considered valid input.", textField.text);
}

@end
