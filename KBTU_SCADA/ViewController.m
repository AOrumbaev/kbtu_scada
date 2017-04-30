//
//  ViewController.m
//  KBTU_SCADA
//
//  Created by Altynbek Orumbayev on 16/11/2016.
//  Copyright © 2016 A_Orumbayev. All rights reserved.
//

#import "ViewController.h"
#import "KRMLP.h"
#import "AOPlotViewController.h"
#import "CHCSVParser.h"

@import YCML;
@import YCMatrix;

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UITextView *statusTextView;

@property (strong, nonatomic) KRMLP *mlp;
@end

@implementation ViewController

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
    
    YCDataframe *input    = [self dataframeWithCSVName:@"tempData"];
    YCDataframe *output   = [YCDataframe dataframeWithDictionary:@{@"error" : [input allValuesForAttribute:@"error"]}];
    [input removeAttributeWithIdentifier:@"error"];
    
    YCFullyConnectedLayer *hl = [YCSigmoidLayer layerWithInputSize:3 outputSize:5];
    YCFullyConnectedLayer *ol = [YCLinearLayer layerWithInputSize:5 outputSize:1];
    
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
                NSLog(@"Predicated the number [%li] is possible %@%%", obj.outputIndex, obj.probability);
            }];
        }];
    }
    
    
}

- (IBAction)trainBtnPressed:(id)sender {
    //
    //    [self trainWithFeatures:features andTargets:targets];
    //    NSArray *trainingSet = [AOPlotViewController sharedInstance].dataSetArray;
    //
    //    if (trainingSet.count > 0) {
    //        NSMutableArray *features = @[].mutableCopy;
    //        NSMutableArray *targets = @[].mutableCopy;
    //        for (int i = 0; i < trainingSet.count ; i++) {
    //            NSDictionary *curDict = [trainingSet objectAtIndex:i];
    //            [features addObject: [self numberToFeatures:[curDict valueForKey:@"x"]]];
    //
    //            [targets addObject: [self numberToTargets:[curDict valueForKey:@"y"]]];
    //        }
    //
    //        [self trainWithFeatures:features andTargets:targets];
    //    }
    //
    //    else {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Not enough training data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alert show];
    //    }
}

- (NSArray *)numberToTargets:(NSNumber *)number {
    
    switch (number.integerValue) {
        case 30:
            return  @[@1, @0, @0, @0, @0, @0, @0, @0, @0, @0];
        case 31:
            return  @[@0, @1, @0, @0, @0, @0, @0, @0, @0, @0];
        case 32:
            return  @[@0, @0, @1, @0, @0, @0, @0, @0, @0, @0];
        case 33:
            return  @[@0, @0, @0, @1, @0, @0, @0, @0, @0, @0];
        case 34:
            return  @[@0, @0, @0, @0, @1, @0, @0, @0, @0, @0];
        case 35:
            return  @[@0, @0, @0, @0, @0, @1, @0, @0, @0, @0];
        case 36:
            return  @[@0, @0, @0, @0, @0, @0, @1, @0, @0, @0];
        case 37:
            return  @[@0, @0, @0, @0, @0, @0, @0, @1, @0, @0];
        case 38:
            return  @[@0, @0, @0, @0, @0, @0, @0, @0, @1, @0];
        case 39:
            return  @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @1];
        case 40:
            
            
        default:
            return  @[@1, @0, @0, @0, @0, @0, @0, @0, @0, @0];
    }
    
}

