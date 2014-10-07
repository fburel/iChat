//
//  iChatTests.m
//  iChatTests
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Parse/Parse.h>

@interface iChatTests : XCTestCase

@end

@implementation iChatTests

- (void)setUp {
    [super setUp];
   
    // Initialiser Parse (A executer une seule fois)
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParse {
    
    // login synchrone
    PFUser * florian = [PFUser logInWithUsername:@"Florian" password:@"1234"];
    
    XCTAssertNotNil(florian);
    
}

@end
