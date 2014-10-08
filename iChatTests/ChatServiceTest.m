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
#import "User.h"
#import "AvatarCacheService.h"
#import "ICGravatarOperation.h"

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


- (void) testGravatarFetch
{
    
    XCTestExpectation * exp = [self expectationWithDescription:@"recupere une image"];
    
    // Arrange
    User * florian = [User new];
    florian.email = @"florian.burel@mac.com";
    
    AvatarCacheService * cache = [AvatarCacheService new];
    
    // Act
    [cache downloadAvatarForUser:florian
                      completion:^
    {
        // Assert
        NSData * data = [cache avatarForUser:florian];
        XCTAssertNotNil(data);
        
        [exp fulfill];
    
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:nil];
    
}



@end
