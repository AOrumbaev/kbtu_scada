//
//  AOPlotView.m
//  KBTU_SCADA
//
//  Created by Altynbek Orumbayev on 16/11/2016.
//  Copyright © 2016 A_Orumbayev. All rights reserved.
//

#import "AOPlotViewController.h"
#import "MBXLineGraphDataSource.h"
#import "MBXGraphView.h"
#import "MBXGraphAxisView.h"
#import "Constants.h"
#import "AOSensor.h"
#import "AOStorage.h"

#import "MBXChartVM.h"

@interface AOPlotViewController ()<MBXGraphDelegate, MBXGraphAxisDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet MBXGraphView *viewGraph;
@property (strong, nonatomic) MBXGraphAxisView *viewYAxis;
@property (strong, nonatomic) MBXGraphAxisView *viewXAxis;
@property (assign, nonatomic) BOOL trainingMode;
@property (nonatomic, strong) MBXLineGraphDataSource *dataSourceNib;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *sensors;

@end

@implementation AOPlotViewController

static AOPlotViewController * sharedInstance = nil;

////////////////////////////////////
#pragma mark - Lazy getters
////////////////////////////////////

- (MBXLineGraphDataSource *)dataSourceNib{
    if(!_dataSourceNib){
        _dataSourceNib = [MBXLineGraphDataSource new];
    }
    return _dataSourceNib;
}

////////////////////////////////////
#pragma mark - Life cycle
////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewXAxis = [[MBXGraphAxisView alloc] init];
    self.viewYAxis = [[MBXGraphAxisView alloc] init];
    
    // nib created graph
    self.viewGraph.dataSource = self.dataSourceNib;
    self.viewYAxis.dataSource = self.dataSourceNib;
    self.viewXAxis.dataSource = self.dataSourceNib;
    
    self.viewXAxis.direction = kDirectionHorizontal;
    self.viewYAxis.direction = kDirectionVertical;
    
    self.viewGraph.delegate = self;
    self.viewXAxis.delegate = self;
    self.viewYAxis.delegate = self;
    [self.view addSubview:self.viewXAxis];
    [self.view addSubview:self.viewYAxis];
    
    self.dataSourceNib.xAxisCalc = MBXLineGraphDataSourceAxisCalcValueTickmark | MBXLineGraphDataSourceAxisCalcValueDistribute;
    self.dataSourceNib.yAxisCalc = MBXLineGraphDataSourceAxisCalcAutoTickmark | MBXLineGraphDataSourceAxisCalcValueDistribute;
    
    [self setRandomValuesForAllDataSources];
    _trainingMode = YES;
    
    self.sensors.delegate = self;
    self.sensors.dataSource = self;
    
}
- (void)viewDidAppear:(BOOL)animated{
    [self reload];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self reload];
}


- (void)updateViewConstraints {
    
    [super updateViewConstraints];
    
    self.viewXAxis.frame = CGRectMake(self.viewGraph.frame.origin.x, self.viewGraph.frame.origin.y + self.viewGraph.frame.size.height, self.viewGraph.frame.size.width, 30);
    self.viewYAxis.frame = CGRectMake(self.viewGraph.frame.origin.x - 30, self.viewGraph.frame.origin.y, 30, self.viewGraph.frame.size.height);
    
}

+ (AOPlotViewController *)sharedInstance {
    
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
        sharedInstance.dataSetArray = [[NSMutableArray alloc] init];
        // Do any other initialisation stuff here
    }
    
    return sharedInstance;
}

////////////////////////////////////
#pragma mark - MBXLineGraphDelegate
////////////////////////////////////
- (void)MBXLineGraphView:(MBXGraphView *)graphView configureAppearanceGraphVM:(MBXGraphVM *)graphVM{
    
    if(graphView == self.viewGraph){
        graphVM.color = [UIColor greenColor];
        graphVM.drawingType =  MBXLineGraphDawingTypeLine | MBXLineGraphDawingTypeFill;
        graphVM.fillColor = UIColorFromRGB(0x228291);
        graphVM.fillOpacity = 0.4;
        graphVM.priority = 1000;
    }else{
        
        if([graphVM.uid isEqualToString:@"0"]){
            graphVM.color = [UIColor blueColor];
            graphVM.lineStyle = MBXLineStyleDotDash;
            graphVM.drawingType = MBXLineGraphDawingTypeLine | MBXLineGraphDawingAnimated;
        }else{
            graphVM.color = [UIColor purpleColor];
            graphVM.lineStyle = MBXLineStyleDashed;
            graphVM.drawingType = MBXLineGraphDawingTypeLine | MBXLineGraphDawingAnimated;
        }
        graphVM.priority = 1000;
        graphVM.animationDuration = 0.5f;
    }
    
}
- (CGSize)MBXLineGraphView:(MBXGraphView *)graphView markerSizeAtIndex:(NSInteger)index{
    return CGSizeMake(8, 8);
}
- (BOOL)MBXLineGraphView:(MBXGraphView *)graphView hasMarkerAtIndex:(NSInteger)index{
    return YES;
}

