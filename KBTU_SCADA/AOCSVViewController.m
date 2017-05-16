//
//  AOCSVViewController.m
//  KBTU_SCADA
//
//  Created by Altynbek Orumbayev on 17/05/2017.
//  Copyright © 2017 A_Orumbayev. All rights reserved.
//

#import "AOCSVViewController.h"
#import "AOSensor.h"
#import "AOStorage.h"

@interface AOCSVViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *sensorSelector;
@property (strong, nonatomic) IBOutlet UITextField *csvTitleField;
@property (strong, nonatomic) IBOutlet UITextField *inputsField;
@property (strong, nonatomic) IBOutlet UITextField *outputsField;
@property (strong, nonatomic) IBOutlet UITextField *csvPropertyName;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation AOCSVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    // Do any additional setup after loading the view.
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
- (IBAction)saveBtnPressed:(id)sender {
    
}

#pragma mark - Picker Views

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[AOStorage sharedInstance] sensorsArray].count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    AOSensor *sensor = [AOStorage sharedInstance].sensorsArray[row];
    
    return sensor.title;
}

@end
