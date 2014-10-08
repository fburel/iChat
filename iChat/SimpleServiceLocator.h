//
//  SimpleServiceLocator.h
//  iChat
//
//  Created by Florian BUREL on 08/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleServiceLocator : NSObject

+ (instancetype) sharedInstance;

- (id) serviceWithType:(Class)type;

@end