- (CALayer *)MBXLineGraphView:(MBXGraphView *)graphView markerViewForGraphVM:(MBXGraphVM *)graphVM ForPointAtIndex:(NSInteger)index{
    CALayer *marker = [CALayer layer];
    [marker setMasksToBounds:YES];
    if ([graphVM.uid isEqualToString:@"0"]) {
        [marker setBorderWidth:1.0];
        [marker setBackgroundColor:[UIColor whiteColor].CGColor];
        [marker setBorderColor:[UIColor greenColor].CGColor];
    }else{
        [marker setBackgroundColor:[UIColor greenColor].CGColor];
    }
    [marker setCornerRadius:8/2];
    return marker;
}

- (UIView *)MBXGraphAxis:(MBXGraphAxisView *)graphAxis ViewForValue:(NSNumber *)value{
    UILabel *label = [UILabel new];
    label.font =[UIFont systemFontOfSize:9];
    label.text = [value stringValue];
    [label sizeToFit];
    return label;
}
- (NSInteger)MBXGraphAxisTicksHeight:(MBXGraphAxisView *)graphAxis{
    return 1;
}
- (NSInteger)MBXGraphAxisTicksWidth:(MBXGraphAxisView *)graphAxis{
    return 1;
}
- (UIColor *)MBXGraphAxisColor:(MBXGraphAxisView *)graphAxis{
    return [UIColor purpleColor];
}

////////////////////////////////////
#pragma mark - helpers
////////////////////////////////////
- (void)reload{
    [self.viewGraph reload];
    [self.viewYAxis reload];
    [self.viewXAxis reload];
    [self.sensors reloadAllComponents];
}
- (void) setRandomValuesForAllDataSources{
    [self setRandomValuesForDataSource:self.dataSourceNib];
}
- (void) setRandomValuesForDataSource:(MBXLineGraphDataSource *)dataSource{
    NSMutableArray *graphValues = @[].mutableCopy;
    
    for (int i = 0; i < 10; i++) {
        [graphValues addObject:@{@"y":[self rand], @"x" : [NSNumber numberWithInt:i]}];
    }
    
    
    
    [dataSource setGraphValues:graphValues.copy];
}
- (NSNumber *) rand{
    int max = 50;
    int min = 30;
    int randNum = rand() % (max - min) + min; //create the random number.
    return [NSNumber numberWithInt:randNum];
}

#pragma mark - Segmented Control

- (IBAction)generateDataDidPressed:(id)sender {
    
    if (_trainingMode) {
        
        NSMutableArray *graphValues = @[].mutableCopy;
        
        for (int i = 0; i < 20; i++) {
            [graphValues addObject:@{@"y":[self rand], @"x" : [NSNumber numberWithInt:i]}];
        }
        
        [self.dataSourceNib setGraphValues:graphValues.copy];
        
        [[AOPlotViewController sharedInstance].dataSetArray addObjectsFromArray:graphValues];
        self.infoLabel.text = [NSString stringWithFormat:@"%lu records in dataset",[AOPlotViewController sharedInstance].dataSetArray.count];
    }
    
    else {
        [self setRandomValuesForAllDataSources];
    }
    
    
    [self reload];
}

- (IBAction)generationModeChanged:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        _trainingMode = YES;
    }
    
    else {
        [AOPlotViewController sharedInstance].dataSetArray = @[].mutableCopy;
        self.infoLabel.text = [NSString stringWithFormat:@"%lu records in dataset",[AOPlotViewController sharedInstance].dataSetArray.count];
        _trainingMode = NO;
    }
}

#pragma mark - Picker Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 200;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *returnStr = @"";
    if (pickerView == self.sensors)
    {
        Sensor *curSensor = [Storage sharedInstance].sensorsArray[row];
        returnStr = curSensor.title;
    }
    
    return returnStr;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[Storage sharedInstance].sensorsArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end
