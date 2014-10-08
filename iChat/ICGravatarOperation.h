//
//  ICGravatarOperation.h
//  iChat
//
//  Created by Florian BUREL on 08/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface ICGravatarOperation : NSOperation

@property (strong, nonatomic) User * user;

@property (strong) NSData * avatarData;

@end
