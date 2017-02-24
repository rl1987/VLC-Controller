//
//  PlayerManagerTests.m
//  VLC Controller
//
//  Created by Rimantas Lukosevicius on 27/01/14.
//
//

#import <XCTest/XCTest.h>

#import "PlayerManager.h"
#import "MockPlayerCommunicator.h"
#import "MockPlayerManagerDelegate.h"

@interface PlayerManagerTests : XCTestCase

@property (nonatomic, strong) PlayerManager *playerManager;
@property (nonatomic, strong) MockPlayerCommunicator *playerCommunicator;

@end

@implementation PlayerManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    
    self.playerManager = [[PlayerManager alloc] init];
    
    self.playerCommunicator = [[MockPlayerCommunicator alloc] init];
    self.playerManager.communicator = self.playerCommunicator;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
    
    self.playerManager = nil;
    self.playerCommunicator = nil;
}

- (void)testDefaultManager
{
    PlayerManager *defaultManager = [PlayerManager defaultManager];
    
    XCTAssertNotNil(defaultManager);
    XCTAssert([defaultManager isKindOfClass:[PlayerManager class]]);
}

- (void)testPause
{
    [self.playerManager pause];
    
    XCTAssertEqual(self.playerCommunicator.lastCommand.commandType,
                   PlayerCommandPause, @"Manager should tell the communicator to send PlayerCommandPause command");
}

- (void)testPlay
{
    [self.playerManager play];
    
    XCTAssertEqual(self.playerCommunicator.lastCommand.commandType,
                   PlayerCommandPlay, @"Manager should tell the communicator to send PlayerCommandPlay command");
}

- (void)testStop
{
    [self.playerManager stop];
    
    XCTAssertEqual(self.playerCommunicator.lastCommand.commandType,
                   PlayerCommandStop, @"Manager should tell the communicator to send PlayerCommandStop command");
}

- (void)testNext
{
    [self.playerManager goToNextItem];
    
    XCTAssertEqual(self.playerCommunicator.lastCommand.commandType,
                   PlayerCommandNextEntry, @"Manager should tell the communicator to send PlayerCommandNextEntry command");
}

- (void)testPrevious
{
    [self.playerManager goToPreviousItem];
    
    XCTAssertEqual(self.playerCommunicator.lastCommand.commandType,
                   PlayerCommandPreviousEntry, @"Manager should tell the communicator to send PlayerCommandPreviousEntry command");
}

- (void)testSeek
{
    NSTimeInterval seekValue = 59.0;
    
    [self.playerManager seekTo:seekValue];
    
    XCTAssertEqual(self.playerCommunicator.lastCommand.commandType,
                   PlayerCommandSeek, @"Manager should tell the communicator to send PlayerCommandSeek command");
    
    XCTAssertEqual(self.playerCommunicator.lastCommand.value, seekValue,
                   @"Manager should assign the correct value for PlayerCommandSeek command");
}

- (void)testSetVolume
{
    NSUInteger volumeToSet = 20.0;
    
    [self.playerManager changeVolumeTo:volumeToSet];
    
    XCTAssertEqual(self.playerCommunicator.lastCommand.commandType,
                   PlayerCommandSetVolume, @"Manager should tell the communicator to send PlayerCommandSetVolume command");
    
    XCTAssertEqual(self.playerCommunicator.lastCommand.value, (double)volumeToSet,
                   @"Manager should assign the correct value for PlayerCommandSetVolume command");
}

#pragma mark -
#pragma mark delegate tests

- (void)testNonConformingObjectCannotBeDelegate
{
    XCTAssertThrows(self.playerManager.delegate = (id <PlayerManagerDelegate>)[NSNull null],
                    @"Objects that don't conform to PlayerManagerDelegate protocol cannnot be assigned as delegate");
}

- (void)testConformingObjectCanBeDelegate
{
    MockPlayerManagerDelegate *delegate = [[MockPlayerManagerDelegate alloc] init];
    
    XCTAssertNoThrow(self.playerManager.delegate = delegate,
                     @"Objects that conform to PlayerManagerDelegate can be used as delegate.");
}

- (void)testPlayerManagerAcceptsNilAsDelegate
{
    XCTAssertNoThrow(self.playerManager.delegate = nil,
                     @"Objects that conform to PlayerManagerDelegate can be used as delegate.");
}

// TODO: status retrieval test cases

@end
