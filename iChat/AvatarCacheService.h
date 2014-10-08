//
//  AvatarCacheService.h
//  iChat
//
//  Created by Florian BUREL on 08/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@interface AvatarCacheService : NSObject

// Enregistre un avatar pour un utilisateur
- (void) registerAvatar:(NSData *)avatarData forUser:(User *)user;

// Retourne l'avatar de l'utilisateur ou nil
- (NSData *) avatarForUser:(User *)user;

@end
