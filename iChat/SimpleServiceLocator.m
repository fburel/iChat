//
//  SimpleServiceLocator.m
//  iChat
//
//  Created by Florian BUREL on 08/10/2014.
//  Copyright (c) 2014 Florian Burel. All rights reserved.
//

#import "SimpleServiceLocator.h"

@interface SimpleServiceLocator ()
@property (strong, nonatomic) NSMutableDictionary * services;
@end

@implementation SimpleServiceLocator

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

- (NSMutableDictionary *)services
{
    if(!_services)
    {
        _services = [NSMutableDictionary new];
    }
    return _services;
}

- (id)serviceWithType:(Class)type
{
    NSString * key = NSStringFromClass(type);
    id service = self.services[key];
    if(!service)
    {
        service = [[type alloc]init];
        [self.services setObject:service forKey:key];
    }
    return service;
}
@end
