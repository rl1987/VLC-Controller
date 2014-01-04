//
//  PlayerStatusTests.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 04/01/14.
//
//

#import <XCTest/XCTest.h>

#import "PlayerStatus.h"

@interface PlayerStatusTests : XCTestCase

@property (nonatomic, strong) PlayerStatus *status;

@end

@implementation PlayerStatusTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    self.status = [[PlayerStatus alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    self.status = nil;
    
    [super tearDown];
}

- (void)testOnlyNSStringInstancesCanBeSetAsFilename
{
    NSString *validFilename = @"movie.avi";
    NSNull *nullObject = [NSNull null];
    
    self.status.filename = validFilename;
    
    XCTAssertEqualObjects(self.status.filename, validFilename,
                          @"NSString should be set as filename");
    
    self.status.filename = (NSString *)nullObject;
    
    XCTAssertNotEqualObjects(self.status.filename, nullObject,
                             @"Objects other than NSStrings should not be set as filenames.");
    
    XCTAssertEqualObjects(self.status.filename, validFilename,
                          @"PlayerStatus should ignore attempts to set filename to invalid value.");
}

@end
