//
//  Sensor.m
//  KBTU_SCADA
//
//  Created by Altynbek Orumbaev on 30/04/2017.
//  Copyright © 2017 A_Orumbayev. All rights reserved.
//

#import "Sensor.h"

@implementation Sensor

- (instancetype)initWithTitle:(NSString *)title andDataset:(NSArray *)dataset {
 
    self = [super init];
    
    if (self) {
        self.title = title;
        self.dataset = dataset;
    }
    
    return self;
}

@end
