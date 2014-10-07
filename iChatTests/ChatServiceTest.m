//
//  ChatServiceTest.m
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ChatService.h"
#import <Parse/Parse.h>

@interface ChatServiceTest : XCTestCase

@property (strong, nonatomic) ChatService * service;

@end

@implementation ChatServiceTest
@synthesize service = _service;

- (ChatService *)service
{
    if(!_service)
    {
        _service = [[ChatService alloc]init];
    }
    return _service;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}




- (void) testFetchAllUsersReturns
{
    
     XCTestExpectation *success = [self expectationWithDescription:@"methods returns"];
    
    [self.service fetchAllUsers:^(NSArray *results, NSError *error) {
        XCTAssertNil(error);
        XCTAssertTrue(results.count > 0);
        
        [success fulfill];
        
    }];
    
    // The test will pause here, running the run loop, until the timeout is hit or all expectations are fulfilled.
    [self waitForExpectationsWithTimeout:30
                                 handler:^(NSError *error) {
        // Clean up.
    }];
}

@end
