//
//  StoreCacheServiceProxyWrapper.h
//  iChat
//
//  Created by Florian BUREL on 09/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@class Conversation;
@class Message;

@interface StoreCacheServiceProxyWrapper : NSObject

- (void)saveContext;

- (User *) createUserWithId:(NSString *)identifier;
- (User *) userWithId:(NSString *)identifier;

@end