- (NSArray *)numberToFeatures:(NSNumber *)number {
    switch (number.integerValue) {
        case 0:
            return   @[@1, @1, @1, @1,
                       @1, @1, @1, @1,
                       @1, @1, @0, @0,
                       @0, @0, @0, @0,
                       @0, @1, @1, @0,
                       @0, @0, @0, @0,
                       @0, @0, @1, @1,
                       @1, @1, @1, @1,
                       @1, @1, @1, @1];
            
        case 1:
            return                 @[@1, @1, @1, @1,
                                     @1, @1, @1, @1,
                                     @1, @1, @0, @0,
                                     @0, @0, @0, @0,
                                     @0, @1, @1, @0,
                                     @0, @0, @0, @0,
                                     @0, @0, @1, @1,
                                     @1, @1, @1, @1,
                                     @1, @1, @1, @1];
            
            // 1
        case 2:
            return                  @[@0, @0, @0, @0,
                                      @0, @0, @0, @0,
                                      @0, @0, @0, @0,
                                      @0, @0, @0, @0,
                                      @0, @0, @0, @0,
                                      @0, @0, @0, @0,
                                      @0, @0, @0, @1,
                                      @1, @1, @1, @1,
                                      @1, @1, @1, @1];
            
            // 2
        case 3:
            return             @[@1, @0, @0, @0,
                                 @1, @1, @1, @1,
                                 @1, @1, @0, @0,
                                 @0, @1, @0, @0,
                                 @0, @1, @1, @0,
                                 @0, @0, @1, @0,
                                 @0, @0, @1, @1,
                                 @1, @1, @1, @1,
                                 @0, @0, @0, @1];
            
            // 3
        case 4:
            return                 @[@1, @0, @0, @0,
                                     @1, @0, @0, @0,
                                     @1, @1, @0, @0,
                                     @0, @1, @0, @0,
                                     @0, @1, @1, @0,
                                     @0, @0, @1, @0,
                                     @0, @0, @1, @1,
                                     @1, @1, @1, @1,
                                     @1, @1, @1, @1];
            
            // 4
        case 5:
            return                  @[@1, @1, @1, @1,
                                      @1, @0, @0, @0,
                                      @0, @0, @0, @0,
                                      @0, @1, @0, @0,
                                      @0, @0, @0, @0,
                                      @0, @0, @1, @0,
                                      @0, @0, @0, @1,
                                      @1, @1, @1, @1,
                                      @1, @1, @1, @1];
            
            // 5
        case 6:
            return                       @[@1, @1, @1, @1,
                                           @1, @0, @0, @0,
                                           @1, @1, @0, @0,
                                           @0, @1, @0, @0,
                                           @0, @1, @1, @0,
                                           @0, @0, @1, @0,
                                           @0, @0, @1, @1,
                                           @0, @0, @0, @1,
                                           @1, @1, @1, @1];
            
            // 6
        case 7:
            return                   @[@1, @1, @1, @1,
                                       @1, @1, @1, @1,
                                       @1, @1, @0, @0,
                                       @0, @1, @0, @0,
                                       @0, @1, @1, @0,
                                       @0, @0, @1, @0,
                                       @0, @0, @1, @1,
                                       @0, @0, @0, @1,
                                       @1, @1, @1, @1];
            
            // 7
        case 8:
            return                   @[@1, @0, @0, @0,
                                       @0, @0, @0, @0,
                                       @0, @1, @0, @0,
                                       @0, @0, @0, @0,
                                       @0, @0, @1, @0,
                                       @0, @0, @0, @0,
                                       @0, @0, @0, @1,
                                       @1, @1, @1, @1,
                                       @1, @1, @1, @1];
            
            // 8
        case 9:
            return                      @[@1, @1, @1, @1,
                                          @1, @1, @1, @1,
                                          @1, @1, @0, @0,
                                          @0, @1, @0, @0,
                                          @0, @1, @1, @0,
                                          @0, @0, @1, @0,
                                          @0, @0, @1, @1,
                                          @1, @1, @1, @1,
                                          @1, @1, @1, @1];
            
            // 9
        case 10:
            return                @[@1, @1, @1, @1,
                                    @1, @0, @0, @0,
                                    @0, @1, @0, @0,
                                    @0, @1, @0, @0,
                                    @0, @0, @1, @0,
                                    @0, @0, @1, @0,
                                    @0, @0, @0, @1,
                                    @1, @1, @1, @1,
                                    @1, @1, @1, @1];
            
            
        default:
            return  @[@1, @1, @1, @1,
                      @1, @1, @1, @1,
                      @1, @1, @0, @0,
                      @0, @0, @0, @0,
                      @0, @1, @1, @0,
                      @0, @0, @0, @0,
                      @0, @0, @1, @1,
                      @1, @1, @1, @1,
                      @1, @1, @1, @1];
    }
}

@end
