//
//  Storage.m
//  KBTU_SCADA
//
//  Created by Altynbek Orumbayev on 30/04/2017.
//  Copyright © 2017 A_Orumbayev. All rights reserved.
//

#import "Storage.h"

@implementation Storage

+ (instancetype)sharedInstance
{
    static Storage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Storage alloc] init];
        sharedInstance.sensorsArray = @[].mutableCopy;
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

@end
