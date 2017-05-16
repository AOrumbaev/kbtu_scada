//
//  Sensor.h
//  KBTU_SCADA
//
//  Created by Altynbek Orumbaev on 30/04/2017.
//  Copyright © 2017 A_Orumbayev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YCFFN, YCDataframe;

@interface AOSensor : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic) UIImage *sensorImage;
@property (nonatomic, copy) NSString *datasetLink;
@property (nonatomic, strong) YCDataframe *input;
@property (nonatomic, strong) YCDataframe *output;
@property (nonatomic, strong) YCFFN *model;

- (instancetype)initWithTitle:(NSString *)title andDataset:(NSString *)dataset;

@end
