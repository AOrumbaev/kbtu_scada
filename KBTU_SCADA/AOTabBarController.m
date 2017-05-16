
//
//  AOTabBarController.m
//  KBTU_SCADA
//
//  Created by Altynbek Orumbayev on 16/05/2017.
//  Copyright © 2017 A_Orumbayev. All rights reserved.
//

#import "AOTabBarController.h"
#import "AODiscoverViewController.h"
#import "AOSensorViewController.h"
#import "AOPlotViewController.h"

@interface AOTabBarController ()

@end

@implementation AOTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    _addSensorVC = (UINavigationController *)[mainStoryboard
                                                                   instantiateViewControllerWithIdentifier: @"sensorNavVC"];
    
    UINavigationController *plotVC = (UINavigationController *)[mainStoryboard
                                                                     instantiateViewControllerWithIdentifier: @"plotNavVC"];
    
    UINavigationController *discoverVC = (UINavigationController *)[mainStoryboard
                                                                     instantiateViewControllerWithIdentifier: @"predictNavVC"];
    
    self.viewControllers = @[_addSensorVC, plotVC, discoverVC];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
