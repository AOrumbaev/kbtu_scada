//
//  Sensor.h
//  KBTU_SCADA
//
//  Created by Altynbek Orumbaev on 30/04/2017.
//  Copyright © 2017 A_Orumbayev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sensor : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *dataset;

- (instancetype)initWithTitle:(NSString *)title andDataset:(NSArray *)dataset;

@end
