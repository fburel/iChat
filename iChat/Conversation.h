//
//  Conversation.h
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Conversation : NSObject

@property (strong, nonatomic) NSArray * users;
@property (strong, nonatomic) NSDate * creationDate;
@property (strong, nonatomic) NSString * identifier;

@end
