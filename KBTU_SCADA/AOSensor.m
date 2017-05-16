//
//  Sensor.m
//  KBTU_SCADA
//
//  Created by Altynbek Orumbaev on 30/04/2017.
//  Copyright © 2017 A_Orumbayev. All rights reserved.
//

#import "AOSensor.h"

@implementation AOSensor

- (instancetype)initWithTitle:(NSString *)title andDataset:(NSString *)dataset {
 
    self = [super init];
    
    if (self) {
        self.title = title;
        self.datasetLink = dataset;
    }
    
    return self;
}

@end
