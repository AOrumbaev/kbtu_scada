//
//  ViewController.m
//  KBTU_SCADA
//
//  Created by Altynbek Orumbayev on 16/11/2016.
//  Copyright © 2016 A_Orumbayev. All rights reserved.
//

#import "AODiscoverViewController.h"
#import "KRMLP.h"
#import "AOPlotViewController.h"
#import "CHCSVParser.h"

@import YCML;
@import YCMatrix;

@interface AODiscoverViewController ()
@property (strong, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UITextView *statusTextView;

@property (strong, nonatomic) KRMLP *mlp;
@end

@implementation AODiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self train];
}

- (void)train {

    YCBackPropTrainer *trainer              = [YCBackPropTrainer trainer];
   // trainer.settings[@"Hidden Layer Size"]  = @5;
    trainer.settings[@"L2"]                 = @0.5;
    trainer.settings[@"Iterations"]         = @1500;
    trainer.settings[@"Alpha"]              = @0.5;
    
    YCDataframe *input    = [self dataframeWithCSVName:@"housing"];
    YCDataframe *output   = [YCDataframe dataframeWithDictionary:@{@"MedV" : [input allValuesForAttribute:@"MedV"]}];
    [input removeAttributeWithIdentifier:@"MedV"];
    
    YCFullyConnectedLayer *hl = [YCSigmoidLayer layerWithInputSize:13 outputSize:2];
    YCFullyConnectedLayer *ol = [YCLinearLayer layerWithInputSize:2 outputSize:1];
    
    YCFFN *model = [[YCFFN alloc] init];
    model.layers = @[hl, ol];
    
    model = (YCFFN *)[trainer train:model input:input output:output];
    YCDataframe *dat = [self dataframeWithCSVName:@"test"];
    
    YCDataframe *ans = [model activateWithDataframe:input];
    NSLog(@"%@", [ans allValuesForAttribute:@"error"]);
    
    ans = [model activateWithDataframe:dat];
    NSLog(@"%@", [ans allValuesForAttribute:@"error"]);
    
    
    NSDictionary *results = [[YCkFoldValidation validationWithSettings:nil] test:trainer
                                                                           input:input
                                                                          output:output];
    double RMSE = [results[@"RMSE"] doubleValue];
    
    NSLog(@"%f", RMSE);
    
}

- (void)testWithTrainer:(YCSupervisedTrainer *)trainer
                dataset:(NSString *)dataset
 dependentVariableLabel:(NSString *)label
                   rmse:(double)rmse
{
    YCDataframe *input    = [self dataframeWithCSVName:dataset];
    YCDataframe *output   = [YCDataframe dataframeWithDictionary:@{label : [input allValuesForAttribute:label]}];
    [input removeAttributeWithIdentifier:label];
    NSDictionary *results = [[YCkFoldValidation validationWithSettings:nil] test:trainer
                                                                           input:input
                                                                          output:output];
    double RMSE           = [results[@"RMSE"] doubleValue];
    
    NSLog(@"%f", RMSE);
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

- (IBAction)predictBtnPressed:(id)sender {
    
    if (_inputField.text != nil && _inputField.text.length > 0) {
        // Verifying #7 (the number is something wrong)
        NSArray *inputs = @[[NSNumber numberWithInteger:[_inputField.text integerValue]]];
        [_mlp predicateWithFeatures:inputs completion:^(KRMLPNetworkOutput *networkOutput) {
            [networkOutput.results enumerateObjectsUsingBlock:^(KRMLPResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"Predicated the number [%li] is possible %@%%", (long)obj.outputIndex, obj.probability);
            }];
        }];
    }
}

- (IBAction)trainBtnPressed:(id)sender {
   
}

@end
