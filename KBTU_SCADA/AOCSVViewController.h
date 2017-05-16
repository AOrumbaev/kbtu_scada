//
//  AOCSVViewController.h
//  KBTU_SCADA
//
//  Created by Altynbek Orumbayev on 17/05/2017.
//  Copyright © 2017 A_Orumbayev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AOSensor;

@protocol AOCSVViewControllerDelegate <NSObject>

@required
- (void)didTapSaveForSensor:(AOSensor *)sensor;

@end

@interface AOCSVViewController : UIViewController

@property (nonatomic, copy) NSString *pathToCSV;
@property (nonatomic, weak) id <AOCSVViewControllerDelegate> delegate;

@end
