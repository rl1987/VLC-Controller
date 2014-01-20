//
//  PasswordValidatorTests.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 20/01/14.
//
//

#import <XCTest/XCTest.h>

#import "PasswordValidator.h"
#import "ValidatingTextField.h"

@interface PasswordValidatorTests : XCTestCase

@property (nonatomic, strong) ValidatingTextField *textField;
@property (nonatomic, strong) PasswordValidator *validator;

@end

@implementation PasswordValidatorTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    self.textField = [[ValidatingTextField alloc] init];
    self.validator = [[PasswordValidator alloc] init];
    
    self.textField.validator = self.validator;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    
    self.textField = nil;
    self.validator = nil;
}

- (void)testOnlyPasswordsLongerThanZeroCharactersAreValidated
{
    self.textField.text = @"";
    
    XCTAssertFalse([self.validator validate:self.textField],
                   @"Zero length string should be disallowed");
    
    self.textField.text = @"a";
    
    XCTAssertTrue([self.validator validate:self.textField],
                  @"Nonzero length string should be allowed");
}

@end
