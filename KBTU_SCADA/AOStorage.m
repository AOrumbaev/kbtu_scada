//
//  AOStorage.m
//  KBTU_SCADA
//
//  Created by Altynbek Orumbayev on 30/04/2017.
//  Copyright © 2017 A_Orumbayev. All rights reserved.
//

#import "AOStorage.h"

@implementation AOStorage

+ (instancetype)sharedInstance
{
    static AOStorage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AOStorage alloc] init];
        sharedInstance.sensorsArray = @[].mutableCopy;
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

@end
