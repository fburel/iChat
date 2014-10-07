//
//  Message.h
//  iChat
//
//  Created by Florian BUREL on 07/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Message : NSObject

@property (strong, nonatomic) User * sender;
@property (strong, nonatomic) NSString * text;
@property (strong, nonatomic) NSDate * sentDate;

@end
