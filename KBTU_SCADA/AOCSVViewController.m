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
@import YCML;

@interface AOCSVViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

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
    
    self.csvTitleField.delegate = self;
    self.inputsField.delegate = self;
    self.outputsField.delegate = self;
    self.csvPropertyName.delegate = self;
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
    
    if ([AOStorage sharedInstance].sensorsArray.count > 0) {
        
        if (self.csvTitleField.text.length > 0 &&
            self.inputsField.text.length > 0 &&
            self.outputsField.text.length > 0 &&
            self.csvPropertyName.text.length > 0) {
            
            YCDataframe *input    = [self dataframeWithCSVName:@"housing"];
            YCDataframe *output   = [YCDataframe dataframeWithDictionary:@{@"MedV" : [input allValuesForAttribute:@"MedV"]}];
            [input removeAttributeWithIdentifier:@"MedV"];
            
            YCFullyConnectedLayer *hl = [YCSigmoidLayer layerWithInputSize:self.inputsField.text.integerValue outputSize:self.outputsField.text.integerValue];
            YCFullyConnectedLayer *ol = [YCLinearLayer layerWithInputSize:self.outputsField.text.integerValue outputSize:1];
            
            YCFFN *model = [[YCFFN alloc] init];
            model.layers = @[hl, ol];
            
            AOSensor *sensor = [[[AOStorage sharedInstance] sensorsArray] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            sensor.input = input;
            sensor.output = output;
            sensor.model = model;
            
            [self.delegate didTapSaveForSensor:sensor];
        }
        else {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please, make sure you have filled all fields" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:ok];
            [self presentViewController:ac animated:YES completion:nil];
        }
    }
    else {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please, make sure you have at least one sensor in system" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:ok];
        [self presentViewController:ac animated:YES completion:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (YCDataframe *)dataframeWithCSVName:(NSString *)path
{
    YCDataframe *output    = [YCDataframe dataframe];
    NSBundle *bundle       = [NSBundle bundleForClass:[self class]];
    NSString *filePath     = [bundle pathForResource:path ofType:@"csv"];
    NSString* fileContents = [NSString stringWithContentsOfFile:filePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    NSMutableArray *rows = [[fileContents CSVComponents] mutableCopy];
    
    NSArray *labels        = rows[0];
    [rows removeObjectAtIndex:0];
    
    for (NSArray *sampleData in rows)
    {
        // The provided dataframes should be made up of NSNumbers.
        // Thus we need t convert anything coming from the CSV file to NSNumber.
        NSMutableArray *dataAsNumbers = [NSMutableArray array];
        for (id record in sampleData)
        {
            [dataAsNumbers addObject:@([record doubleValue])];
        }
        [output addSampleWithData:[NSDictionary dictionaryWithObjects:dataAsNumbers forKeys:labels]];
    }
    
    return output;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
