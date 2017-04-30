//
//  AddSensorViewController.h
//  KBTU_SCADA
//
//  Created by Altynbek Orumbayev on 30/04/2017.
//  Copyright © 2017 A_Orumbayev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Sensor;
@protocol AddSensorViewControllerDelegate;

@interface AddSensorViewController : UIViewController

@property (nonatomic, weak) id <AddSensorViewControllerDelegate> delegate;

@end

@protocol AddSensorViewControllerDelegate <NSObject>

@required
- (void)didCreateSensor:(Sensor *)sensor;

@end
